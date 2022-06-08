class CashoutRequestModel {
  final String? paypalEmail;
  final int moneyToBeGiven;
  final String? userEmail;
  final String purpose;
  CashoutRequestModel(
      {required this.userEmail,
      required this.moneyToBeGiven,
      required this.paypalEmail,
      required this.purpose});
}
