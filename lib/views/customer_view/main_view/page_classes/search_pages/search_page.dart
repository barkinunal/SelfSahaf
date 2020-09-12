import 'package:Selfsahaf/controller/product_services.dart';
import 'package:Selfsahaf/controller/search_service.dart';
import 'package:Selfsahaf/models/book.dart';
import 'package:Selfsahaf/models/category.dart';
import 'package:Selfsahaf/views/customer_view/main_view/page_classes/main_page/sahaf_drawer.dart';
import 'package:Selfsahaf/views/customer_view/main_view/page_classes/search_pages/search_page_products.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/views/registration/input_field.dart';

class SearchPage extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchService get searchService => GetIt.I<SearchService>();
  ProductService get productService => GetIt.I<ProductService>();
  TextEditingController _minNumber = TextEditingController();
  TextEditingController _maxNumber = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _isbnController = TextEditingController();
  List<Book> books;
  List<Category> categories;
  Category selectedCategory;
  bool _isLoading = true;
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

  final _numberFormKey = GlobalKey<FormState>();

  final _nameFormKey = GlobalKey<FormState>();

  final _isbnFromKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  _getCategories() async {
    setState(() {
      _isLoading = true;
    });
    categories = await productService.getCategories();
    print(categories);
    setState(() {
      _isLoading = false;
    });
  }

  String _booknameValidation(String email) {
    bool emailValid = false;
    if (email.length >= 1) emailValid = true;
    return emailValid ? null : 'not valid book name.';
  }

  String _isbnValidation(String isbn) {
    bool isbnValid = false;
    if (isbn.length > 10) isbnValid = true;

    return isbnValid ? null : 'not valid isbn number';
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  String _numberValidation(String value) {
    if (isNumeric(value)) {
      if (double.parse(value) < 0 || double.parse(value) >= 999999999)
        return "invalid";
      else {
        return null;
      }
    } else
      return "invalid";
  }

  bool _maxminValidation(int max, int min) {
    bool valid = false;
    if (max > min) {
      valid = true;
    }
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SahafDrawer(),
        appBar: AppBar(
          title: Container(
              height: 50,
              child: Image.asset("images/logo_white/logo_white.png")),
        ),
        body: (_isLoading)
            ? Container(
                color: Colors.transparent,
                child: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Search",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Form(
                        key: _nameFormKey,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 3,
                                child: Text(
                                  "By Name",
                                  style: TextStyle(color: Colors.white),
                                )),
                            Expanded(
                              flex: 8,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 8,
                                    child: InputField(
                                      lines: 1,
                                      controller: _nameController,
                                      inputType: TextInputType.text,
                                      validation: _booknameValidation,
                                      labelText: "Name",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: FlatButton(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Icon(Icons.search,
                                          color:
                                              Theme.of(context).primaryColor),
                                      onPressed: () {
                                        print("sa");
                                        if (_nameFormKey.currentState
                                            .validate())
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      SearchPageProducts(
                                                        type: 3,
                                                        searchValue:
                                                            _nameController
                                                                .text,
                                                        to: 0,
                                                        from: 0,
                                                      )));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 50,
                      thickness: 2,
                      color: Colors.white,
                    ),
                    Center(
                      child: Form(
                        key: _isbnFromKey,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 3,
                                child: Text(
                                  "By ISBN",
                                  style: TextStyle(color: Colors.white),
                                )),
                            Expanded(
                              flex: 8,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 8,
                                    child: InputField(
                                      lines: 1,
                                      controller: _isbnController,
                                      inputType: TextInputType.number,
                                      validation: _isbnValidation,
                                      labelText: "ISBN",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: FlatButton(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Icon(Icons.search,
                                          color:
                                              Theme.of(context).primaryColor),
                                      onPressed: () {
                                        if (_isbnFromKey.currentState
                                            .validate())
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      SearchPageProducts(
                                                        type: 1,
                                                        searchValue:
                                                            _isbnController
                                                                .text,
                                                      )));
                                        print("BURA DAHA BITMEDI BITER INS");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 50,
                      thickness: 2,
                      color: Colors.white,
                    ),
                    Center(
                      child: Form(
                        key: _numberFormKey,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 3,
                                child: Text(
                                  "By Price",
                                  style: TextStyle(color: Colors.white),
                                )),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              flex: 4,
                              child: InputField(
                                lines: 1,
                                controller: _minNumber,
                                inputType: TextInputType.number,
                                validation: _numberValidation,
                                labelText: "Min",
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 4,
                              child: InputField(
                                lines: 1,
                                controller: _maxNumber,
                                inputType: TextInputType.number,
                                validation: _numberValidation,
                                labelText: "Max",
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              flex: 2,
                              child: FlatButton(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Icon(Icons.search,
                                    color: Theme.of(context).primaryColor),
                                onPressed: () {
                                  if (_numberFormKey.currentState.validate()) {
                                    if (_maxminValidation(
                                        int.parse(_maxNumber.text),
                                        int.parse(_minNumber.text))) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  SearchPageProducts(
                                                    type: 4,
                                                    to: double.parse(
                                                        _maxNumber.text),
                                                    from: double.parse(
                                                        _minNumber.text),
                                                  )));
                                    } else {
                                      return showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              title: Text(
                                                "Warning!",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              content: Text(
                                                "Maximum number cannot be smaller than minimum number!",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16)),
                                                  color: Colors.white,
                                                  child: Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 50,
                      thickness: 2,
                      color: Colors.white,
                    ),
                    Center(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Text(
                                "By Language",
                                style: TextStyle(color: Colors.white),
                              )),
                          Expanded(
                            flex: 8,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 8,
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: Theme(
                                        data: ThemeData(
                                            canvasColor: Color.fromRGBO(
                                                255, 144, 77, 1)),
                                        child: SafeArea(
                                          child: DropdownButton<String>(
                                            hint: Text(
                                              "Select Language",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            items: languages
                                                .map((String dropdownItem) {
                                              return DropdownMenuItem<String>(
                                                value: dropdownItem,
                                                child: Text(
                                                  dropdownItem,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged:
                                                (String newValueSelected) {
                                              setState(() {
                                                this.selectedLanguage =
                                                    newValueSelected;
                                              });
                                            },
                                            value: this.selectedLanguage,
                                          ),
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: FlatButton(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Icon(Icons.search,
                                        color: Theme.of(context).primaryColor),
                                    onPressed: () {
                                      if (selectedLanguage != null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    SearchPageProducts(
                                                        type: 2,
                                                        searchValue:
                                                            selectedLanguage)));
                                      } else {
                                        ErrorDialog().showErrorDialog(
                                            context,
                                            "Error!",
                                            "Please select a language");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 50,
                      thickness: 2,
                      color: Colors.white,
                    ),
                    Center(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Text(
                                "By Category",
                                style: TextStyle(color: Colors.white),
                              )),
                          Expanded(
                            flex: 8,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 8,
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: Theme(
                                        data: ThemeData(
                                            canvasColor: Color.fromRGBO(
                                                255, 144, 77, 1)),
                                        child: SafeArea(
                                          child: DropdownButton<Category>(
                                            hint: Text(
                                              "Select a Category",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            items: categories
                                                .map((Category dropdownItem) {
                                              return DropdownMenuItem<Category>(
                                                value: dropdownItem,
                                                child: Text(
                                                  dropdownItem.categoryName,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged:
                                                (Category newValueSelected) {
                                              setState(() {
                                                this.selectedCategory =
                                                    newValueSelected;
                                              });
                                            },
                                            value: this.selectedCategory,
                                          ),
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: FlatButton(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Icon(Icons.search,
                                        color: Theme.of(context).primaryColor),
                                    onPressed: () {
                                      if (selectedCategory != null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    SearchPageProducts(
                                                      type: 0,
                                                      searchValue:
                                                          selectedCategory
                                                              .categoryName,
                                                    )));
                                      } else {
                                        ErrorDialog().showErrorDialog(
                                            context,
                                            "Error",
                                            "Please select a category.");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}
