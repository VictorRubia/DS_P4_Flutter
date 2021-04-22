class Prestamo{
  double cantidad;
  int cuotas;
  double interes;
  String descripcion;

  Prestamo(this.cantidad, this.cuotas, this.interes, this.descripcion);

  void addCuotas(int num){
    cuotas += num;
  }
}