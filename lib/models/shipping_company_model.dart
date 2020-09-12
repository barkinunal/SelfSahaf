class ShippingCompanyModel{
  int shippingCompanyID;
  String companyName;
  double price;
  String website;
ShippingCompanyModel({
  this.companyName,this.price,this.shippingCompanyID, this.website
});

  ShippingCompanyModel.fromJson(Map<String, dynamic> json)
      : shippingCompanyID=json["shippingCompanyID"],
      price=json["price"],
      companyName=json["companyName"],
      website=json["website"]
      ;
}