import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constantes/estadoBolsa.dart';

import 'package:flutter_app/modeloControlador/Controller.dart';

class pantalla_invertir extends StatelessWidget {
  late String _input;
  late String _cantidad;
  late String _interes;
  late String _anios;

  pantalla_invertir({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Cantidad €'),
      keyboardType: TextInputType.number,
      validator: (_input) {
        if (_input!.isEmpty) {
          return 'Campo obligatorio';
        }
        if(!Controller.tieneSaldo(double.parse(_input))){
          return 'No tiene suficiente saldo';
        }

        return null;
      },
      onSaved: (_input) {
        _cantidad = _input!;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Interés'),
      keyboardType: TextInputType.number,
      validator: (_input) {
        if (_input!.isEmpty) {
          return 'Campo obligatorio';
        }

        return null;
      },
      onSaved: (_input) {
        _interes = _input!;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Años'),
      keyboardType: TextInputType.number,
      validator: (_input) {
        if (_input!.isEmpty) {
          return 'Campo obligatorio';
        }

        return null;
      },
      onSaved: (_input) {
        _anios = _input!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Realizar Inversión")),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Container(
            child: Column(
              children: <Widget>[
                Text("ESTADO BOLSA: ",
                    style: TextStyle(color: Colors.black, fontSize: 17),
                    textDirection: TextDirection.ltr),
                if(Controller.miEstadoBolsa == EstadoBolsa.BAJANDO)
                  Text("${Controller.miEstadoBolsa.toString().split('.').last}",
                      style: TextStyle(color: Colors.redAccent, fontSize: 17, fontWeight: FontWeight.bold),
                      textDirection: TextDirection.ltr),
                if(Controller.miEstadoBolsa == EstadoBolsa.SUBIENDO)
                  Text("${Controller.miEstadoBolsa.toString().split('.').last}",
                      style: TextStyle(color: Colors.teal, fontSize: 17, fontWeight: FontWeight.bold),
                      textDirection: TextDirection.ltr),
                if(Controller.miEstadoBolsa == EstadoBolsa.NORMAL)
                  Text("${Controller.miEstadoBolsa.toString().split('.').last}",
                      style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                      textDirection: TextDirection.ltr),
                Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildName(),
                        _buildEmail(),
                        _buildPassword(),
                        SizedBox(height: 40),
                        Text('NOTA: Hoy el banco cobra una comision del ${Controller.comisionHoy} %'),
                        SizedBox(height: 40),
                        RaisedButton(
                          child: Text(
                            'Mandar solicitud',
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                          onPressed: () async{
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            _formKey.currentState!.save();

                            Controller.realizarInversion(_cantidad, _anios, _interes, context);

                          },
                        ),
                      ],
                    ),
                  ),

              ],
            ),
          )
        ),
      ),
    );
  }
}

