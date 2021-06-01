import 'package:flutter/material.dart';
import 'package:flutter_app/modeloControlador/Controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../constantes/colores.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class pantalla_movimientos extends StatefulWidget {
  static final String path = "main.dart";

  pantalla_movimientos({Key? key}) : super(key: key);

  @override
  _pantalla_movimientosState createState() => _pantalla_movimientosState();
}

class _pantalla_movimientosState extends StateMVC {

  _pantalla_movimientosState() : super(Controller());

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    Controller.limpiarSesion();
    await Controller.getDatos(Controller.idUsuario.toString());
    // if failed,use refreshFailed()
    if(mounted)
      setState(() {

      });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    Controller.limpiarSesion();
    await Controller.getDatos(Controller.idUsuario.toString());
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> prueba = Controller.getDatos(Controller.idUsuario.toString());
    //Controller.inicializarPanel();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: Text(
          'Movimientos',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top:8),
        child:
        FutureBuilder<Map<String, dynamic>>(
          future: prueba, // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child =SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: WaterDropHeader(),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child:
                  ListView(
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Text("ID Cuenta: ${Controller.idUsuario}",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      ListView.builder(
                        itemCount: Controller.getNumMovimientos(),
                        padding: EdgeInsets.only(left: 16, right: 16),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            height: 76,
                            margin: EdgeInsets.only(bottom: 13),
                            padding:
                            EdgeInsets.only(left: 15, top: 12, bottom: 12, right: 22),
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
                                        semanticLabel: 'Text to announce in accessibility modes',
                                      ),
                                    ),

                                    SizedBox(
                                      width: 13,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          Controller.getDescripcionMovimiento(index),
                                          style: GoogleFonts.inter(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: kBlackColor),
                                        ),
                                        Text(
                                          'Descripcion',
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
                                    Text('${Controller.getCantidadMovimiento(index)} €', style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: kBlueColor
                                    ),)
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      ],
                    ),
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




}