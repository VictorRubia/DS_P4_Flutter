import 'package:flutter_app/modeloControlador/Controller.dart';
import 'package:flutter_app/modeloControlador/Prestamo.dart';
import 'package:test/test.dart';

void main(){
  group('Controlador - Operaciones con Cuenta', (){
    test('Añadir saldo a cuenta debe sumar la cantidad al saldo actual', (){
      Controller.inicializarPanel();
      final saldoInicial = Controller.getSaldoCuenta(0);
      Controller.addSaldo(1000.00, 0);
      expect(double.parse(Controller.getSaldoCuenta(0)), 1000.00+double.parse(saldoInicial));
    });
    test('Añadir prestamo debe añadir un préstamo al cliente', (){
      final prestamosAsignados = Controller.numPrestamos(); // Debe ser 0 al comienzo
      Model.addPrestamo(new Prestamo(0,1000, 12, 1, 'Test'));
      expect(Controller.numPrestamos(), 1);
    });
    test('Se debe solicitar un prestamo de 1500€ a 1 año y a interes del 3%', (){
      Controller.limpiarSesion();
      Controller.inicializarPanel();
      final prestamosAsignados = Controller.numPrestamos(); // Debe ser 0 al comienzo
      Controller.solicitarPrestamoModelo('1500', '12', '3');    // Hemos modificado la funcion solicitar prestamo del controlador para que no necesite BuildContext
      expect(Controller.numPrestamos(), prestamosAsignados+1);
    });
  });
  group('Controlador - Comprobaciones de Cuenta', (){
    test('Valor debe empezar en 2500', (){
      expect(Model.nomina, 2500);
    });
    test('Comprobación de saldo debe devolver false', (){
      Controller.limpiarSesion();
      Controller.inicializarPanel();  // Se inicializa una cuenta bancaria con 3500€
      expect(Controller.tieneSaldo(20000), false);
    });
  });
  group('Comprobación de Filtros Prestamo', (){
    test('Rentabilidad debe de ser incorrecta', (){
      bool test = Model.compruebaRentabilidad(new Prestamo(0,100000, 12, 5, 'Test'));   // Este préstamo va a ser lo suficientemente alto como para que no se otorgue y se proponga uno nuevo
      bool hanCambiadoCondiciones = true;
      expect(hanCambiadoCondiciones, test);
    });
    test('Filtro debe devolver que no es deudor', (){
      Controller.limpiarSesion();
      bool test = Model.compruebaDeudas(new Prestamo(0,100000, 12, 5, 'Test'));   // Este préstamo va a ser lo suficientemente alto como para que no se otorgue y se proponga uno nuevo
      bool notieneDeudas = false;
      expect(test, !notieneDeudas);
    });

  });
}

