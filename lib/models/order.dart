import 'package:Selfsahaf/models/book.dart';
import 'package:Selfsahaf/models/shipping_info.dart';
import 'package:Selfsahaf/models/user.dart';

class Order {
  int orderDetailID;
  int quantity;
  String status;
  User buyer;
  User seller;
ShippingInfo shippingInfo;
  Book product;
    double price;
  Order({
    this.orderDetailID,
    this.quantity,
    this.status,
    this.buyer,
    this.seller,
    this.product,
    this.price,
    this.shippingInfo
  });

  Map<String, dynamic> toJson() {
    return {
      "orderDetailID": orderDetailID,
      "product": product,
      "quantity": quantity,
      "status": status,
      "buyer": buyer,
      "seller": seller,
    };
  }

  Order.fromJson(Map<String, dynamic> json)
      : orderDetailID = json["orderDetailID"],
        quantity = json["quantity"],
        status = json["status"],
        buyer = User.fromJson(json["buyer"]),
        seller = User.fromJson(json["user"]),
        price = json["product"]["sells"][0]['currentPrice'],
        shippingInfo=ShippingInfo.fromJson(json["shippingInfo"]),
        product=Book.fromJson(json["product"])
        ;

  

}
