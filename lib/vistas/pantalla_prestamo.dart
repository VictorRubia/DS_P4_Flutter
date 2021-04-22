import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/modeloControlador/Controller.dart';

class pantalla_prestamo extends StatelessWidget {
  late String _input;
  late String _cantidad;
  late String _interes;
  late String _anios;

  pantalla_prestamo({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Cantidad €'),
      keyboardType: TextInputType.number,
      validator: (_input) {
        if (_input!.isEmpty) {
          return 'Campo obligatorio';
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
      appBar: AppBar(title: Text("Solicitar un Préstamo")),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildName(),
                _buildEmail(),
                _buildPassword(),
                //_buildAlertDialog(context),
                SizedBox(height: 100),
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

                    Controller.solicitarPrestamo(_cantidad, _anios, _interes, context);

                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

