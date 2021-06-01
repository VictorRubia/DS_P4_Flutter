import 'dart:core';

class Notificaciones{
  int id;
  int idObjetivo;
  int tipo; // 0 si es tipo tarjeta ; 1 si es tipo prestamo
  int resuelto; //0 si no, 1 si sí

  Notificaciones(this.id, this.idObjetivo, this.tipo, this.resuelto);

}