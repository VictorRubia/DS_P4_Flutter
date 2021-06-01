class Prestamo{
  int id;
  double cantidad;
  int cuotas;
  double interes;
  String descripcion;

  Prestamo(this.id, this.cantidad, this.cuotas, this.interes, this.descripcion);

  void addCuotas(int num){
    cuotas += num;
  }
}