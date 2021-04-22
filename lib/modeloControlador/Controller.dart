import 'dart:math';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CuentaBancaria.dart';
import 'package:flutter_app/constantes/estadoBolsa.dart';
import 'InversionFutura.dart';
import 'Inversion.dart';
import 'Prestamo.dart';

class Model{
  static String _nombre = 'Nombre';
  static String get nombre => _nombre;
  static String _apellido = 'Cliente';
  static String get apellido => _apellido;
  static double _nomina = 2500.00;
  static double get nomina => _nomina;
  static var misCuentas = <CuentaBancaria>[];
  static var misPrestamos = <Prestamo>[];
  static var misInversiones = <Inversion>[];
  var seriesList = <charts.Series<InversionFutura, String>>[];
  var chart = <charts.Series>[];
  static String detallesSimulador = '';
  static int sectores = 0;
  static EstadoBolsa? miEstadoBolsa;
  static int? comisionHoy;

  static set nombre(String value) {
    _nombre = value;
  }

  static set apellido(String value) {
    _apellido = value;
  }

  static set nomina(double value) {
    _nomina = value;
  }

  static void addCuenta(CuentaBancaria cuenta){
    misCuentas.add(cuenta);
  }

  static void addInversion(Inversion inversion){
    misInversiones.add(inversion);
  }

  static void addPrestamo(Prestamo p){
    misPrestamos.add(p);
  }

  static void _addSaldo(double cantidad, int index){
    misCuentas[index].aniadirSaldo(cantidad);
  }

  static String _getSaldoTotal(){
    String res = '';
    double saldoTotal = 0.0;
    for(int i = 0; i < misCuentas.length; i++)
      saldoTotal += misCuentas[i].saldo;
    for(int i = 0; i < misPrestamos.length; i++)
      saldoTotal += misPrestamos[i].cantidad;
    res = saldoTotal.toStringAsFixed(2);
    return res;
  }

  static bool compruebaRentabilidad(Prestamo p){
    bool noRentable = true;
    bool haCambiado = false;
    double tipo = p.interes/1200;

    double numerador = tipo * pow(1+ tipo, p.cuotas);
    double denominador = pow(1 + tipo, p.cuotas) - 1;
    double cuota = p.cantidad * (numerador / denominador);

    while(noRentable){

      print('Cuotas Prestamo ${p.cuotas}');
      numerador = tipo * pow(1+ tipo, p.cuotas);
      denominador = pow(1 + tipo, p.cuotas) - 1;
      cuota = p.cantidad * (numerador / denominador);

      // Si supera la nómina mensual del cliente
      if(cuota > nomina*0.6){
        // Aplicamos el filtro de rentabilidad para el importe solicitado
        p.cuotas++;
        haCambiado = true;
      }
      else {
        noRentable = false;
        print('El banco le ofrece un prestamo de ${p.cantidad.toStringAsFixed(2)} € su cuota seria ${p.cuotas.toStringAsFixed(2)} €/mes en ${p.cuotas} meses con un interés del ${p.interes.toStringAsFixed(2)}');
      }
    }

    return haCambiado;
  }

  static bool compruebaDeudas(Prestamo p){
    bool sinDeuda;
    if(misPrestamos.isEmpty) {
      print('Usted no tiene deudas por lo que puede recibir el prestamo. \n');
      sinDeuda = true;
    }else{
      p.interes = 0;
      print('Usted tiene deudas por lo que no puede recibir el prestamo. \n');
      sinDeuda = false;
    }
    return sinDeuda;
  }

  static Prestamo _solicitarPrestamo(String cantidad, String cuotas, String interes){
    Prestamo prest = new Prestamo(double.parse(cantidad), int.parse(cuotas)*12, double.parse(interes), 'Descripción');
    bool filtro1 = false; // False si no se ha tenido que modificar el préstamo, true si se ha modificado
    bool filtro2 = false; // True si no tiene más prestamos y puede recibir el prestamo, false si tiene más prestamos.
    bool haCambiado = false;

    filtro2 = compruebaDeudas(prest);

    if(filtro2){
      //  Si pasa el filtro 2 podemos comprobar el 1
      filtro1 = compruebaRentabilidad(prest);
      if(filtro1){  // Se ha modificado el prestamo
        haCambiado = true;
      }
      else{ // No se ha tenido que modificar el préstamo
        misPrestamos.add(prest);
      }
    }
    return prest;
  }

  static String _getIBAN(int indice){
    String res = '**** ';
    String IBAN = misCuentas[indice].IBAN;
    res += IBAN.substring(IBAN.length-4, IBAN.length);
    return res;
  }

  static int _numCuentas(){
    return misCuentas.length;
  }

  static int _numPrestamos(){
    return misPrestamos.length;
  }

  static int _numInversiones(){
    return misInversiones.length;
  }

  static String _getSaldoCuenta(int index){
    return misCuentas[index].saldo.toStringAsFixed(2);
  }

  static String _getDescripcionInversion(int index){
    return misInversiones[index].descripcion;
  }

  static String _getDescripcionPrestamo(int index){
    return misPrestamos[index].descripcion;
  }

  static String _getCantidadInicialInversion(int index){
    return 'Empezó con ${misInversiones[index].cantidad_inicial.toStringAsFixed(0)} €';
  }

  static String _getCantidadActualInversion(int index){
    return '${misInversiones[index].cantidad_actual.toStringAsFixed(2)} €';
  }

  static String _getCuotasInversion(int index){
    return (misInversiones[index].cuotas / 12).toString();
  }

  static String _getCuotasPrestamo(int index){
    String res = '';
    if(misPrestamos[index].cuotas % 12 == 0){
      res = (misPrestamos[index].cuotas / 12).toStringAsFixed(0) + ' año(s)';
    }
    else{
      res = (misPrestamos[index].cuotas / 12).toStringAsFixed(0) + ' año(s) y ' + (misPrestamos[index].cuotas % 12).toString() + ' meses';
    }
    return res;
  }

  static String _getCantidadPrestamo(int index){
    return (misPrestamos[index].cantidad).toStringAsFixed(2);
  }

  static void resetPanel(){
    misPrestamos.clear();
    misInversiones.clear();
    misCuentas.clear();
  }

  static void simuladorInversion(){

  }

  static bool _tieneSaldo(double cantidad){
    bool res = false;
    if(cantidad < double.parse(_getSaldoTotal())){
      res = true;
    }
    return res;
  }

  static List<InversionFutura> simular_inversion(String _cantidad, String _interes, String _anios) {
    double interes = double.parse(_interes);
    print(_anios);
    var aux = <InversionFutura>[];
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    interes *= 0.01;
    detallesSimulador = '';
    sectores = 0;

    for (int i = 1; i <= int.parse(_anios); i++) {
      InversionFutura insertar = new InversionFutura((i + date.year).toString(), double.parse(_cantidad) * pow(1 + (interes / 12), i * 12));;
      if(i < 9) {
        aux.add(insertar);
      }
      detallesSimulador += 'Año ' + (i+date.year).toString() + ' --> ' + insertar.cantidad.toStringAsFixed(2) + '\n';

      if(i == int.parse(_anios)){
        sectores = insertar.cantidad.toInt();
      }
    }

    return aux;
  }

  static List<charts.Series<InversionFutura, String>> _crearDatos(String _cantidad, String _interes, String _anios) {
    var rent = <InversionFutura>[];
    rent = simular_inversion(_cantidad, _interes, _anios);
    return [
      new charts.Series<InversionFutura, String>(
        id: 'Rentabilidad',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (InversionFutura inv, _) => inv.cuotas,
        measureFn: (InversionFutura inv, _) => inv.cantidad,
        fillColorFn: (InversionFutura inv, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff009975)),
        data: rent,
        labelAccessorFn: (InversionFutura inv, _) =>
        '${inv.cantidad.toStringAsFixed(0)} €',
      )
    ];
  }

  static void simularEstadoBolsa(){
    var estadoBolsa = <EstadoBolsa>[];

    estadoBolsa = EstadoBolsa.values;

    final _random = new Random();
    int indice = _random.nextInt(3);
    print (indice);

    Model.miEstadoBolsa = estadoBolsa[indice];

    var comisiones = [1,5,10];

    int hoy = _random.nextInt(3);

    Model.comisionHoy = comisiones[hoy];
  }

}

class Controller extends ControllerMVC{
  static String getIBANCuenta(int indice) => Model._getIBAN(indice);
  static String get nombre => Model.nombre;
  static String get apellidos => Model.apellido;
  static int get sectores => Model.sectores;
  static String get detallesSimulador => Model.detallesSimulador;
  static EstadoBolsa? get miEstadoBolsa => Model.miEstadoBolsa;
  static int? get comisionHoy => Model.comisionHoy;
  static int numCuentas() => Model._numCuentas();
  static int numPrestamos() => Model._numPrestamos();
  static int numInversiones() => Model._numInversiones();
  static String getDescripcionInversion(int index) => Model._getDescripcionInversion(index);
  static String getDescripcionPrestamo(int index) => Model._getDescripcionPrestamo(index);
  static String getCantidadInicialInversion(int index) => Model._getCantidadInicialInversion(index);
  static String getCantidadActualInversion(int index) => Model._getCantidadActualInversion(index);
  static String getCuotasPrestamo(int index) => Model._getCuotasPrestamo(index);
  static String getCantidadPrestamo(int index) => Model._getCantidadPrestamo(index);
  static String getSaldoCuenta(int index) => Model._getSaldoCuenta(index);
  static String getSaldoTotal() => Model._getSaldoTotal();
  static bool tieneSaldo(double cantidad) => Model._tieneSaldo(cantidad);
  static void reiniciarPanel() => Model.resetPanel();
  static List<charts.Series<InversionFutura, String>> crearDatos(String _inversion, String _interes, String _anios) => Model._crearDatos(_inversion, _interes, _anios);
  static void addSaldo(double cantidad, int index) => Model._addSaldo(cantidad, index);

  static void inicializarPanel(){
    if(Model._numCuentas() == 0) {
      Model.addCuenta(new CuentaBancaria('ES1130043519529674859919', 3500.00));
      Model.simularEstadoBolsa();
    }
    //if(Model._numPrestamos() == 0)
      //Model.addPrestamo(new Prestamo(1500, 12, 3, 'Prueba'));
    //if(Model._numInversiones() == 0)
      //Model.addInversion(new Inversion(1850, 1300, 10, 7, 'Prueba2'));
  }

  static void solicitarPrestamo(String cantidad, String cuotas, String interes, BuildContext context){
    Prestamo prest;
    String resultado = '';
    prest = Model._solicitarPrestamo(cantidad, cuotas, interes);
    bool haCambiado = prest.cuotas != int.parse(cuotas)*12;

    if(haCambiado) {
      resultado += 'Le ofrecemos los siguientes términos\nCantidad: ${prest
          .cantidad} €\nCuotas: ${prest.cuotas} meses\nInteres: ${prest
          .interes} %';
      showAlertDialogPrestamos(context, resultado, prest);
    }
    else{
      if(prest.interes == 0){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Salde deudas antes!'),
          ),
        );
        Navigator.pop(context);
      }
      else{
        addSaldo(prest.cantidad, 0);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Solicitando el prestamo....'),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  static showAlertDialogPrestamos(BuildContext context, String text, Prestamo p) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Rechazar"),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = FlatButton(
      child: Text("Aceptar"),
      onPressed:  () {
        Navigator.pop(context);
        addSaldo(p.cantidad, 0);
        Model.addPrestamo(p);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Solicitando el prestamo....'),
          ),
        );
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Banco rechaza solicitud"),
      content: Text("${text}"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static double calculoInversionFinal(String _cantidad){
    double res = 0.0;

    switch(miEstadoBolsa) {
      case EstadoBolsa.SUBIENDO: {
        res = double.parse(_cantidad) - (double.parse(_cantidad) * 0.1) - (double.parse(_cantidad) * (comisionHoy!/100));
      }
      break;
      case EstadoBolsa.BAJANDO: {
        res = double.parse(_cantidad) - (double.parse(_cantidad) * -0.1) - (double.parse(_cantidad) * (comisionHoy!/100));
      }
      break;
      case EstadoBolsa.NORMAL: {
        res = double.parse(_cantidad) - (double.parse(_cantidad) * 0.03) - (double.parse(_cantidad) * (comisionHoy!/100));
      }
      break;
    }

    return res;
  }

  static void realizarInversion(String cantidad, String cuotas, String interes, BuildContext context){
    Inversion inv;
    String resultado = '';
    inv = new Inversion(double.parse(cantidad), double.parse(cantidad), double.parse(interes), int.parse(cuotas), 'Descripción');
    resultado += 'El banco se quedará con ${(inv.cantidad_inicial * (comisionHoy!/100)).toStringAsFixed(2)} € y como la bolsa está ${miEstadoBolsa.toString().split('.').last} finalmente invertirá ${calculoInversionFinal(cantidad)} €';
    inv.cantidad_inicial = calculoInversionFinal(cantidad);
    inv.cantidad_actual = calculoInversionFinal(cantidad);
    showAlertDialogInversiones(context, resultado, inv);
  }

  static showAlertDialogInversiones(BuildContext context, String text, Inversion inversion) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Rechazar"),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = FlatButton(
      child: Text("Aceptar"),
      onPressed:  () {
        Navigator.pop(context);
        Model.addInversion(inversion);
        addSaldo(-inversion.cantidad_inicial, 0);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Solicitando el prestamo....'),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Usted acepta..."),
      content: Text("${text}"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Widget generarGraficoBarras(String _inversion, String _interes, String _anios) {
    return new charts.BarChart(
      Model._crearDatos(_inversion, _interes, _anios),
      animate: true,
    );
  }

}