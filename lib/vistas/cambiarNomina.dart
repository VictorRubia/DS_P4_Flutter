import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

showAlertCambiarNomina(BuildContext context, int idUsuario) {

  String _baseAddress='clados.ugr.es';

  String _applicationName='DS5/api/v1/';
  final _cambiarpassController = TextEditingController();
  String _nuevaPass;

  /////////// update /////////
  Future<bool> cambiarPass(String nueva) async{
    final http.Response response = await http.put(
      Uri.https(_baseAddress, _applicationName+'accounts/'+idUsuario.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nomina': nueva,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200){
      print("CAMBIO LA NOMINA");
      return true;
    }
    else
      throw Exception('ERROR');
  }

  Future<bool> _procesarPeticion() async {
    _nuevaPass = _cambiarpassController.text;
    try {
      // You could consider using async/await here
      await cambiarPass(_nuevaPass);
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;
  }

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancelar"),
    onPressed:  () {Navigator.of(context).pop();},
  );
  Widget continueButton = FlatButton(
    child: Text("Cambiar"),
    onPressed:  () {
      Navigator.of(context).pop();
      _procesarPeticion();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Nomina cambiada!'),
        ),
      );
    },
  );


  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Cambiar nómina"),
    content: new SingleChildScrollView(
      child: Form(
        child: ListBody(
          children: <Widget>[
            new Text(
              'Introduzca su nueva nómina.',
              style: TextStyle(fontSize: 14.0),
            ),
            Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Icon(
                    FontAwesomeIcons.euroSign,
                    color: Colors.indigo,
                  ),
                ),
                new Expanded(
                  child: TextFormField(
                    onSaved: (String? val) {
                      _nuevaPass = val!;
                    },
                    controller: _cambiarpassController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Nómina',
                        contentPadding:
                        EdgeInsets.only(left: 10.0, top: 15.0),
                        hintStyle:
                        TextStyle(color: Colors.black, fontSize: 14.0)),
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
            new Column(children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                    border: new Border(
                        bottom: new BorderSide(
                            width: 0.5, color: Colors.black))),
              )
            ]),
          ],
        ),
      ),
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}