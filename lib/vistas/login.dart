import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_login/flutter_login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class login extends StatelessWidget {

  static int idUsuario = 0;

  static String _baseAddress='clados.ugr.es';
  static String _applicationName='/DS5/api/v1/';

  Duration get loginTime => Duration(milliseconds: 1000);

  //////////// get //////////////////
  static Future<String> getPasswd(String dni) async {
    final response = await http.get(
        Uri.https(_baseAddress, _applicationName+'login/'+dni),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );


    if (response.statusCode == 200) {
      //ok
        Map<String, dynamic> json = jsonDecode(response.body);
        print(json);
        return json['password'];
    }
    else if(response.statusCode == 404){
        return 'Usuario no encontrado';
    }
    else
        throw Exception('Failed to get password');
  }

  //////////// get //////////////////
  static Future<int> getId(String dni) async {
    final response = await http.get(
        Uri.https(_baseAddress, _applicationName+'login/'+dni),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );

    if (response.statusCode == 200) {
      //ok
      Map<String, dynamic> json = jsonDecode(response.body);
      idUsuario = json['id'];
      return json['id'];
    }
    else if(response.statusCode == 404){
      return -1;
    }
    else
      throw Exception('Failed to get password');
  }


  Future<String> _authUser(LoginData data) async {
    print('Name: ${data.name}, Password: ${data.password}');
    String response = await getPasswd(data.name);
    getId(data.name);
    print(response);
    return  Future.delayed(loginTime).then((_) {
      if (response == 'Usuario no encontrado') {
        return 'Usuario no encontrado';
      }
      if (response != data.password) {
        return 'La contraseña no coincide';
      }
      return '';
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return  Future.delayed(loginTime).then((_) {
      return 'Funcion sin implementar aún';
    });
  }

  @override
  Widget build(BuildContext context) {

    return FlutterLogin(
      onLogin: _authUser,
      onSignup: _authUser,
      hideForgotPasswordButton: true,
      hideSignUpButton: true,
      footer: 'Grupo DS5',
      logo: 'assets/images/logo.png',
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyHomePage(idUsuario: idUsuario),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}