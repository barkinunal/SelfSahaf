import 'package:Selfsahaf/models/category.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Selfsahaf/controller/category_controller.dart';
import 'package:Selfsahaf/views/customer_view/category_view/category_card.dart';
import 'package:Selfsahaf/views/registration/input_field.dart';
import 'package:get_it/get_it.dart';

class EditCategories extends StatefulWidget {
  @override
  _EditCategoriesState createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
  CategoryService _categoryService = GetIt.I<CategoryService>();
  List<Category> _categories;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    _getCategories(context);
  }

  bool error = false;
  String errorMessage = " ";
  _getCategories(BuildContext context) async {
    _categoryService.getCategories().then((value) {
      if (!value.error) {
        setState(() {
          this._categories = value.data;
        });
      } else {
        ErrorDialog().showErrorDialog(context, "Error", value.errorMessage);
        setState(() {
          this._categories = value.data;
        });
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _discountFromKey=GlobalKey<FormState>();
/*
  void messagepopup(int val) {
    var _title;
    var _content;
    if (val == 0) {
      _title = "Hata!";
      _content = "Baglanti Hatasi";
    } else if (val == 1) {
      _title = "Mesaj";
      _content = "Kategori Kaydedildi";
    } else {
      _title = "Hata!";
      _content = "Gecersiz Kategori Ismi";
    }
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: Color(0xffe65100),
            title: Text(
              _title,
              style: TextStyle(color: Colors.white),
            ),
            content: Text(_content, style: TextStyle(color: Colors.white)),
            actions: <Widget>[
              FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  "Tamam",
                  style: TextStyle(color: Color(0xffe65100)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                width: 5,
              ),
            ],
          );
        });
  }*/

  CategoryService categoryApi = new CategoryService();
  TextEditingController categorynameController = TextEditingController();
  TextEditingController discountController=TextEditingController();

    bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  String discountValidation(String discount) {

    if (!isNumeric(discount)) return "price should be number";
    if(int.parse(discount)>100 ||int.parse(discount)<0 )
     return 'not valid price';
    return  null;
  }
  String categorynameValidation(String categoryname) {
    if (categoryname.length < 2) {
      return "Category name too small.";
    } else
      return null;
  }

  @override
  Widget build(BuildContext widget) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios)),
        title: Container(
            height: 50, child: Image.asset("images/logo_white/logo_white.png")),
      ),
      body: RefreshIndicator(
          onRefresh: () => _getCategories(context),
          key: _refreshIndicatorKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Categories",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              Divider(
                thickness: 2,
                color: Colors.white,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, index) {
                  return (_categories == null)
                      ? Center(
                          child: Text(
                            "No Category",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Row(
                          children: <Widget>[
                            Expanded(
                              flex: 9,
                              child: CategoryCard(
                                  categoryName:
                                      _categories[index].categoryName,
                                       discount: _categories[index].discount,),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 100,
                       
                                decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25))),
                                child: InkWell(
                                  onTap: () {
                                    discountController.text=_categories[index].discount.toString();
                                       return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Color(0xffe65100),
                  title: Text(
                    "Add Discount",
                    style: TextStyle(color: Colors.white),
                  ),
                  content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return SafeArea(
                      child: Form(
                        key: _discountFromKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            InputField(
                              labelText: "Discount",
                              inputType: TextInputType.text,
                              validation: discountValidation,
                              controller: discountController,
                            ),
                            (error)
                                ? Text(
                                    errorMessage,
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Container(),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 5,
                                      child: SizedBox(
                                        width: 50,
                                      )),
                                  Expanded(
                                    flex: 4,
                                    child: FlatButton(
                                      onPressed: () {
                                        if(_discountFromKey.currentState.validate())
                                        _categoryService
                                          .setDiscountToCategory(_categories[index].categoryID, int.parse(discountController.text))
                                            .then((value) {
                                          if (!value.error) {
                                            setState(() {
                                              error = false;
                                            });
                                            _getCategories(context);
                                            Navigator.pop(context);
                                          } else {
                                            setState(() {
                                              error = true;
                                              errorMessage = value.errorMessage;
                                            });
                                          }
                                        });
                                      },
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        "Add",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        width: 20,
                                      )),
                                  Expanded(
                                    flex: 6,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                );
              });

                                  },
                                  child: Container(
                                      child: Icon(Icons.attach_money,
                                          size: 25,
                                          color: Theme.of(context).primaryColor)),
                                ),
                              ),
                            )
                          ],
                        );
                },
                itemCount: (_categories == null) ? 1 : _categories.length,
              ),
              SizedBox(
                height: 80,
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          categorynameController.text = "";
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Color(0xffe65100),
                  title: Text(
                    "Add New Category",
                    style: TextStyle(color: Colors.white),
                  ),
                  content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return SafeArea(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            InputField(
                              labelText: "Category Name",
                              inputType: TextInputType.text,
                              validation: categorynameValidation,
                              controller: categorynameController,
                            ),
                            (error)
                                ? Text(
                                    errorMessage,
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Container(),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 6,
                                      child: SizedBox(
                                        width: 50,
                                      )),
                                  Expanded(
                                    flex: 4,
                                    child: FlatButton(
                                      onPressed: () {
                                        if(_formKey.currentState.validate())
                                        _categoryService
                                            .addCategory(
                                                categorynameController.text)
                                            .then((value) {
                                          if (!value.error) {
                                            setState(() {
                                              error = false;
                                            });
                                            _getCategories(context);
                                            Navigator.pop(context);
                                          } else {
                                            setState(() {
                                              error = true;
                                              errorMessage = value.errorMessage;
                                            });
                                          }
                                        });
                                      },
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        "Add",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        width: 20,
                                      )),
                                  Expanded(
                                    flex: 4,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                );
              });
        },
        elevation: 6,
        backgroundColor: Colors.white,
        child: InkWell(
          child: Icon(
            Icons.add,
            color: Color(0xffe65100),
          ),
        ),
      ),
    );
  }
}
