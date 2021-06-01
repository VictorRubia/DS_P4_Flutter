import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_app/modeloControlador/Controller.dart';

class pantalla_simular extends StatefulWidget {
  //requiring the list of todos
  pantalla_simular({Key? key}) : super(key: key);
  @override
  _pantalla_simularState createState() => _pantalla_simularState();
}

class _pantalla_simularState extends StateMVC {
  _pantalla_simularState() : super(Controller());
  bool mostrar_chart = false;

  late String _inversion;
  late String _interes;
  late String _anios;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _campoCantidad() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Cantidad €'),
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Campo obligatorio';
        }

        return null;
      },
      onSaved: (String? value) {
        _inversion = value!;
      },
    );
  }

  Widget _campoInteres() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Interés'),
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Campo obligatorio';
        }

        return null;
      },
      onSaved: (String? value) {
        _interes = value!;
      },
    );
  }

  Widget _campoAnios() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Años'),
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Campo obligatorio';
        }

        return null;
      },
      onSaved: (String? value) {
        _anios = value!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //generarDatosIniciales();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.indigo,
            //backgroundColor: Color(0xff308e1c),
            title: Text('Simulación'),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Color(0xffc1790d),
              tabs: [
                Tab(
                  text: 'FORMULARIO',
                ),
                Tab(text: 'DETALLES',),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(0.5),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            new Flexible(
                              //margin: EdgeInsets.only(left: 16, right: 16, top: 10),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 10, top: 0),
                                  child: new Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        _campoCantidad(),
                                        _campoInteres(),
                                        _campoAnios(),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.indigo,
                                          ),
                                          child: Text(
                                            'Simular',
                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                          ),
                                          onPressed: () {
                                            if (!_formKey.currentState!.validate()) {
                                              return null;
                                            }
                                            _formKey.currentState!.save();
                                            setState(() {
                                              mostrar_chart = true;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            ),
                            if(mostrar_chart)
                              Container(
                                width: 250,
                                height:150,
                                margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                                child: PieChart(
                                  PieChartData(
                                      pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                                        setState(() {
                                          final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                                              pieTouchResponse.touchInput is! PointerUpEvent;
                                          if (desiredTouch && pieTouchResponse.touchedSection != null) {
                                            Controller.touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                          } else {
                                            Controller.touchedIndex = -1;
                                          }
                                        });
                                      }),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 40,
                                      sections: Controller.datosSecciones(_inversion, _interes, _anios)),
                                  swapAnimationDuration: Duration(milliseconds: 150), // Optional
                                  swapAnimationCurve: Curves.linear, // Optional
                                ),
                                //DonutPieChart.factory(int.parse(_inversion), Controller.sectores),
                              )
                          ],
                        ),
                        SizedBox(height: 30,),
                        if(mostrar_chart)
                          Text(
                            'Rentabilidad',style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        if(mostrar_chart)
                          AspectRatio(
                            aspectRatio: 1.25,
                            child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(9),
                                  ),
                                  color: Color(0xff232d37)),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
                                child: LineChart(
                                  Controller.datosBarra(_inversion, _interes, _anios),
                                  swapAnimationDuration: Duration(milliseconds: 150), // Optional
                                  swapAnimationCurve: Curves.linear, // Optional
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Container(
                  child: Center(
                    child: ListView(
                      physics: ClampingScrollPhysics(),
                      children: <Widget>[
                        Text(
                          'Detalles',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10.0,),
                        Text('${Controller.detallesSimulador}',style: TextStyle(fontSize: 20.0, ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}