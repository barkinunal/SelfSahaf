class GivenOrders{
  int orderID;
  String dateTime;
  int itemCount;
  GivenOrders({this.dateTime,this.itemCount,this.orderID});

   GivenOrders.fromJson(Map<String, dynamic> json)
      : orderID = json["orderID"],
        dateTime = json["datetime"],
        itemCount=json["itemCount"]
        ;
}