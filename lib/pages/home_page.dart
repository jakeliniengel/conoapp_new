import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:conoappnew/models/news.dart';
import 'package:conoappnew/models/symptom.dart';
import 'package:conoappnew/utils/date_utils.dart';
import 'package:conoappnew/widgets/image_checkbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:conoappnew/models/user.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  final User user;
  static final from = DateUtils.dateToString(DateTime.now());
  static final to = DateUtils.dateToString(DateTime.now());
  final newsUrl= "http://newsapi.org/v2/everything?q=coronavirus&language=pt&from=$from&to=$to&apiKey=04e98dcb371e487cad8c2da51e8a09c6";
  HomePage({
    Key key,
    this.user,
  }): super(key:key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  bool _check= false;
  int total=0;

  var newsData;
  List articles;
  List<News> news;
  var refreshNews =  GlobalKey<RefreshIndicatorState>();
  List<Symptom> symptoms;

  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  var addresses;
  var first;

  getLocation()async{

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
   print( _locationData.longitude);
   localizacao(_locationData.latitude, _locationData.longitude);
  }

  Future<String> getData() async{
    refreshNews.currentState?.show(atTop: false);
    var response = await http.get(
      Uri.encodeFull(widget.newsUrl),
      headers:{
        'Accept': 'application/json',
      }
    );

    var symptomsAssets = await DefaultAssetBundle.of(context).loadString("assets/data/symptoms.json");
    var symptomList = json.decode(symptomsAssets) as List; //cria uma lista dos sintomas

  //  print(symptomList);

    this.setState(() {
      newsData = jsonDecode(response.body);
      articles = newsData["articles"] as List;
      news = articles.map<News>((json) => News.fromJson(json)).toList();
      symptoms = symptomList.map<Symptom>((json) => Symptom.fromJson(json)).toList();
    });
    return "SUuuucesso!";
  }
   DateTime convert(String data){
      List newData = data.replaceAll("(", "").split("T");
      return DateTime.parse(newData[0]);
   }

  void initState(){
    super.initState();
    Future.delayed(Duration(milliseconds: 100)).then((_){
      this.getData();
    });
    getLocation();
  }

  void localizacao(lat, lon) async{
    final coordinates = new Coordinates(lat, lon);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
  }
  // retorna o body conforme o item de tela clicado
  Widget _getBody() {

    switch (_index) {
      case 0: return RefreshIndicator(
          key: refreshNews,
          child:ListView.builder(
          itemCount: news==null?0: news.length,
          itemBuilder: (BuildContext context, int index){
            return new Card(
              color: Colors.white70,
                margin: EdgeInsets.all(5),
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 5),
                        child: ListTile(
                          title: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text('${news[index].title}', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15),),
                                    width: MediaQuery.of(context).size.width*.4,
                                  ),
                                  Container(
                                    child: Text('(${news[index].author})', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15),),
                                    width: MediaQuery.of(context).size.width*.2,
                                    padding: EdgeInsets.only(bottom: 10),
                                  ),
                                ],
                              ),
                              Divider(),

                              Container(
                                width: MediaQuery.of(context).size.width*3,
                                child: Text(DateUtilsBr.format(convert(news[index].publishedAt))),
                              ),
                              Divider(),
                            ],
                          ),
                          leading: Image.network('${news[index].imageUrl}', width: 80, ),
                          subtitle: Text('${news[index].content}', textAlign: TextAlign.justify, overflow: TextOverflow.visible,) ,
                          isThreeLine: true,

                        )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*8,
                      child: Text(news[index].source.name, style: TextStyle(fontSize: 10, color: Colors.grey),),
                    )
                  ],
                )

            );
          }
      ),
          onRefresh: getData
      ); break;
      case 1: return Column(
        children: <Widget>[
        Text("Teste rápido de sintomas"),
        //TODO imprimir o nome da cidade ao invés das coordenadas - tema de casa  - https://pub.dev/packages/geocoder
        _locationData.longitude==null?Text(""): Text("Localização: ${first.addressLine}"),

          Expanded(
          child: ListView.builder(
              itemCount: symptoms==null?0 : symptoms.length,
              itemBuilder: (BuildContext context, int index){
                print(_check);
                return new ImageCheckBox(
                  value: _check,
                  onChanged: (bool val) async => setState(() {
                    if(val) total+=symptoms[index].weight;
                    else total-= symptoms[index].weight;
                  }),
                  checkDescription: symptoms[index].name,
                );
              }
          ),
        ),
          RaisedButton(
            child: Text("Testar"),
            onPressed: (){
              print(total);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Resultado"),
                    content: LinearProgressIndicator(
                      value: total.toDouble()/100,
                      valueColor: total<50?AlwaysStoppedAnimation(Colors.green): total<75? AlwaysStoppedAnimation(Colors.orange): AlwaysStoppedAnimation(Colors.red),
                      backgroundColor: Colors.grey
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Fechar'),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      )

                    ],
                  );
                }
              );
            },
          )
        ],
      );

    break;
      case 2: return Container(height: 500, color: Colors.yellow); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var byte = null;
    if(widget.user.photo!=null){
      byte = base64.decode(widget.user.photo.toString());
    }
    return Scaffold(
      appBar: AppBar(
          title: Text('Corona App')
      ),
      drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName:
                Text(widget.user.name.toString()),
                //Text("Nome"),
                accountEmail:
                Text(widget.user.email.toString()),
                //Text("email"),
                currentAccountPicture: Settings().onBoolChanged(
                  settingKey: 'opc_show_photo',
                  defaultValue: true,
                  childBuilder: (BuildContext context, bool value){
                    return value ? CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage: byte != null ? MemoryImage(byte) : AssetImage('assets/image/images.png'),
                      //AssetImage('assets/images/splash.png'),
                    ) : Text('');
                  },
                )
              ),
              ListTile(
                  title: Text('Configuração'),
                  leading: Icon(Icons.settings),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.pushNamed(context, '/SettingsPage');
                  }
              ),
              ListTile(
                  title: Text('Sair'),
                  leading: Icon(Icons.subdirectory_arrow_left),
                  onTap: () {
                    SystemNavigator.pop();
                    if(Platform.isAndroid) exit(0);
                  }),
            ],
          )
      ),
      body: _getBody(), // aciona o método que retorna o widget body
      bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) => setState(() {
            _index = index;
            debugPrint('$_index');
          }),
          backgroundColor: Color(0xFF8cd912),
          currentIndex: _index,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.new_releases),
                title: Text('Notícias')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.accessibility),
                title: Text('Diagnóstico')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_late),
                title: Text('Sobre')
            ),
          ]
      ),
    );
  }
}


