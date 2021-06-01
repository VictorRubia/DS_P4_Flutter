class OperationModel {
  String name;
  String selectedIcon;
  String unselectedIcon;

  OperationModel(this.name, this.selectedIcon, this.unselectedIcon);
}

List<OperationModel> datas = operationsData.map((item) =>
    OperationModel(item['name']!, item['selectedIcon']!, item['unselectedIcon']!)).toList();

var operationsData = [
  {
    "name": "Área\nPréstamos",
    "selectedIcon": "assets/svg/money_transfer_white.svg",
    "unselectedIcon": "assets/svg/money_transfer_blue.svg"
  },
  {
    "name": "Área Inversiones",
    "selectedIcon": "assets/svg/bank_withdraw_white.svg",
    "unselectedIcon": "assets/svg/bank_withdraw_blue.svg"
  },
  {
    "name": "Simulador\nInversiones",
    "selectedIcon": "assets/svg/insight_tracking_white.svg",
    "unselectedIcon": "assets/svg/insight_tracking_blue.svg"
  },
  {
    "name": "Realizar\nTransferencia",
    "selectedIcon": "assets/svg/transaction-white.svg",
    "unselectedIcon": "assets/svg/transaction-blue.svg"
  },
  {
    "name": "Solicitar\nTarjeta",
    "selectedIcon": "assets/svg/credit-card-white.svg",
    "unselectedIcon": "assets/svg/credit-card-blue.svg"
  },


];