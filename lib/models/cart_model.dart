import 'package:Selfsahaf/models/book.dart';
class CartModel{
  int amount;
  double price;
  int sellerID;
  int productID;
  Book book;
    CartModel.fromJson(Map<String, dynamic> json)
      : amount=json["amount"],
      price=json["price"],
      sellerID=json["sellerID"],
      productID=json["productID"],
      book=Book.fromJson(json["product"])
      ;
}