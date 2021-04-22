import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_app/modeloControlador/Controller.dart';
import 'donut.dart';

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

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Cantidad €'),
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Campo obligatorio';
        }
        // if (!Controller.tieneSaldo(double.parse(value))){
        //   return 'No tiene dinero suficiente';
        // }

        return null;
      },
      onSaved: (String? value) {
        _inversion = value!;
      },
    );
  }

  Widget _buildEmail() {
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

  Widget _buildPassword() {
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
            backgroundColor: Color(0xff1976d2),
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
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            new Flexible(
                              //margin: EdgeInsets.only(left: 16, right: 16, top: 10),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 10, top: 16),
                                  child: new Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        _buildName(),
                                        _buildEmail(),
                                        _buildPassword(),
                                        SizedBox(height: 10),
                                        RaisedButton(
                                          child: Text(
                                            'Simular',
                                            style: TextStyle(color: Colors.blue, fontSize: 16),
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
                                child: DonutPieChart.factory(int.parse(_inversion), Controller.sectores),
                              )
                          ],
                        ),
                        SizedBox(height: 0,),
                        if(mostrar_chart)
                          Text(
                            'Rentabilidad',style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold),),
                        if(mostrar_chart)
                          Expanded(
                            child: charts.BarChart(
                              Controller.crearDatos(_inversion, _interes, _anios),
                              animate: true,
                              barGroupingType: charts.BarGroupingType.grouped,
                              //behaviors: [new charts.SeriesLegend()],
                              animationDuration: Duration(milliseconds: 500),
                              barRendererDecorator: new charts.BarLabelDecorator<String>(),
                              domainAxis: new charts.OrdinalAxisSpec(),
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