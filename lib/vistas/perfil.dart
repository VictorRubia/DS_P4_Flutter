import 'package:flutter/material.dart';
import 'package:flutter_app/modeloControlador/Controller.dart';
import 'package:flutter_app/modeloControlador/Notificaciones.dart';
import 'package:flutter_app/vistas/cambiarNombre.dart';
import 'package:flutter_app/vistas/cambiarNomina.dart';
import 'package:flutter_app/vistas/cambiarPass.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constantes/colores.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'login.dart';

class perfil extends StatefulWidget {
  perfil({Key? key}) : super(key: key);

  @override
  _perfilState createState() => _perfilState();
}

class _perfilState extends StateMVC {
  _perfilState() : super(Controller());

  @override
  Widget build(BuildContext context) {
    Future<List<Notificaciones>> prueba =
        Controller.getNotificaciones(Controller.idUsuario.toString());

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.powerOff),
            onPressed: () {
              Controller.limpiarSesion();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => login()));
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 8),
        child: FutureBuilder<List<Notificaciones>>(
          future: prueba, // a previously-obtained Future<String> or null
          builder: (BuildContext context,
              AsyncSnapshot<List<Notificaciones>> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = Stack(
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
                              //open edit profile
                              showAlertCambiarNombre(
                                  context, Controller.idUsuario);
                              Controller.limpiarSesion();
                            },
                            title: Text(
                              '${Controller.nombre}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/profile.png'),
                            ),
                            trailing: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Card(
                          elevation: 4.0,
                          margin:
                              const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(
                                  Icons.lock_outline,
                                  color: Colors.indigo,
                                ),
                                title: Text("Cambiar Contraseña"),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                onTap: () {
                                  //open change password
                                  showAlertCambiarPass(
                                      context, Controller.idUsuario);
                                },
                              ),
                              _buildDivider(),
                              ListTile(
                                leading: Icon(
                                  FontAwesomeIcons.handHoldingUsd,
                                  color: Colors.indigo,
                                ),
                                title: Text("Cambiar Nómina"),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                onTap: () {
                                  //open change language
                                  showAlertCambiarNomina(
                                      context, Controller.idUsuario);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Área de Notificaciones",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                if (Controller.tieneNotificacionesSinBorrar())
                                  IconButton(
                                    icon: Icon(FontAwesomeIcons.minusCircle,
                                        color: Colors.redAccent),
                                    onPressed: () async {
                                      // LIMPIAR NOTIFICACIONES
                                      late bool resultado;

                                      if (Controller.getNumNotificaciones() > 0)
                                        resultado = await Controller
                                            .borrarNotificaciones();

                                      if (resultado) {
                                        setState(() {});
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                                'Notificaciones borradas'),
                                          ),
                                        );
                                        setState(() {});
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text('Error :('),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        if (Controller.getNumNotificaciones() > 0)
                          ListView.builder(
                            itemCount: snapshot.data!.length,
                            padding: EdgeInsets.only(left: 16, right: 16),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                height: 76,
                                margin: EdgeInsets.only(bottom: 13),
                                padding: EdgeInsets.only(
                                    left: 15, top: 12, bottom: 12, right: 22),
                                decoration: BoxDecoration(
                                  color: kWhiteColor,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kTenBlackColor,
                                      blurRadius: 10,
                                      spreadRadius: 5,
                                      offset: Offset(8.0, 8.0),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          height: 57,
                                          width: 57,
                                          child: Icon(
                                            FontAwesomeIcons.bell,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 13,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            if (Controller.getNotificacion(
                                                        index)
                                                    .tipo ==
                                                1)
                                              Text(
                                                'Prestamo ${Controller.getNotificacion(index).idObjetivo}',
                                                style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: kBlackColor),
                                              ),
                                            if (Controller.getNotificacion(
                                                        index)
                                                    .tipo ==
                                                2)
                                              Text(
                                                'Tarjeta',
                                                style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: kBlackColor),
                                              ),
                                            if (Controller.getNotificacion(
                                                        index)
                                                    .resuelto ==
                                                1)
                                              Text(
                                                'Estado: RESUELTO',
                                                style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: kGreyColor),
                                              ),
                                            if (Controller.getNotificacion(
                                                        index)
                                                    .resuelto ==
                                                0)
                                              Text(
                                                'Estado: PENDIENTE',
                                                style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: kGreyColor),
                                              ),
                                            if (Controller.getNotificacion(
                                                        index)
                                                    .resuelto ==
                                                -1)
                                              Text(
                                                'Estado: DENEGADO',
                                                style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: kGreyColor),
                                              ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        if (Controller.getNotificacion(index)
                                                .resuelto ==
                                            1)
                                          Icon(
                                            FontAwesomeIcons.check,
                                            color: Colors.lightGreen,
                                          ),
                                        if (Controller.getNotificacion(index)
                                                .resuelto ==
                                            0)
                                          Icon(
                                            FontAwesomeIcons.spinner,
                                            color: Colors.grey,
                                          ),
                                        if (Controller.getNotificacion(index)
                                                .resuelto ==
                                            -1)
                                          Icon(
                                            FontAwesomeIcons.timesCircle,
                                            color: Colors.redAccent,
                                          ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 60.0),
                      ],
                    ),
                  )
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
