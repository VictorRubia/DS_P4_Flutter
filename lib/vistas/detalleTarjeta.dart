import 'package:flutter/material.dart';
import 'package:flutter_app/constantes/colores.dart';
import 'package:flutter_app/modeloControlador/Controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class detalleTarjeta extends StatefulWidget {
  late int indice;

  detalleTarjeta({Key? key, required this.indice}) : super(key: key);

  @override
  _detalleTarjetaState createState() => _detalleTarjetaState(indice);
}

class _detalleTarjetaState extends StateMVC {
  late int indice;

  _detalleTarjetaState(this.indice) : super(Controller());

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> prestamos = Controller.getDatos(Controller.idUsuario.toString());

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: Text(
          'Detalles de la tarjeta',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top:8),
        child:
        FutureBuilder<Map<String, dynamic>>(
          future: prestamos, // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
                            Container(
                              margin: EdgeInsets.only(right:10),
                              height: 199,
                              width: 360,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: Color(0xFF1E1E99),
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    child: SvgPicture.asset('assets/svg/ellipse_top_pink.svg'),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: SvgPicture.asset('assets/svg/ellipse_bottom_pink.svg'),
                                  ),
                                  Positioned(
                                    left: 29,
                                    top: 38,
                                    child: Text('NÚMERO TARJETA', style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: kWhiteColor,
                                    ),),
                                  ),
                                  Positioned(
                                    left: 29,
                                    top: 55,
                                    child: Text('${Controller.getNumeroTarjetaNeto(indice)}', style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: kWhiteColor,
                                    ),),
                                  ),
                                  if(Controller.getTipoTarjeta(indice) == 'VISA')
                                    Positioned(
                                        right: 31,
                                        top: 25,
                                        child: Icon(
                                          FontAwesomeIcons.ccVisa,
                                          color: Colors.white,
                                          size: 35,
                                        )
                                    ),
                                  if(Controller.getTipoTarjeta(indice) == 'MASTERCARD')
                                    Positioned(
                                        right: 31,
                                        top: 25,
                                        child: Icon(
                                          FontAwesomeIcons.ccMastercard,
                                          color: Colors.white,
                                          size: 35,
                                        )
                                    ),
                                  Positioned(
                                    left: 29,
                                    bottom: 45,
                                    child: Text(('TITULAR'), style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: kWhiteColor,
                                    ),),
                                  ),
                                  Positioned(
                                    left: 29,
                                    bottom: 21,
                                    child: Text('${Controller.nombre} ${Controller.apellidos}', style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: kWhiteColor,
                                    ),),
                                  ),
                                  Positioned(
                                    left: 202,
                                    bottom: 45,
                                    child: Text(('CADUCA'), style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: kWhiteColor,
                                    ),),
                                  ),
                                  Positioned(
                                    left: 202,
                                    bottom: 21,
                                    child: Text(('${Controller.getFechaTarjeta(indice)}'), style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: kWhiteColor,
                                    ),),
                                  ),
                                  Positioned(
                                      right: 45,
                                      bottom: 45,
                                      child: InkWell(
                                        child: Text(('CVV'), style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: kWhiteColor,
                                        ),),
                                        onTap: () {print("value of your text");},
                                      )
                                  ),
                                  Positioned(
                                      right: 30,
                                      bottom: 21,
                                      child:  InkWell(
                                        child: Text(('${Controller.getCVV(indice)}'), style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: kWhiteColor,
                                        ),),
                                        onTap: () {

                                        },
                                      )
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                              Text(
                                "Número",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            Text(
                              "${Controller.getNumeroTarjetaNeto(indice)}",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: kBlackColor,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Fecha caducidad",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            Text(
                              "${Controller.getFechaTarjeta(indice)}",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: kBlackColor,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "CVV",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            Text(
                              "${Controller.getCVV(indice)}",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: kBlackColor,
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