import 'package:conoappnew/helpers/database_helper.dart';
import 'package:conoappnew/models/user.dart';
import 'package:conoappnew/pages/home_page.dart';
import 'package:conoappnew/pages/resgister_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{
  final Tween<double> turnsTween =Tween<double>(
      begin: 1,
      end: 3
  );
  AnimationController _controller;
  TextStyle style = TextStyle(fontSize: 20); // estilo geral
  // a ideia hoje é usar o conceito de formulário do flutter - widget form
  String _usuario = "";
  String _senha = "";
  final frmLoginKey = new GlobalKey<FormState>(); // serve como identificador do formulário
  var db = DatabaseHelper();

  void _validarLogin() async {
    // capturando o estado atual do formulário
    final form = frmLoginKey.currentState;

    if (form.validate()) {
      form.save();
      print("$_usuario, $_senha");
      User user = await db.validateLogin(_usuario, _senha);
      //debugPrint('$user');
     // print(user.name);
      // validando usuário e senha
      if (user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage(user: user)));
      } else {
        iniciarAnimacao();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text("Erro Login"),
                  content: Text("Usuário e/ou senha inválidos!"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  )
              );
            }
        );
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //turnsTween = Tween<double>(begin: 0, end: 300);
    _controller =AnimationController(
        lowerBound: -1.0,
        upperBound: 1.0,
        vsync: this,
        duration: const Duration(seconds: 3)
    );

  }
  iniciarAnimacao() async{
    _controller.forward(); //direção do giro
  }

  @override
  Widget build(BuildContext context) {
    final usuarioField= TextFormField(
      obscureText: false,
      style: style,
      onSaved: (valor){
        _usuario = valor;
      },
      validator: (valor){
        return valor.length<6? "Usuário deve ter no mínimo 6 caracteres": null;
        return valor.length<6? "Usuário deve ter no mínimo 6 caracteres": null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: Strings.of(context).valueOf("wg_email"),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );
    final senhaField= TextFormField(
      obscureText: true,
      style: style,
      onSaved: (valor){
        _senha = valor;
      },
      validator: (valor){
        return valor.length<6? "Senha deve ter no minimo 6 caracteres": null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: Strings.of(context).valueOf("wg_password"),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );
    return Scaffold(
        body: SingleChildScrollView(
          child: Center(
              child: Container(
                color: Colors.white70,
                child: Padding(
                    padding: const EdgeInsets.all(36),
                    child: Form(
                      key: frmLoginKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 155,
                            child:   RotationTransition(
                              turns: turnsTween.animate(_controller),
                              child:  Image.asset('assets/image/login4.png', width: 200,),
                            ),
                          ),
                          SizedBox(
                            height: 45,
                          ),
                          usuarioField,
                          SizedBox(
                            height: 15,
                          ),
                          senhaField,
                          SizedBox(
                            height: 25,
                          ),
                          RaisedButton(
                            padding: EdgeInsets.all(20),
                            color: Colors.pink,
                            child: Container(
                              width: MediaQuery.of(context).size.width*.85,
                              child: Text(Strings.of(context).valueOf("wg_login"), style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                            ),
                            focusColor: Color(0xFF8cd912),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.pinkAccent)
                            ),
                            elevation: 7.0,
                            onPressed: (){
                              _validarLogin();
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          FlatButton(
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) =>RegisterForm()
                              ),
                              child: Text(Strings.of(context).valueOf("wg_register"),
                                  style: TextStyle(fontSize: 25, color: Color(0xFFb2b2b2))
                              )
                          )
                        ],
                      ),
                    )
                ),
              )
          ),
        )
    );
  }
}
