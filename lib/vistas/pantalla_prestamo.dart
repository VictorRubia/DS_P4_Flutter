import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/modeloControlador/Prestamo.dart';
import 'package:flutter_app/vistas/pagarPrestamo.dart';
import 'package:flutter_app/modeloControlador/Controller.dart';

class pantalla_prestamo extends StatelessWidget {
  late String _cantidad;
  late String _interes;
  late String _anios;
  late String _concepto;

  Future<List<Prestamo>> prestamos = Controller.getPrestamos(Controller.idUsuario.toString());

  pantalla_prestamo({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _campoCantidad() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Cantidad €'),
      keyboardType: TextInputType.number,
      validator: (_input) {
        if (_input!.isEmpty) {
          return 'Campo obligatorio';
        }

        if(double.parse(_input) > 500000)
          return 'Para pedir cantidades tan altas acuda al banco!';

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
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text("Área de Préstamos")),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                              pantalla_pagar_prestamo()));
                    },
                    title: Text(
                      'Pagar un préstamo',
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
                Text(
                  "Solicitar un préstamo",
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
                        _campoCantidad(),
                        _campoInteres(),
                        _campoAnios(),
                        _campoConcepto(),
                        //_buildAlertDialog(context),
                        SizedBox(height: 30),
                        ElevatedButton(
                          child: Text(
                            'Mandar solicitud',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () async{
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            _formKey.currentState!.save();

                            Controller.solicitarPrestamo(_cantidad, _anios, _interes, _concepto, context);
                            Controller.actualizar();
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

