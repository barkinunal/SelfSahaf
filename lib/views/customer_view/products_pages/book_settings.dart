import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/models/book.dart';
import 'package:Selfsahaf/views/registration/input_field.dart';
import 'package:Selfsahaf/controller/product_services.dart';
import 'package:Selfsahaf/models/category.dart';

class BookSettingsPage extends StatefulWidget {
  final Book selectedBook;
  BookSettingsPage({@required this.selectedBook});
  @override
  _BookSettingsPage createState() => new _BookSettingsPage();
}

class _BookSettingsPage extends State<BookSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  String _name, _surname, _email, _phoneNumber;

  AuthService userService = GetIt.I<AuthService>();
  ProductService productService = GetIt.I<ProductService>();

  bool _checkSeller = false;

  TextEditingController _sellerController;
  TextEditingController _bookNameController;
  TextEditingController _sellernameController;
  TextEditingController _authorController;
  TextEditingController _langController;
  TextEditingController _isbnController;
  TextEditingController _publisherController;
  TextEditingController _descController;
  TextEditingController _priceController;
  TextEditingController _quantityController;
   TextEditingController discountController=TextEditingController();
  bool _edit = false;
  List<Category> categories;
  Category selectedCategory;
  List<String> languages = [
    "TR",
    "EN",
    "DE",
    "FR",
    "AZ",
    "IT",
    "HE",
    "LA",
    "RU"
  ];
  String selectedLanguage;
  bool _isLoading = true;
String condition="NEW";
String status;
  @override
  void initState() {
    print(widget.selectedBook.sellerName);
    _bookNameController = TextEditingController(text: widget.selectedBook.name);
    _priceController =
        TextEditingController(text: widget.selectedBook.price.toString());
    _authorController =
        TextEditingController(text: widget.selectedBook.authorName);
    _langController = TextEditingController(text: widget.selectedBook.language);
    _isbnController = TextEditingController(text: widget.selectedBook.isbn);
    _publisherController =
        TextEditingController(text: widget.selectedBook.publisher);
    _descController =
        TextEditingController(text: widget.selectedBook.description);
    _quantityController =
        TextEditingController(text: "${widget.selectedBook.quantity}");
    _descController =
        TextEditingController(text: widget.selectedBook.description);
    discountController=TextEditingController(text:"${widget.selectedBook.discount}");
    selectedLanguage = widget.selectedBook.language;
    _getCategories();
    condition=widget.selectedBook.condition;
    status=widget.selectedBook.status;
  }

  _getCategories() async {
    setState(() {
      _isLoading = true;
    });
    categories = await productService.getCategories();
    setState(() {
      for (int i = 0; i < categories.length; i++) {
        if (categories[i].categoryID == widget.selectedBook.categoryID) {
          selectedCategory = categories[i];
          break;
        }
      }
      _isLoading = false;
    });
  }

  String discountValidation(String discount) {

    if (!isNumeric(discount)) return "price should be number";
    if(int.parse(discount)>100 ||int.parse(discount)<0 )
     return 'Discount rate must be between 100% and 0%';
    return  null;
  }
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  String _booknameValidation(String email) {
    bool emailValid = false;
    if (email.length >= 2) emailValid = true;
    return emailValid ? null : 'Book name length should be bigger than 1';
  }

  String _authorValidation(String author) {
    bool authorValid = false;
    if (author.length >= 2) authorValid = true;
    return authorValid ? null : 'Author name length should be bigger than 1';
  }

  String _descriptionValidation(String description) {
    bool descValid = false;
    if (description.length >= 20) descValid = true;
    return descValid ? null : 'Description length should be bigger than 20';
  }

  String _priceValidation(String price) {
    if (!isNumeric(price)) return "price should be number";
    bool priceValid = false;
    if (price.length > 0 && price.length < 7) {
      priceValid = true;
      if (double.parse(price) <= 0)
        return "price can not be less than or equal zero";
    }
    if (price.length >= 7) return "price can be max 3 character";
    return priceValid ? null : 'not valid price';
  }

  String _isbnValidation(String isbn) {
    bool isbnValid = false;
    if (isbn.length > 10) isbnValid = true;
    return isbnValid ? null : 'ISBN number length should be 11 or 13.';
  }

  String _publisherValidation(String pub) {
    bool pubValid = false;
    if (pub.length < 30 && pub.length > 1) pubValid = true;
    return pubValid ? null : 'Publisher name length must be between 1 and 30';
  }

  String _quantityValidation(String quantity) {
    if (!isNumeric(quantity)) return "Quantity should be number";
    bool qValid = false;
    if (quantity.length > 0 && quantity.length < 3) {
      qValid = true;
      if (int.parse(quantity) <= 0)
        return "quantity can not be less then or equal zero";
    }
    
    return qValid ? null : 'not valid quantity';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            print("sa");
            Book oldBook = widget.selectedBook;
            Book updatedBook = Book.bookForUpdate(
              discount: int.parse(discountController.text),
                authorName: _authorController.text,
                description: _descController.text,
                categoryID: selectedCategory.categoryID,
                categoryName: selectedCategory.categoryName,
                imagePath: oldBook.imagePath,
                isbn: _isbnController.text,
                language: selectedLanguage,
                name: _bookNameController.text,
                price: double.parse(_priceController.text),
                productID: oldBook.productID,
                publisher: _publisherController.text,
                quantity: int.parse(_quantityController.text),
                sellerName: userService.getUser().name,
                condition: condition,
                status: status
                );
            productService.updateBook(updatedBook).then((e) {
              if (e == 200) {
                Navigator.of(context).pop(updatedBook);
              }
            });
          }
        },
        child: Icon(
          Icons.save,
          color: Theme.of(context).primaryColor,
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Container(
            height: 50, child: Image.asset("images/logo_white/logo_white.png")),
      ),
      body: (_isLoading)
          ? Center(
              child: Container(
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                  height: double.infinity,
                  child: CircularProgressIndicator()),
            )
          : Container(
              color: Theme.of(context).primaryColor,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: InputField(
                                labelText: "Name",
                                controller: _bookNameController,
                                validation: _booknameValidation,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: InputField(
                                labelText: "Price",
                                controller: _priceController,
                                inputType: TextInputType.number,
                                validation: _priceValidation,
                              ),
                            ),
                          ],
                        ),
                      ),
                       Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: InputField(
                                labelText: "Discount",
                                controller:   discountController,
                                inputType: TextInputType.number,
                                validation: discountValidation,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: InputField(
                                labelText: "Quantitiy",
                                controller: _quantityController,
                                inputType: TextInputType.number,
                                validation: _quantityValidation,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: InputField(
                                labelText: "Author",
                                controller: _authorController,
                                validation: _authorValidation,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: InputField(
                                lines: 5,
                                labelText: "Description",
                                controller: _descController,
                                validation: _descriptionValidation,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: InputField(
                                labelText: "ISBN",
                                controller: _isbnController,
                                validation: _isbnValidation,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: InputField(
                                labelText: "Publisher",
                                controller: _publisherController,
                                validation: _publisherValidation,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(children: <Widget>[Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 10, 12),
                          child: Theme(
                            data: ThemeData(
                                canvasColor: Color.fromRGBO(255, 144, 77, 1)),
                            child: SafeArea(
                              child: DropdownButton<Category>(
                                hint: Text(widget.selectedBook.categoryName,
                                    style: TextStyle(color: Colors.white)),
                                items: categories.map((Category dropdownItem) {
                                  return DropdownMenuItem<Category>(
                                    value: dropdownItem,
                                    child: Text(
                                      dropdownItem.categoryName,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (Category newValueSelected) {
                                  setState(() {
                                    this.selectedCategory = newValueSelected;
                                  });
                                },
                                value: this.selectedCategory,
                              ),
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 10, 12),
                          child: Theme(
                            data: ThemeData(
                                canvasColor: Color.fromRGBO(255, 144, 77, 1)),
                            child: SafeArea(
                              child: DropdownButton<String>(
                                items: languages.map((String dropdownItem) {
                                  return DropdownMenuItem<String>(
                                    value: dropdownItem,
                                    child: Text(
                                      dropdownItem,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String newValueSelected) {
                                  setState(() {
                                    this.selectedLanguage = newValueSelected;
                                  });
                                },
                                value: this.selectedLanguage,
                              ),
                            ),
                          )),
                      Padding(
                           padding: const EdgeInsets.fromLTRB(15, 0, 15, 12),
                          child: Theme(
                            data: ThemeData(
                                canvasColor: Color.fromRGBO(255, 144, 77, 1)),
                            child: SafeArea(
                              child: DropdownButton<String>(
                                
                               
                                items: ["NEW", "SECONDHAND"]
                                    .map((String dropdownItem) {
                                  return DropdownMenuItem<String>(
                                    value: dropdownItem,
                                    child: Text(
                                      dropdownItem,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String newValueSelected) {
                                  setState(() {
                                    this.condition = newValueSelected;
                                  });
                                },
                                value: this.condition,
                              ),
                            ),
                          )),],),
                          SizedBox(height: 50,)
                    ],
                  ),
                ),
              )),
    );
  }
}
