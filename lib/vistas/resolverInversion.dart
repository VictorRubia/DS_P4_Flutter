import 'package:flutter/material.dart';
import 'package:flutter_app/modeloControlador/Controller.dart';
import 'package:flutter_app/modeloControlador/Inversion.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class pantalla_resolver_inversion extends StatefulWidget {
  static final String path = "main.dart";

  pantalla_resolver_inversion({Key? key}) : super(key: key);

  @override
  _pantalla_resolver_inversionState createState() => _pantalla_resolver_inversionState();
}

class _pantalla_resolver_inversionState extends StateMVC {

  _pantalla_resolver_inversionState() : super(Controller());


  @override
  Widget build(BuildContext context) {
    Future<List<Inversion>> prestamos = Controller.getInversiones(Controller.idUsuario.toString());

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: Text(
          'Resolver Inversión',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top:8),
        child:
        FutureBuilder<List<Inversion>>(
          future: prestamos, // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<List<Inversion>> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child =
                  Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if(snapshot.data!.length > 0)
                              Text(
                                "Seleccione un préstamo",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            if(snapshot.data!.length == 0)
                              Text(
                                "No posee inversiones",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),

                            const SizedBox(height: 10.0),
                            Card(
                              elevation: 4.0,
                              margin: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 16.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                children: <Widget>[
                                  ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Column(
                                            children: <Widget>[
                                              ListTile(
                                                leading: Icon(
                                                  FontAwesomeIcons.handHoldingUsd,
                                                  color: Colors.indigo,
                                                ),
                                                title: Text(' ${snapshot.data![index].descripcion}, ${snapshot.data![index].cantidad_actual} €'),
                                                trailing: Icon(Icons.keyboard_arrow_right),
                                                onTap: () {
                                                  //open change password
                                                    Controller.resolverInversion(snapshot.data![index]);
                                                    setState(() { });
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: const Text('Inversión resuelta!'),
                                                      ),
                                                    );
                                                  }
                                              ),
                                              _buildDivider()
                                            ]
                                        );
                                      }
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
            } else if (snapshot.hasError) {
              child =
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  );
            } else {
              child =
                  SizedBox(
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