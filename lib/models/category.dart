class Category {
  int categoryID;
  String categoryName;
  int discount;

  Category({this.categoryName, this.categoryID});

  Category.fromJson(Map<String, dynamic> json)
      : categoryID = json["categoryID"],
        categoryName = json["name"], 
        discount=json["discount"];

  
  Map<String,dynamic> toJson() =>{
    "name":categoryName,
    "categoryID":categoryID
  };
}




