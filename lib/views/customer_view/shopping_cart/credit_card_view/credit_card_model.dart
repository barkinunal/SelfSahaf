class CreditCardModel {

  CreditCardModel(this.cardNumber, this.expiryDate, this.cardHolderName, this.cardHolderSurname,this.cvvCode, this.isCvvFocused);

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cardHolderSurname = '';
  String cvvCode = '';
  bool isCvvFocused = false;
}