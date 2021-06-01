import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/modeloControlador/Prestamo.dart';
import 'package:flutter_app/modeloControlador/Controller.dart';

class pantalla_solicitar_tarjetas extends StatelessWidget {
  Future<List<Prestamo>> prestamos = Controller.getPrestamos(Controller.idUsuario.toString());

  pantalla_solicitar_tarjetas({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text("Solicitar Tarjeta")),
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
                  "Información",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Si usted ha perdido o le han robado una tarjeta y quiere solicitar una nueva lo puede hacer aquí.",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(100),
                  child: ElevatedButton(
                    child: Text(
                      'Solicitar Tarjeta',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () async{

                      Controller.solicitarTarjeta();
                      Controller.actualizar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Tarjeta solicitada!'),
                        ),
                      );
                    },
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

