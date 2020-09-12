class CardModel{
String cardNumber,cvv,ownerName,ownerSurname,expirationYear,expirationMonth;

CardModel({this.cardNumber,this.cvv,this.expirationMonth,this.expirationYear,this.ownerName,this.ownerSurname});
    CardModel.fromJson(Map<String, dynamic> json)
      : 
      cardNumber=json["cardNumber"],
      cvv=json["cvv"],
      expirationMonth=json["expirationMonth"],
      expirationYear=json["expirationYear"],
      ownerName=json["ownerName"],
      ownerSurname=json["ownerSurname"]
      ;
  Map<String,dynamic> toJson() =>{
    "cardNumber":cardNumber,
    "cvv":cvv,
    "expirationMonth":expirationMonth,
    "expirationYear":expirationYear,
    "ownerName":ownerName,
    "ownerSurname":ownerSurname
  };
}