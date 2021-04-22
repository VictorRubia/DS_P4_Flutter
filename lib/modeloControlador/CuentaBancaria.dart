class CuentaBancaria{
  String IBAN;
  double saldo;

  CuentaBancaria(this.IBAN, this.saldo);

  void setIBAN(String _IBAN){
    IBAN = _IBAN;
  }

  void setSaldo(double _saldo){
    saldo = _saldo;
  }

  void aniadirSaldo(double cantidad){
    saldo += cantidad;
  }
}