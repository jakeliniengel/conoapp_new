import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  final Tween<double> turnsTween =Tween<double>(
      begin: 1,
      end: 5
  );
  // nós vamos utilizar um controller de animação
  AnimationController _controller;

  // método para chamar a tela de Login
  void navegarTelaLogin(){
    Navigator.pushNamedAndRemoveUntil(context, '/LoginPage' ,ModalRoute.withName('/LoginPage'));
  }

  iniciarSplash() async{
    var _duracao = Duration(seconds: 3);
    _controller.forward(); //direção do giro
    return new Timer(_duracao, navegarTelaLogin);
  }
  @override
  void initState(){
    super.initState();

    _controller =AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3)
    );
    iniciarSplash();
    _controller.forward();
  }
  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([]);
    return Container(
      color: Colors.white,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RotationTransition(
              turns: turnsTween.animate(_controller),
              child:  Image.asset('assets/image/login4.png', width: 200,),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Carregando', style: TextStyle(color: Colors.pink, fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}