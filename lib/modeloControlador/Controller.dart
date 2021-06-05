import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CuentaBancaria.dart';
import 'package:flutter_app/constantes/estadoBolsa.dart';
import 'InversionFutura.dart';
import 'Inversion.dart';
import 'Movimiento.dart';
import 'Prestamo.dart';
import 'Tarjeta.dart';
import 'Notificaciones.dart';

/* AÑADIMOS API */
import 'dart:convert';

import 'package:http/http.dart' as http;

class Model {
  static int idUsuario = 0;
  static String _nombre = '';
  static String get nombre => _nombre;
  static String _apellido = '';
  static String get apellido => _apellido;
  static double _nomina = 0.00;
  static double get nomina => _nomina;
  static var misCuentas = <CuentaBancaria>[];
  static var misPrestamos = <Prestamo>[];
  static var misInversiones = <Inversion>[];
  static var misTarjetas = <Tarjeta>[];
  static var misNotificaciones = <Notificaciones>[];
  static var misMovimientos = <Movimiento>[];
  static String detallesSimulador = '';
  static int sectores = 0;
  static EstadoBolsa? miEstadoBolsa;
  static int? comisionHoy;

  static void clear() {
    _nombre = '';
    _apellido = '';
    _nomina = 0.0;
    misCuentas.clear();
    misPrestamos.clear();
    misInversiones.clear();
    misTarjetas.clear();
    misNotificaciones.clear();
    misMovimientos.clear();
    detallesSimulador = '';
    sectores = 0;
    miEstadoBolsa = null;
    comisionHoy = null;
  }

  static set nombre(String value) {
    _nombre = value;
  }

  static set apellido(String value) {
    _apellido = value;
  }

  static set nomina(double value) {
    _nomina = value;
  }

  static void addCuenta(CuentaBancaria cuenta) {
    misCuentas.add(cuenta);
  }

  static void addTarjeta(Tarjeta tarjeta) {
    misTarjetas.add(tarjeta);
  }

  static void addInversion(Inversion inversion) {
    misInversiones.add(inversion);
  }

  static void addPrestamo(Prestamo p) {
    misPrestamos.add(p);
  }

  static void addMovimiento(Movimiento m) {
    misMovimientos.add(m);
  }

  static void _addSaldo(double cantidad, int index) {
    misCuentas[index].aniadirSaldo(cantidad);
  }

  static String _getSaldoTotal() {
    String res = '';
    double saldoTotal = 0.0;
    for (int i = 0; i < misCuentas.length; i++)
      saldoTotal += misCuentas[i].saldo;
    for (int i = 0; i < misPrestamos.length; i++)
      saldoTotal += misPrestamos[i].cantidad;
    res = saldoTotal.toStringAsFixed(2);
    return res;
  }

  static int _getNumNotificaciones() {
    int contador = 0;

    return misNotificaciones.length;
  }

  static int _getNumMovimientos() {
    return misMovimientos.length;
  }

  static void addNotificacion(Notificaciones not) {
    misNotificaciones.add(not);
  }

  static Notificaciones _getNotificacion(int index) {
    return misNotificaciones[index];
  }

  static bool compruebaRentabilidad(Prestamo p) {
    bool noRentable = true;
    bool haCambiado = false;
    double tipo = p.interes / 1200;

    double numerador = tipo * pow(1 + tipo, p.cuotas);
    double denominador = pow(1 + tipo, p.cuotas) - 1;
    double cuota = p.cantidad * (numerador / denominador);

    while (noRentable) {
      //print('Cuotas Prestamo ${p.cuotas}');
      numerador = tipo * pow(1 + tipo, p.cuotas);
      denominador = pow(1 + tipo, p.cuotas) - 1;
      cuota = p.cantidad * (numerador / denominador);

      // Si supera la nómina mensual del cliente
      if (cuota > nomina * 0.6) {
        // Aplicamos el filtro de rentabilidad para el importe solicitado
        p.cuotas++;
        haCambiado = true;
      } else {
        noRentable = false;
        //print(
        //'El banco le ofrece un prestamo de ${p.cantidad.toStringAsFixed(2)} € su cuota seria ${p.cuotas.toStringAsFixed(2)} €/mes en ${p.cuotas} meses con un interés del ${p.interes.toStringAsFixed(2)}');
      }
    }

    return haCambiado;
  }

  static bool compruebaDeudas(Prestamo p) {
    bool sinDeuda;
    if (misPrestamos.isEmpty) {
      //print('Usted no tiene deudas por lo que puede recibir el prestamo. \n');
      sinDeuda = true;
    } else {
      p.interes = 0;
      //print('Usted tiene deudas por lo que no puede recibir el prestamo. \n');
      sinDeuda = false;
    }
    return sinDeuda;
  }

  static Prestamo _solicitarPrestamo(
      String cantidad, String cuotas, String interes, String concepto) {
    Prestamo prest = new Prestamo(-1, double.parse(cantidad),
        int.parse(cuotas) * 12, double.parse(interes), concepto);
    bool filtro1 =
        false; // False si no se ha tenido que modificar el préstamo, true si se ha modificado
    bool filtro2 =
        false; // True si no tiene más prestamos y puede recibir el prestamo, false si tiene más prestamos.
    bool haCambiado = false;

    filtro2 = compruebaDeudas(prest);

    if (filtro2) {
      //  Si pasa el filtro 2 podemos comprobar el 1
      filtro1 = compruebaRentabilidad(prest);
      if (filtro1) {
        // Se ha modificado el prestamo
        haCambiado = true;
      } else {
        // No se ha tenido que modificar el préstamo
        //misPrestamos.add(prest);
      }
    }
    return prest;
  }

  static String _getIBAN(int indice) {
    String res = '**** ';
    String IBAN = misCuentas[indice].IBAN;
    res += IBAN.substring(IBAN.length - 4, IBAN.length);
    return res;
  }

  static String _transformarNumTarjeta(int indice) {
    String res = '**** **** **** ';
    String IBAN = misTarjetas[indice].num_tarjeta;
    res += IBAN.substring(IBAN.length - 4, IBAN.length);
    return res;
  }

  static int _numCuentas() {
    return misCuentas.length;
  }

  static int _numTarjetas() {
    return misTarjetas.length;
  }

  static int _numPrestamos() {
    return misPrestamos.length;
  }

  static int _numInversiones() {
    return misInversiones.length;
  }

  static String _getSaldoCuenta(int index) {
    return misCuentas[index].saldo.toStringAsFixed(2);
  }

  static String _getNumeroTarjeta(int index) {
    return _transformarNumTarjeta(index);
  }

  static String _getNumeroTarjetaNeto(int index) {
    return misTarjetas[index].num_tarjeta;
  }

  static String _getFechaTarjeta(int index) {
    return misTarjetas[index].fecha_caducidad;
  }

  static String _getTipoTarjeta(int index) {
    return misTarjetas[index].tipo;
  }

  static String _getCVV(int index) {
    return misTarjetas[index].cvv;
  }

  static String _getDescripcionInversion(int index) {
    return misInversiones[index].descripcion;
  }

  static String _getDescripcionPrestamo(int index) {
    return misPrestamos[index].descripcion;
  }

  static String _getDescripcionMovimiento(int index) {
    return misMovimientos[index].concepto;
  }

  static double _getCantidadMovimiento(int index) {
    return misMovimientos[index].cantidad;
  }

  static String _getCantidadInicialInversion(int index) {
    return 'Empezó con ${misInversiones[index].cantidad_inicial.toStringAsFixed(0)} €';
  }

  static String _getCantidadActualInversion(int index) {
    return '${misInversiones[index].cantidad_actual.toStringAsFixed(2)} €';
  }

  static String _getCuotasInversion(int index) {
    return (misInversiones[index].cuotas / 12).toString();
  }

  static String _getCuotasPrestamo(int index) {
    String res = '';
    if (misPrestamos[index].cuotas % 12 == 0) {
      res = (misPrestamos[index].cuotas / 12).toStringAsFixed(0) +
          ' año(s) a ${misPrestamos[index].interes} %';
    } else {
      res = (misPrestamos[index].cuotas / 12).toStringAsFixed(0) +
          ' año(s) y ' +
          (misPrestamos[index].cuotas % 12).toString() +
          ' meses';
    }
    return res;
  }

  static String _getCantidadPrestamo(int index) {
    return (misPrestamos[index].cantidad).toStringAsFixed(2);
  }

  static bool _tieneSaldo(double cantidad) {
    bool res = false;
    if (cantidad < double.parse(_getSaldoTotal())) {
      res = true;
    }
    return res;
  }

  static List<InversionFutura> simular_inversion(
      String _cantidad, String _interes, String _anios) {
    double interes = double.parse(_interes);
    //print(_anios);
    var aux = <InversionFutura>[];
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    interes *= 0.01;
    detallesSimulador = '';
    sectores = 0;

    for (int i = 1; i <= int.parse(_anios); i++) {
      InversionFutura insertar = new InversionFutura((i + date.year).toString(),
          double.parse(_cantidad) * pow(1 + (interes / 12), i * 12));
      ;
      if (i < 9) {
        aux.add(insertar);
      }
      detallesSimulador += 'Año ' +
          (i + date.year).toString() +
          ' --> ' +
          insertar.cantidad.toStringAsFixed(2) +
          '\n';

      if (i == int.parse(_anios)) {
        sectores = insertar.cantidad.toInt();
      }
    }

    return aux;
  }

  static List<FlSpot> _crearDatos(
      String _cantidad, String _interes, String _anios) {
    var rent = <InversionFutura>[];
    rent = simular_inversion(_cantidad, _interes, _anios);
    var chart = <FlSpot>[];

    chart.add(new FlSpot(0, double.parse(_cantidad)));

    for (int i = 0; i < rent.length; i++) {
      chart.add(new FlSpot((i + 1).toDouble(),
          double.parse(rent[i].cantidad.toStringAsFixed(2))));
    }
    return chart;
  }

  static void simularEstadoBolsa() {
    var estadoBolsa = <EstadoBolsa>[];

    estadoBolsa = EstadoBolsa.values;

    final _random = new Random();
    int indice = _random.nextInt(3);
    //print(indice);

    Model.miEstadoBolsa = estadoBolsa[indice];

    var comisiones = [1, 5, 10];

    int hoy = _random.nextInt(3);

    Model.comisionHoy = comisiones[hoy];
  }
}

class Controller extends ControllerMVC {
  static Controller _instance = null!;

  static String getIBANCuenta(int indice) => Model._getIBAN(indice);
  static String get nombre => Model.nombre;
  static void set nombre(String name) => Model.nombre;
  static String get apellidos => Model.apellido;
  static int get sectores => Model.sectores;
  static int get idUsuario => Model.idUsuario;
  static String get detallesSimulador => Model.detallesSimulador;
  static EstadoBolsa? get miEstadoBolsa => Model.miEstadoBolsa;
  static int? get comisionHoy => Model.comisionHoy;
  static int numCuentas() => Model._numCuentas();
  static int numTarjetas() => Model._numTarjetas();
  static int numPrestamos() => Model._numPrestamos();
  static int numInversiones() => Model._numInversiones();
  static String getIdCuenta(int index) => Model._getDescripcionInversion(index);
  static String getDescripcionInversion(int index) =>
      Model._getDescripcionInversion(index);
  static String getDescripcionPrestamo(int index) =>
      Model._getDescripcionPrestamo(index);
  static String getDescripcionMovimiento(int index) =>
      Model._getDescripcionMovimiento(index);
  static double getCantidadMovimiento(int index) =>
      Model._getCantidadMovimiento(index);
  static String getCantidadInicialInversion(int index) =>
      Model._getCantidadInicialInversion(index);
  static String getCantidadActualInversion(int index) =>
      Model._getCantidadActualInversion(index);
  static String getCuotasPrestamo(int index) => Model._getCuotasPrestamo(index);
  static String getCantidadPrestamo(int index) =>
      Model._getCantidadPrestamo(index);
  static String getSaldoCuenta(int index) => Model._getSaldoCuenta(index);
  static String getNumeroTarjeta(int index) => Model._getNumeroTarjeta(index);
  static String getNumeroTarjetaNeto(int index) =>
      Model._getNumeroTarjetaNeto(index);
  static String getFechaTarjeta(int index) => Model._getFechaTarjeta(index);
  static String getTipoTarjeta(int index) => Model._getTipoTarjeta(index);
  static String getCVV(int index) => Model._getCVV(index);
  static String getSaldoTotal() => Model._getSaldoTotal();
  static int getNumNotificaciones() => Model._getNumNotificaciones();
  static int getNumMovimientos() => Model._getNumMovimientos();
  static Notificaciones getNotificacion(int index) =>
      Model._getNotificacion(index);
  static bool tieneSaldo(double cantidad) => Model._tieneSaldo(cantidad);
  static List<FlSpot> crearDatos(
          String _inversion, String _interes, String _anios) =>
      Model._crearDatos(_inversion, _interes, _anios);
  static void addSaldo(double cantidad, int index) =>
      Model._addSaldo(cantidad, index);
  static int touchedIndex = 0;
  static late Map<String, dynamic> respuesta;

  /*----------------------------*/

  /* Datos para inicializar el panel */

  static String _baseAddress = 'clados.ugr.es';
  static String _applicationName = 'DS5/api/v1/';

  //////////// get //////////////////
  static Future<Map<String, dynamic>> getDatos(String id) async {
    if (Model.nombre == '') {
      Model.clear();
      final response = await http.get(
          Uri.https(_baseAddress, _applicationName + '/accounts/' + id),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        //ok
        respuesta = json.decode(response.body) as Map<String, dynamic>;
        Map<String, dynamic> jsonn =
            json.decode(response.body) as Map<String, dynamic>;

        Model.idUsuario = jsonn['id'];
        Model.nombre = jsonn['name'];
        Model.nomina = double.parse(jsonn['nomina'].toString());
        Model.addCuenta(new CuentaBancaria(
            jsonn['iban'], double.parse(jsonn['amount'].toString())));

        //tarjetas
        for (int i = 0; i < jsonn['cards'].length; i++) {
          var numero = jsonn['cards'][i]['number'];
          var fecha = jsonn['cards'][i]['fecha'];
          var tipo = jsonn['cards'][i]['tipo'];
          var cvv = jsonn['cards'][i]['cvv'];

          Model.addTarjeta(new Tarjeta(numero, fecha, cvv.toString(), tipo));
        }
        //prestamos
        for (int i = 0; i < jsonn['loans'].length; i++) {
          var id = jsonn['loans'][i]['id'];
          var cantidad = jsonn['loans'][i]['amount'];
          var cuotas = jsonn['loans'][i]['meses'];
          var interes = jsonn['loans'][i]['interes'];
          var descripcion = jsonn['loans'][i]['concepto'];

          Model.addPrestamo(new Prestamo(id, double.parse(cantidad.toString()),
              cuotas, double.parse(interes.toString()), descripcion));
        }

        //inversiones
        for (int i = 0; i < jsonn['investments'].length; i++) {
          var id = jsonn['investments'][i]['id'];
          var cantidad_actual = jsonn['investments'][i]['amount'];
          var cantidad_inicial = jsonn['investments'][i]['amount'];
          var interes = jsonn['investments'][i]['interes'];
          var cuotas = jsonn['investments'][i]['meses'];
          var descripcion = jsonn['investments'][i]['concepto'];

          Model.addInversion(new Inversion(
              id,
              double.parse(cantidad_actual.toString()),
              double.parse(cantidad_inicial.toString()),
              double.parse(interes.toString()),
              cuotas,
              descripcion));
        }

        //notificaciones
        for (int i = 0; i < jsonn['requests'].length; i++) {
          var id = jsonn['requests'][i]['id'];
          var idObjetivo = jsonn['requests'][i]['id_objetivo'];
          var tipo = jsonn['requests'][i]['tipo'];
          var resuelto = jsonn['requests'][i]['solved'];

          Model.addNotificacion(
              new Notificaciones(id, idObjetivo, tipo, resuelto));
        }

        //movimientos
        for (int i = 0; i < jsonn['transactions'].length; i++) {
          var id = jsonn['transactions'][i]['id'];
          var cantidad = jsonn['transactions'][i]['amount'];
          var idCuenta = jsonn['transactions'][i]['account_id'];
          var concepto = jsonn['transactions'][i]['concepto'];

          Model.addMovimiento(new Movimiento(
              id, double.parse(cantidad.toString()), idCuenta, concepto));
        }

        Model.simularEstadoBolsa();

        return jsonn;
      } else
        throw Exception('Falló la request');
    } else {
      return respuesta;
    }
  }

  static Future<List<Prestamo>> getPrestamos(String id) async {
    final response = await http.get(
        Uri.https(_baseAddress, _applicationName + 'accounts/' + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonn =
          json.decode(response.body) as Map<String, dynamic>;
      var prestamos = <Prestamo>[];

      //prestamos
      for (int i = 0; i < jsonn['loans'].length; i++) {
        var id = jsonn['loans'][i]['id'];
        var cantidad = jsonn['loans'][i]['amount'];
        var cuotas = jsonn['loans'][i]['meses'];
        var interes = jsonn['loans'][i]['interes'];
        var descripcion = jsonn['loans'][i]['concepto'];

        prestamos.add(new Prestamo(id, double.parse(cantidad.toString()),
            cuotas, double.parse(interes.toString()), descripcion));
      }
      return prestamos;
    } else
      throw Exception('Falló la request');
  }

  static Future<List<Notificaciones>> getNotificaciones(String id) async {
    Model.misNotificaciones.clear();
    final response = await http.get(
        Uri.https(_baseAddress, _applicationName + 'accounts/' + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonn =
          json.decode(response.body) as Map<String, dynamic>;
      var notificaciones = <Notificaciones>[];

      for (int i = 0; i < jsonn['requests'].length; i++) {
        var id = jsonn['requests'][i]['id'];
        var idObjetivo = jsonn['requests'][i]['id_objetivo'];
        var tipo = jsonn['requests'][i]['tipo'];
        var resuelto = jsonn['requests'][i]['solved'];

        notificaciones.add(new Notificaciones(id, idObjetivo, tipo, resuelto));
        Model.misNotificaciones
            .add(new Notificaciones(id, idObjetivo, tipo, resuelto));
      }
      return notificaciones;
    } else
      throw Exception('Falló recibir notificaciones');
  }

  static Future<List<Inversion>> getInversiones(String id) async {
    final response = await http.get(
        Uri.https(_baseAddress, _applicationName + 'accounts/' + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonn =
          json.decode(response.body) as Map<String, dynamic>;
      var inversion = <Inversion>[];

      //prestamos
      for (int i = 0; i < jsonn['investments'].length; i++) {
        var id = jsonn['investments'][i]['id'];
        var cantidad = jsonn['investments'][i]['amount'];
        var cuotas = jsonn['investments'][i]['meses'];
        var interes = jsonn['investments'][i]['interes'];
        var descripcion = jsonn['investments'][i]['concepto'];

        inversion.add(new Inversion(
            id,
            double.parse(cantidad.toString()),
            double.parse(cantidad.toString()),
            double.parse(interes.toString()),
            cuotas,
            descripcion));
      }
      return inversion;
    } else
      throw Exception('Falló la request');
  }

  //////////// delete //////////////////

  static void deletePrestamo(String id) async {
    final http.Response response = await http.delete(
      Uri.https(_baseAddress, _applicationName + '/loans/' + id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200)
      print("PRESTAMO BORRADO");
    else
      throw Exception('Failed to delete Prestamo.');
  }

  //////////// delete //////////////////

  static void deleteInversion(String id) async {
    final http.Response response = await http.delete(
      Uri.https(_baseAddress, _applicationName + '/investments/' + id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200)
      print("INVERSION BORRADA");
    else
      throw Exception('Failed to delete Inversion.');
  }

  //////////// delete //////////////////
  static Future<bool> deleteNotificaciones(String id) async {
    final http.Response response = await http.delete(
      Uri.https(_baseAddress, _applicationName + '/requests/' + id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else
      throw Exception('Failed to delete Inversion.');
  }

  /////////// update /////////
  static Future<bool> actualizarSaldo(String nueva) async {
    final http.Response response = await http.put(
      Uri.https(
          _baseAddress, _applicationName + 'accounts/' + idUsuario.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'amount': nueva,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("CAMBIO EL SALDO");
      return true;
    } else
      throw Exception('ERROR');
  }

  /////////// update /////////
  static Future<bool> actualizarSaldoTransferencia(String nueva, String idUsuarioDestino) async {
    late var amount;
    final response2 = await http.get(
        Uri.https(_baseAddress, _applicationName + 'accounts/' + idUsuarioDestino),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response2.statusCode == 200) {
      Map<String, dynamic> jsonn =
      json.decode(response2.body) as Map<String, dynamic>;
      amount = jsonn['amount'];
    }

    var convertido = (double.parse(nueva) + double.parse(amount)).toString();

    final http.Response response = await http.put(
      Uri.https(
          _baseAddress, _applicationName + 'accounts/' + idUsuarioDestino),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'amount': convertido,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else
      throw Exception('ERROR');
  }

  ////////////// create ///////////////
  static Future<bool> crearMovimiento(Movimiento m) async {
    final response = await http.post(
      Uri.https(_baseAddress, _applicationName + 'transactions/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'amount': m.cantidad.toString(),
        'account_id': idUsuario.toString(),
        'concepto': m.concepto,
      }),
    );
    if (response.statusCode == 201)
      return true;
    else
      throw Exception('Failed to create project');
  }

  ////////////// create ///////////////
  static Future<bool> crearMovimientoTransferencia(
      Movimiento m, String idCuentaDestino) async {
    final response = await http.post(
      Uri.https(_baseAddress, _applicationName + 'transactions/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'amount': m.cantidad.toString(),
        'account_id': idCuentaDestino,
        'concepto': m.concepto,
      }),
    );
    if (response.statusCode == 201)
      return true;
    else
      throw Exception('Failed to create project');
  }

  ////////////// create ///////////////
  static Future<Map<String, dynamic>> crearPrestamo(Prestamo p) async {
    final response = await http.post(
      Uri.https(_baseAddress, _applicationName + 'loans/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'amount': p.cantidad.toString(),
        'account_id': 1.toString(),
        'meses': p.cuotas.toString(),
        'concepto': p.descripcion,
        'interes': p.interes.toString(),
      }),
    );
    print(response.body);
    if (response.statusCode == 201) {
      Map<String, dynamic> jsonn =
          json.decode(response.body) as Map<String, dynamic>;
      return jsonn;
    } else
      throw Exception('Failed to create Prestamo');
  }

  ////////////// create ///////////////
  static Future<Map<String, dynamic>> crearInversion(Inversion inv) async {
    final response = await http.post(
      Uri.https(_baseAddress, _applicationName + 'investments/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'amount': inv.cantidad_actual.toString(),
        'account_id': idUsuario.toString(),
        'meses': inv.cuotas.toString(),
        'concepto': inv.descripcion,
        'interes': inv.interes.toString(),
      }),
    );
    print(response.body);
    if (response.statusCode == 201) {
      Map<String, dynamic> jsonn =
          json.decode(response.body) as Map<String, dynamic>;
      return jsonn;
    } else
      throw Exception('Failed to create Inversion');
  }

  ////////////// create ///////////////
  static Future<bool> crearSolicitudPrestamo(Prestamo p) async {
    Map<String, dynamic> jsonn = await crearPrestamo(p);
    final response = await http.post(
      Uri.https(_baseAddress, _applicationName + 'requests/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_objetivo': jsonn['id'].toString(),
        'account_id': idUsuario.toString(),
        'tipo': 1.toString(),
        'solved': 0.toString(),
      }),
    );
    print(response.body);
    if (response.statusCode == 201)
      return true;
    else
      throw Exception('Failed to create solicitudPrestamo');
  }

  ////////////// create ///////////////
  static Future<bool> crearSolicitudTarjeta() async {
    final response = await http.post(
      Uri.https(_baseAddress, _applicationName + 'requests/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_objetivo': 0.toString(),
        'account_id': idUsuario.toString(),
        'tipo': 0.toString(),
        'solved': 0.toString(),
      }),
    );
    print(response.body);
    if (response.statusCode == 201)
      return true;
    else
      throw Exception('Failed to create solicitudPrestamo');
  }

  ////////////// create ///////////////
  static Future<bool> crearTransferencia(
      String cantidad, String idCuentaDestino, String concepto) async {
    final response = await http.post(
      Uri.https(_baseAddress, _applicationName + 'transfers/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'amount': cantidad,
        'account_id': idUsuario.toString(),
        'account2_id': idCuentaDestino,
        'concepto': concepto,
      }),
    );
    print(response.body);
    if (response.statusCode == 201)
      return true;
    else
      throw Exception('Failed to create solicitudPrestamo');
  }

  static void pagarPrestamo(Prestamo p) {
    Model.nombre = '';
    deletePrestamo(p.id.toString());
    actualizarSaldo((double.parse(getSaldoCuenta(0)) - p.cantidad).toString());
    addSaldo(-p.cantidad, 0);
    crearMovimiento(
        new Movimiento(-1, -p.cantidad, -1, 'Pago ${p.descripcion}'));
  }

  static void resolverInversion(Inversion inv) {
    Model.nombre = '';
    deleteInversion(inv.id.toString());
    actualizarSaldo(
        (double.parse(getSaldoCuenta(0)) + inv.cantidad_actual).toString());
    addSaldo(inv.cantidad_actual, 0);
    crearMovimiento(
        new Movimiento(-1, inv.cantidad_actual, -1, 'Inv. ${inv.descripcion}'));
  }

  static void limpiarSesion() {
    Model.clear();
  }

  static void actualizar() {
    Model.nombre = '';
  }

  static bool realizarTransferencia( String idCuentaDestino, String cantidad, String concepto) {
    crearTransferencia(cantidad, idCuentaDestino, concepto);
    actualizarSaldo((double.parse(getSaldoCuenta(0)) - double.parse(cantidad)).toString());
    actualizarSaldoTransferencia(double.parse(cantidad).toString(), idCuentaDestino);
    crearMovimiento(new Movimiento(-1, -(double.parse(cantidad)), -1, 'Transferencia'));
    crearMovimientoTransferencia( new Movimiento(-1, (double.parse(cantidad)), -1, 'Transf. a favor'), idCuentaDestino);
    return true;
  }

  static bool solicitarTarjeta() {
    crearSolicitudTarjeta();
    return true;
  }

  static Future<bool> borrarNotificaciones() async {
    for (int i = 0; i < Model.misNotificaciones.length; i++) {
      if (Model.misNotificaciones[i].resuelto == 1 || Model.misNotificaciones[i].resuelto == -1) {
        await deleteNotificaciones(Model.misNotificaciones[i].id.toString());
        Model.misNotificaciones.removeAt(i);
      }
    }
    return true;
  }

  static bool tieneNotificacionesSinBorrar() {
    bool tiene = false;
    for (int i = 0; i < Model.misNotificaciones.length; i++) {
      if (Model.misNotificaciones[i].resuelto == 1 ||
          Model.misNotificaciones[i].resuelto == -1) {
        tiene = true;
      }
    }
    return tiene;
  }

  /* ------------------------------------ */
  /*
    Para pruebas de unidad
   */

  static Prestamo solicitarPrestamoModelo(
          String cantidad, String cuotas, String interes) =>
      Model._solicitarPrestamo(cantidad, cuotas, interes, 'Prueba');

  /*************/

  static Controller getInstance() {
    if (_instance == null) _instance = new Controller();
    return _instance;
  }

  static void inicializarPanel() {
    if (Model._numCuentas() == 0 && numTarjetas() == 0) {
      Model.clear();
      Model.simularEstadoBolsa();
    }
  }

  static void solicitarPrestamo(String cantidad, String cuotas, String interes,
      String concepto, BuildContext context) async {
    Prestamo prest;
    String resultado = '';
    prest = Model._solicitarPrestamo(cantidad, cuotas, interes, concepto);
    bool haCambiado = prest.cuotas != int.parse(cuotas) * 12;

    if (haCambiado) {
      resultado +=
          'Le ofrecemos los siguientes términos\nCantidad: ${prest.cantidad} €\nCuotas: ${prest.cuotas} meses\nInteres: ${prest.interes} %';
      showAlertDialogPrestamos(context, resultado, prest);
    } else {
      if (prest.interes == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Salde deudas antes!'),
          ),
        );
        Navigator.pop(context);
      } else {
        addSaldo(prest.cantidad, 0);
        print('EL PRESTAMO CONCEPTO' + prest.descripcion);
        bool confirmacion = await crearSolicitudPrestamo(prest);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Solicitando el prestamo....'),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  static showAlertDialogPrestamos(
      BuildContext context, String text, Prestamo p) async {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Rechazar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Aceptar"),
      onPressed: () async {
        await crearSolicitudPrestamo(p);
        Navigator.pop(context);
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

  static double calculoInversionFinal(String _cantidad) {
    double res = 0.0;

    switch (miEstadoBolsa) {
      case EstadoBolsa.SUBIENDO:
        {
          res = double.parse(_cantidad) -
              (double.parse(_cantidad) * 0.1) -
              (double.parse(_cantidad) * (comisionHoy! / 100));
        }
        break;
      case EstadoBolsa.BAJANDO:
        {
          res = double.parse(_cantidad) +
              (double.parse(_cantidad) * 0.3) -
              (double.parse(_cantidad) * (comisionHoy! / 100));
        }
        break;
      case EstadoBolsa.NORMAL:
        {
          res = double.parse(_cantidad) -
              (double.parse(_cantidad) * 0.03) -
              (double.parse(_cantidad) * (comisionHoy! / 100));
        }
        break;
    }

    return res;
  }

  static Future<bool> realizarInversion(String cantidad, String cuotas, String interes, String concepto, BuildContext context) async {
    Inversion inv;
    String resultado = '';
    inv = new Inversion(-1, double.parse(cantidad), double.parse(cantidad), double.parse(interes), int.parse(cuotas), concepto);
    resultado += 'El banco se quedará con ${(inv.cantidad_inicial * (comisionHoy! / 100)).toStringAsFixed(2)} € y como la bolsa está ${miEstadoBolsa.toString().split('.').last} finalmente obtendrá ${calculoInversionFinal(cantidad)} €';
    inv.cantidad_inicial = double.parse(cantidad);
    inv.cantidad_actual = calculoInversionFinal(cantidad);
    await showAlertDialogInversiones(context, resultado, inv);
    return true;
  }

  static showAlertDialogInversiones(
      BuildContext context, String text, Inversion inversion) async {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Rechazar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Aceptar"),
      onPressed: () async {
        await crearInversion(inversion);
        await crearMovimiento(new Movimiento(-1, -inversion.cantidad_inicial,
            -1, 'Inv. ${inversion.descripcion}'));

        await actualizarSaldo(
            (double.parse(getSaldoCuenta(0)) - inversion.cantidad_inicial)
                .toString());
        Model.addInversion(inversion);
        addSaldo(-inversion.cantidad_inicial, 0);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Inversion realizada!'),
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

  static LineChartData datosBarra(
      String _inversion, String _interes, String _anios) {
    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];
    DateTime now = new DateTime.now();
    var datos = Model._crearDatos(_inversion, _interes, _anios);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '${now.year}';
              case 1:
                return '${now.year + 1}';
              case 2:
                return '${now.year + 2}';
              case 3:
                return '${now.year + 3}';
              case 4:
                return '${now.year + 4}';
              case 5:
                return '${now.year + 5}';
              case 6:
                return '${now.year + 6}';
              case 7:
                return '${now.year + 7}';
              case 8:
                return '${now.year + 8}';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: (datos[0].y <= 1000)
            ? SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                  color: Color(0xff67727d),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                reservedSize: 22,
                margin: 12,
                interval: 50,
              )
            : SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                  color: Color(0xff67727d),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                reservedSize: 22,
                margin: 12,
                interval: datos[0].y / 10,
              ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: datos.length.toDouble() - 1,
      minY: double.parse(_inversion) - 100,
      maxY: datos[datos.length - 1].y,
      lineBarsData: [
        LineChartBarData(
          spots: datos,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  static List<PieChartSectionData> datosSecciones(
      String _inversion, String _interes, String _anios) {
    var datos = Model._crearDatos(_inversion, _interes, _anios);

    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          if (!isTouched)
            return PieChartSectionData(
              color: const Color(0xff0293ee),
              value: double.parse(_inversion),
              title: '${double.parse(_inversion)} €',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
            );
          else
            return PieChartSectionData(
              color: const Color(0xff0293ee),
              value: double.parse(_inversion),
              title: 'INICIAL',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
            );
        case 1:
          if (!isTouched)
            return PieChartSectionData(
              color: const Color(0xfff8b250),
              value: sectores.toDouble(),
              title: '${sectores.toDouble()} €',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
            );
          else
            return PieChartSectionData(
              color: const Color(0xfff8b250),
              value: sectores.toDouble(),
              title: 'FINAL',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
            );
        default:
          return new PieChartSectionData();
      }
    });
  }

  static Widget getEstadoBolsa() {
    if (miEstadoBolsa == EstadoBolsa.BAJANDO)
      return Text("${Controller.miEstadoBolsa.toString().split('.').last}",
          style: TextStyle(
              color: Colors.redAccent,
              fontSize: 17,
              fontWeight: FontWeight.bold),
          textDirection: TextDirection.ltr);
    if (miEstadoBolsa == EstadoBolsa.SUBIENDO)
      return Text("${Controller.miEstadoBolsa.toString().split('.').last}",
          style: TextStyle(
              color: Colors.teal, fontSize: 17, fontWeight: FontWeight.bold),
          textDirection: TextDirection.ltr);
    if (Controller.miEstadoBolsa == EstadoBolsa.NORMAL)
      return Text("${Controller.miEstadoBolsa.toString().split('.').last}",
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          textDirection: TextDirection.ltr);
    return Text('Error al comprobar el estado de la bolsa');
  }
}
