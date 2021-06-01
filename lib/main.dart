import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/vistas/detalleTarjeta.dart';
import 'package:flutter_app/vistas/login.dart';
import 'package:flutter_app/vistas/pantalla_invertir.dart';
import 'package:flutter_app/vistas/pantalla_movimientos.dart';
import 'package:flutter_app/vistas/pantalla_simular.dart';
import 'package:flutter_app/vistas/pantalla_solicitar_tarjetas.dart';
import 'package:flutter_app/vistas/perfil.dart';
import 'package:flutter_app/vistas/realizarTransferencia.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'constantes/colores.dart';
import 'constantes/operations.dart';
import 'vistas/pantalla_prestamo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'modeloControlador/Controller.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'P4 DS',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: new login(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  int idUsuario;

  MyHomePage({Key? key, required this.idUsuario}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState(idUsuario);
}

class _MyHomePageState extends StateMVC {
  int idUsuario;
  _MyHomePageState(this.idUsuario) : super(Controller());
  int current = 0;

  // Handle Indicator
  List<T> mapa<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    Controller.limpiarSesion();
    await Controller.getDatos(idUsuario.toString());
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    Controller.limpiarSesion();
    await Controller.getDatos(idUsuario.toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> prueba =
        Controller.getDatos(idUsuario.toString());
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 8),
        child: FutureBuilder<Map<String, dynamic>>(
          future: prueba,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: WaterDropHeader(),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: ListView(
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(left: 8, bottom: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Bienvenido/a',
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF3A3A3A),
                                        ),
                                      ),
                                      Text(
                                        '${Controller.nombre} ${Controller.apellidos}',
                                        style: GoogleFonts.inter(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF3A3A3A),
                                        ),
                                      )
                                    ],
                                  )),
                              if (Controller.tieneNotificacionesSinBorrar())
                                Container(
                                    height: 59,
                                    width: 59,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/profile-notification.png')
                                        )
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (context) => perfil(),
                                          ),
                                        )
                                        .then((_) {
                                          setState(() {});
                                        });
                                      },
                                      child: Ink(height: 100, width: 100),
                                    )),
                              if (!Controller.tieneNotificacionesSinBorrar())
                                Container(
                                    height: 59,
                                    width: 59,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/profile.png'))),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) => perfil(),
                                          ),
                                        )
                                            .then((_) {
                                          setState(() {});
                                        });
                                      },
                                      child: Ink(height: 100, width: 100),
                                    )
                                ),
                            ],
                          )),
                      // Segunda sección
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 199,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(left: 16, right: 6),
                          itemCount: Controller.numTarjetas(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            detalleTarjeta(indice: index)));
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 199,
                                width: 360,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  color: Color(0xFF1E1E99),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      child: SvgPicture.asset(
                                          'assets/svg/ellipse_top_pink.svg'),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: SvgPicture.asset(
                                          'assets/svg/ellipse_bottom_pink.svg'),
                                    ),
                                    Positioned(
                                      left: 29,
                                      top: 38,
                                      child: Text(
                                        'NÚMERO TARJETA',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: kWhiteColor,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 29,
                                      top: 55,
                                      child: Text(
                                        '${Controller.getNumeroTarjeta(index)}',
                                        style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: kWhiteColor,
                                        ),
                                      ),
                                    ),
                                    if (Controller.getTipoTarjeta(index) ==
                                        'VISA')
                                      Positioned(
                                          right: 31,
                                          top: 25,
                                          child: Icon(
                                            FontAwesomeIcons.ccVisa,
                                            color: Colors.white,
                                            size: 35,
                                          )),
                                    if (Controller.getTipoTarjeta(index) ==
                                        'MASTERCARD')
                                      Positioned(
                                          right: 31,
                                          top: 25,
                                          child: Icon(
                                            FontAwesomeIcons.ccMastercard,
                                            color: Colors.white,
                                            size: 35,
                                          )),
                                    Positioned(
                                      left: 29,
                                      bottom: 45,
                                      child: Text(
                                        ('TITULAR'),
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: kWhiteColor,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 29,
                                      bottom: 21,
                                      child: Text(
                                        '${Controller.nombre} ${Controller.apellidos}',
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: kWhiteColor,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 202,
                                      bottom: 45,
                                      child: Text(
                                        ('CADUCA'),
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: kWhiteColor,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 202,
                                      bottom: 21,
                                      child: Text(
                                        ('${Controller.getFechaTarjeta(index)}'),
                                        style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: kWhiteColor,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        right: 45,
                                        bottom: 45,
                                        child: InkWell(
                                          child: Text(
                                            ('CVV'),
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: kWhiteColor,
                                            ),
                                          ),
                                          onTap: () {
                                            print("value of your text");
                                          },
                                        )),
                                    Positioned(
                                        right: 30,
                                        bottom: 21,
                                        child: InkWell(
                                          child: Text(
                                            ('XXX'),
                                            style: GoogleFonts.inter(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: kWhiteColor,
                                            ),
                                          ),
                                          onTap: () {
                                            print("value of your text");
                                          },
                                        ))
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      //Operaciones
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16, bottom: 13, top: 29, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Operaciones',
                              style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF3A3A3A)),
                            ),
                            Row(
                              children: mapa<Widget>(
                                datas,
                                (index, selected) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    height: 9,
                                    width: 9,
                                    margin: EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: current == index
                                            ? Color(0xFF1E1E99)
                                            : Color(0x201E1E99)),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        height: 123,
                        child: ListView.builder(
                          itemCount: datas.length,
                          padding: EdgeInsets.only(left: 16),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  current = index;
                                  if (index == 0) {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            pantalla_prestamo(),
                                      ),
                                    )
                                        .then((_) {
                                      // Call setState() here or handle this appropriately
                                      setState(() {});
                                    });
                                  }
                                  if (index == 1) {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            pantalla_invertir(),
                                      ),
                                    )
                                        .then((_) {
                                      // Call setState() here or handle this appropriately
                                      setState(() {});
                                    });
                                  }
                                  if (index == 2) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                pantalla_simular()));
                                  }
                                  if (index == 3) {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            pantalla_transferencias(),
                                      ),
                                    )
                                        .then((_) {
                                      // Call setState() here or handle this appropriately
                                      setState(() {});
                                    });
                                  }
                                  if (index == 4) {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            pantalla_solicitar_tarjetas(),
                                      ),
                                    )
                                        .then((_) {
                                      // Call setState() here or handle this appropriately
                                      setState(() {});
                                    });
                                  }
                                });
                              },
                              child: OperationCard(
                                  operation: datas[index].name,
                                  selectedIcon: datas[index].selectedIcon,
                                  unselectedIcon: datas[index].unselectedIcon,
                                  isSelected: current == index,
                                  context: this),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16, bottom: 13, top: 29, right: 10),
                        child: Text(
                          'Mis Cuentas',
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: kBlackColor),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => pantalla_movimientos(),
                              ),
                            )
                                .then((_) {
                              // Call setState() here or handle this appropriately
                              setState(() {});
                            });
                          });
                        },
                        child: ListView.builder(
                          itemCount: Controller.numCuentas(),
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
                                          FontAwesomeIcons.wallet,
                                          color: kPinkColor,
                                          size: 24.0,
                                          semanticLabel:
                                              'Text to announce in accessibility modes',
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
                                          Text(
                                            Controller.getIBANCuenta(index),
                                            style: GoogleFonts.inter(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: kBlackColor),
                                          ),
                                          Text(
                                            'Cuenta ahorros',
                                            style: GoogleFonts.inter(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: kGreyColor),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        ('${Controller.getSaldoCuenta(index)}')
                                                .replaceAll('.', ',') +
                                            ' €',
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: kBlueColor,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Transaction Section
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16, bottom: 13, top: 29, right: 10),
                        child: Text(
                          'Inversiones',
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: kBlackColor),
                        ),
                      ),
                      ListView.builder(
                        itemCount: Controller.numInversiones(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: 57,
                                      width: 57,
                                      child: Icon(
                                        FontAwesomeIcons.handHoldingUsd,
                                        color: kPinkColor,
                                        size: 24.0,
                                        semanticLabel:
                                            'Text to announce in accessibility modes',
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
                                        Text(
                                          Controller.getDescripcionInversion(
                                              index),
                                          style: GoogleFonts.inter(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: kBlackColor),
                                        ),
                                        Text(
                                          'Puede resolverse',
                                          style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: kGreyColor),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${Controller.getCantidadActualInversion(index)}',
                                      style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: kBlueColor),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      // Transaction Section
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16, bottom: 13, top: 29, right: 10),
                        child: Text(
                          'Préstamos',
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: kBlackColor),
                        ),
                      ),

                      ListView.builder(
                        itemCount: Controller.numPrestamos(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: 57,
                                      width: 57,
                                      child: Icon(
                                        FontAwesomeIcons.handHoldingUsd,
                                        color: kPinkColor,
                                        size: 24.0,
                                        semanticLabel:
                                            'Text to announce in accessibility modes',
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
                                        Text(
                                          '${Controller.getDescripcionPrestamo(index)}',
                                          style: GoogleFonts.inter(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: kBlackColor),
                                        ),
                                        Text(
                                          '${Controller.getCuotasPrestamo(index)}',
                                          style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: kGreyColor),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${Controller.getCantidadPrestamo(index)} €',
                                      style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: kBlueColor),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ));
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

class OperationCard extends StatefulWidget {
  final String operation;
  final String selectedIcon;
  final String unselectedIcon;
  final bool isSelected;
  _MyHomePageState context;

  OperationCard(
      {required this.operation,
      required this.selectedIcon,
      required this.unselectedIcon,
      required this.isSelected,
      required this.context});

  @override
  _OperationCardState createState() => _OperationCardState();
}

class _OperationCardState extends State<OperationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      width: 123,
      height: 123,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 10,
              spreadRadius: 5,
              offset: Offset(8.0, 8.0),
            )
          ],
          borderRadius: BorderRadius.circular(15),
          color: widget.isSelected ? Color(0xFF1E1E99) : Color(0xFFFFFFFF)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
              widget.isSelected ? widget.selectedIcon : widget.unselectedIcon),
          SizedBox(
            height: 9,
          ),
          Text(
            widget.operation,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color:
                    widget.isSelected ? Color(0xFFFFFFFF) : Color(0xFF1E1E99)),
          )
        ],
      ),
    );
  }
}
