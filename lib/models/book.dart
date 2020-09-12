class Book {
  String authorName;
  String name;
  String description;
  String language;
  String publisher;
  String imagePath;
  String categoryName;
  String isbn;
  String sellerName;
  String status, condition;
  int productID;
  int quantity;
  int discount;
  double price;
  int categoryID;
  int sellerID;
  String userName;
  String userSurname;
  Book(
      {this.authorName,
      this.name,
      this.description,
      this.language,
      this.publisher,
      this.imagePath,
      this.isbn,
      this.quantity,
      this.price,
      this.categoryID,
      this.sellerName,
      this.status,
      this.condition,
      this.discount});
  Book.bookForUpdate(
      {this.authorName,
      this.name,
      this.description,
      this.language,
      this.publisher,
      this.imagePath,
      this.isbn,
      this.quantity,
      this.price,
      this.categoryID,
      this.sellerName,
      this.productID,
      this.categoryName,
      this.condition,
      this.status,
      this.discount});

  Map<String, dynamic> toJsonBook() {
    return {
      "author": authorName,
      "categories": [
        {"categoryID": categoryID}
      ],
      "description": description,
      "isbn": isbn,
      "language": language,
      "name": name,
      "imagePath": imagePath,
      "publisher": publisher,
      "condition": condition,
      "status": status
    };
  }

  Map<String, dynamic> toJsonBookUpdate() {
    return {
      "author": authorName,
      "categories": [
        {"categoryID": categoryID, "name": categoryName}
      ],
      "description": description,
      "isbn": isbn,
      "language": language,
      "name": name,
      "imagePath": imagePath,
      "publisher": publisher,
      "productID": productID,
      "condition": condition,
      "status": status
    };
  }

  Book.fromJson(Map<String, dynamic> json)
      : authorName = json['author'],
        productID = json['productID'],
        name = json['name'],
        description = json['description'],
        publisher = json['publisher'],
        price = json["sells"][0]['currentPrice'],
        quantity = json["sells"][0]['quantity'],
        isbn = json["isbn"],
        categoryName = json["categories"][0]["name"],
        imagePath = json["imagePath"],
        language = json["language"],
        sellerID = json["sells"][0]["sellerID"],
        categoryID = json["categories"][0]["categoryID"],
        userName = json["sells"][0]["user"]["name"],
        userSurname = json["sells"][0]["user"]["surname"],
        condition = json["condition"],
        status = json["status"],
        discount = json["sells"][0]['discount'];

  fromJson(e) {}
}
