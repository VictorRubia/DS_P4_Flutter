class Tarjeta{
  String num_tarjeta;
  String fecha_caducidad;
  String cvv;
  String tipo;

  Tarjeta(this.num_tarjeta, this.fecha_caducidad, this.cvv, this.tipo);

  void setNum(String _num_tarjeta){
    num_tarjeta = _num_tarjeta;
  }

}