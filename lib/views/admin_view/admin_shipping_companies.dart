import 'package:Selfsahaf/controller/shipping_company_service.dart';
import 'package:Selfsahaf/models/shipping_company_model.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:Selfsahaf/views/registration/input_field.dart';
import 'package:flutter/material.dart';
import 'package:Selfsahaf/views/admin_view/admin_company_card.dart';
import 'package:get_it/get_it.dart';

class ShippingCompanies extends StatefulWidget {
  @override
  _ShippingCompaniesState createState() => _ShippingCompaniesState();
}

class _ShippingCompaniesState extends State<ShippingCompanies> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  ShippingCompanyService companyService = GetIt.I<ShippingCompanyService>();
  List<ShippingCompanyModel> _companies;
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _companyPriceController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool error = false;
  String errorMessage = "";
  @override
  void initState() {
    _getCompanies(context);
  }

  _getCompanies(BuildContext context) async {
    companyService.getCompanies().then((value) {
      if (!value.error) {
        setState(() {
          this._companies = value.data;
        });
      } else {
        ErrorDialog().showErrorDialog(context, "Error", value.errorMessage);
        setState(() {
          this._companies = value.data;
        });
      }
    });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  String _priceValidation(String price) {
    if (!isNumeric(price)) return "price should be number";

    if (int.parse(price) <= 0)
      return "price can not be less then or equal zero";

    return null;
  }

  String _companyNameValidation(String name) {
    bool emailValid = false;
    if (name.length >= 2) emailValid = true;
    return emailValid ? null : 'not valid company name.';
  }

  String _companyWebsitevalidation(String website) {
    bool emailValid = false;
    if (website.length >= 2) emailValid = true;
    return emailValid ? null : 'not valid website.';
  }

  _addCategory() async {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Theme.of(context).primaryColor,
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: InputField(
                            lines: 1,
                            controller: _companyNameController,
                            inputType: TextInputType.text,
                            labelText: "Company Name",
                            suffixIcon: Icon(
                              Icons.local_shipping,
                              color: Colors.white,
                            ),
                            validation: _companyNameValidation,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: InputField(
                            lines: 1,
                            controller: _websiteController,
                            inputType: TextInputType.text,
                            labelText: "Website",
                            suffixIcon: Icon(
                              Icons.web_asset,
                              color: Colors.white,
                            ),
                            validation: _companyWebsitevalidation,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: InputField(
                            lines: 1,
                            controller: _companyPriceController,
                            inputType: TextInputType.number,
                            labelText: "Price",
                            suffixIcon: Icon(
                              Icons.attach_money,
                              color: Colors.white,
                            ),
                            validation: _priceValidation,
                          ),
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
                                    if (_formKey.currentState.validate()) {
                                      companyService
                                          .addCompany(ShippingCompanyModel(
                                              companyName:
                                                  _companyNameController.text,
                                              price: double.parse(
                                                  _companyPriceController.text),
                                              website: _websiteController.text))
                                          .then((value) {
                                        if (!value.error) {
                                          _getCompanies(context);
                                          setState(() {
                                            error = false;
                                          });
                                          Navigator.pop(context);
                                        } else {
                                          setState(() {
                                            error = true;
                                            errorMessage = value.errorMessage;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
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
                                        color: Theme.of(context).primaryColor),
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
              title:
                  Text("Add Company", style: TextStyle(color: Colors.white)),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addCategory(),
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
        ),
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios)),
          title: Container(
              height: 50,
              child: Image.asset("images/logo_white/logo_white.png")),
        ),
        body: RefreshIndicator(
            onRefresh: () => _getCompanies(context),
            key: _refreshIndicatorKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Edit Companies",
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
                    return (_companies == null)
                        ? Center(
                            child: Text(
                              "No Company",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ShippingCompaniesCardAdmin(
                            companyName: _companies[index].companyName,
                            price: _companies[index].price,
                          );
                  },
                  itemCount: (_companies == null) ? 1 : _companies.length,
                ),
                SizedBox(
                  height: 80,
                )
              ],
            )));
  }
}
