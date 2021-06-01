import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/modeloControlador/Controller.dart';
import 'package:flutter_app/vistas/resolverInversion.dart';

class pantalla_invertir extends StatelessWidget {
  late String _cantidad;
  late String _interes;
  late String _anios;
  late String _concepto;

  pantalla_invertir({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _campoCantidad() {
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

  Widget _campoInteres() {
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

  Widget _campoAnios() {
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
    Future<Map<String, dynamic>> prueba =
    Controller.getDatos(Controller.idUsuario.toString());

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text("Realizar Inversión")),
      body: Container(
        margin: EdgeInsets.only(top: 8),
        child: FutureBuilder<Map<String, dynamic>>(
          future: prueba, // a previously-obtained Future<String> or null
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                        margin: EdgeInsets.all(24),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Card(
                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                color: Colors.indigo,
                                child: ListTile(
                                  onTap: () {
                                    //open pagar prestamo

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            pantalla_resolver_inversion()));
                                  },
                                  title: Text(
                                    'Resolver una inversión',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.euro,
                                    color: Colors.white,
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Text("ESTADO BOLSA: ",
                                  style: TextStyle(color: Colors.black, fontSize: 17),
                                  textDirection: TextDirection.ltr),
                              Controller.getEstadoBolsa(),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _campoCantidad(),
                                    _campoInteres(),
                                    _campoAnios(),
                                    _campoConcepto(),
                                    SizedBox(height: 40),
                                    Text('NOTA: El banco cobra una comision del ${Controller.comisionHoy} %'),
                                    SizedBox(height: 40),
                                    ElevatedButton(
                                      child: Text(
                                        'Invertir',
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                      onPressed: () async{
                                        if (!_formKey.currentState!.validate()) {
                                          return;
                                        }
                                        _formKey.currentState!.save();

                                        await Controller.realizarInversion(_cantidad, _anios, _interes, _concepto, context);
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
                ],
              );
            } else if (snapshot.hasError) {
              child = Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              child = SizedBox(
                child: CircularProgressIndicator(),
                width: 120,
                height: 120,
              );
            }
            return Center(
              child: Container(
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}

