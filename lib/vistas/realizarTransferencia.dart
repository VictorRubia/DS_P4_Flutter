import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/modeloControlador/Controller.dart';

class pantalla_transferencias extends StatelessWidget {
  late String _cantidad;
  late String _idCuenta;
  late String _concepto;

  pantalla_transferencias({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _campoCuenta() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Nº de Cuenta Destino'),
      keyboardType: TextInputType.number,
      validator: (_input) {
        if (_input!.isEmpty) {
          return 'Campo obligatorio';
        }
        if(_input == (Controller.idUsuario.toString())){
          return 'No puede hacerse una transferencia a sí mismo';
        }

        return null;
      },
      onSaved: (_input) {
        _idCuenta = _input!;
      },
    );
  }

  Widget _campoCantidad() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Cantidad €'),
      keyboardType: TextInputType.number,
      validator: (_input) {
        if (_input!.isEmpty) {
          return 'Campo obligatorio';
        }
        if(_input.contains('-')){
          return 'No puede introducir valores negativos!';
        }

        return null;
      },
      onSaved: (_input) {
        _cantidad = _input!;
      },
    );
  }

  Widget _campoConcepto() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Concepto'),
      keyboardType: TextInputType.name,
      validator: (_input) {
        if (_input!.isEmpty) {
          return 'Campo obligatorio';
        }

        return null;
      },
      onSaved: (_input) {
        _concepto = _input!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text("Realizar Transferencia")),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 15.0),
                Text(
                  "Introduzca los siguientes datos",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _campoCuenta(),
                        _campoCantidad(),
                        _campoConcepto(),
                        //_buildAlertDialog(context),
                        SizedBox(height: 30),
                        ElevatedButton(
                          child: Text(
                            'Realizar Transferencia',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () async{
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            _formKey.currentState!.save();

                            Controller.realizarTransferencia(_idCuenta, _cantidad, _concepto);
                            Controller.actualizar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Transferencia realizada!'),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}

