import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/models/address.dart';
import 'package:Selfsahaf/models/user.dart';

class AddAddress extends StatefulWidget {
  int addType; //0 user address add 2 user address update 1 add seller address
  String addressName, addressLine, city, country, postalCode;
  int addressID;
  AddAddress(
      {@required this.addType,
      this.addressName,
      this.addressLine,
      this.city,
      this.country,
      this.postalCode,
      this.addressID});
  @override
  _AddAddressState createState() {
    return _AddAddressState();
  }
}

class _AddAddressState extends State<AddAddress> {
  final _formKey = GlobalKey<FormState>();
  AuthService userService = GetIt.I<AuthService>();
  TextEditingController _addresline = TextEditingController();
  TextEditingController _postalcode = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    if (widget.addressID != null) {
      _addresline.text = widget.addressLine;
      _nameController.text = widget.addressName;
      _postalcode.text = widget.postalCode;
      _city = widget.city;
      _country = widget.country;
    }
  }

  var _countries = ['Country', 'Turkey', 'England'];
  var _cities = {
    'Country': ['City'],
    'Turkey': ['City', 'Ankara', 'İstanbul', 'Yozgat'],
    'England': ['City', 'Manchester', 'London']
  };

  var _country = 'Country';
  var _city = 'City';

  String _nameValidation(String name) {
    if (name.length > 1)
      return null;
    else
      return "Too small name";
  }

  String _addressLineValidation(String addressLine) {
    return (addressLine.length > 10) ? null : "Too small address";
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  String _postalCodeValidation(String postalCode) {
    return (!isNumeric(postalCode))
        ? "Postal Code must be numberic"
        : (int.parse(postalCode) < 0) ? "Postal Code must be postive" : null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                width: 300,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  validator: _nameValidation,
                  controller: _nameController,
                  maxLines: 1,
                  maxLength: 10,
                  decoration: InputDecoration(
                    
                      errorStyle: TextStyle(color: Colors.white),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      labelText: "Address Name",
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          gapPadding: 2.0,
                          borderSide:
                              BorderSide(color: Colors.white, width: 3.0),
                          borderRadius: new BorderRadius.circular(16.0)),
                      enabledBorder: new OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: new BorderRadius.circular(16.0),
                        borderSide: new BorderSide(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      errorBorder: new OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: new BorderRadius.circular(16.0),
                        borderSide: new BorderSide(
                          color: Colors.deepPurple,
                          width: 3.0,
                        ),
                      ),
                      focusedErrorBorder: new OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: new BorderRadius.circular(16.0),
                        borderSide: new BorderSide(
                          color: Colors.deepPurple,
                          width: 3.0,
                        ),
                      )),
                  autofocus: false,
                ),
              ),
              SizedBox(height: 8,),
              Container(
                width: 300,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  validator: _addressLineValidation,
                  controller: _addresline,
                  maxLines: 3,
                  maxLength: 255,
                  decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.white),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      labelText: "Address",
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          gapPadding: 2.0,
                          borderSide:
                              BorderSide(color: Colors.white, width: 3.0),
                          borderRadius: new BorderRadius.circular(16.0)),
                      enabledBorder: new OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: new BorderRadius.circular(16.0),
                        borderSide: new BorderSide(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      errorBorder: new OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: new BorderRadius.circular(16.0),
                        borderSide: new BorderSide(
                          color: Colors.deepPurple,
                          width: 3.0,
                        ),
                      ),
                      focusedErrorBorder: new OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: new BorderRadius.circular(16.0),
                        borderSide: new BorderSide(
                          color: Colors.deepPurple,
                          width: 3.0,
                        ),
                      )),
                  autofocus: false,
                ),
              ),
              SizedBox(height: 8,),
              Container(
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  validator: _postalCodeValidation,
                  keyboardType: TextInputType.number,
                  controller: _postalcode,
                  autovalidate: true,
                  decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.white),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      labelText: "Postal Code",
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          gapPadding: 2.0,
                          borderSide:
                              BorderSide(color: Colors.white, width: 3.0),
                          borderRadius: new BorderRadius.circular(16.0)),
                      enabledBorder: new OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: new BorderRadius.circular(16.0),
                        borderSide: new BorderSide(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      errorBorder: new OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: new BorderRadius.circular(16.0),
                        borderSide: new BorderSide(
                          color: Colors.deepPurple,
                          width: 3.0,
                        ),
                      ),
                      focusedErrorBorder: new OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: new BorderRadius.circular(16.0),
                        borderSide: new BorderSide(
                          color: Colors.deepPurple,
                          width: 3.0,
                        ),
                      )),
                  autofocus: false,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 50, 5),
                    child: DropdownButton<String>(
                      hint: Text("Country"),
                      items: _countries.map((String dropdownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropdownStringItem,
                          child: Text(dropdownStringItem),
                        );
                      }).toList(),
                      onChanged: (String newValueSelected) {
                        setState(() {
                          _country = newValueSelected;
                          _city = _cities[newValueSelected][0];
                        });
                      },
                      value: _country,
                    ),
                  ),
                  Container(
                      child: DropdownButton(
                    items: _cities[_country].map((String dropDownItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownItem,
                        child: Text(dropDownItem),
                      );
                    }).toList(),
                    onChanged: (String city) {
                      setState(() {
                        this._city = city;
                      });
                    },
                    value: this._city,
                  )),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 15, 10, 0),
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 12,),
                    InkWell(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 30,
                        ),
                        onTap: () {
                          if (_formKey.currentState.validate() &&
                              _country != "Country" &&
                              _city != "City") {
                            if (widget.addType == 0) {
                              print(_country);
                              userService
                                  .addUserAddress(Address(
                                      addressLine: this._addresline.text,
                                      addressName: this._nameController.text,
                                      city: this._city,
                                      country: this._country,
                                      postalCode: this._postalcode.text))
                                  .then((value) {
                                if (value == 200)
                                  Navigator.pop(context);
                                else
                                  print("Erroorrr");
                              });
                            } else if (widget.addType == 2) {
                              userService
                                  .updateAddress(Address(
                                      addressLine: this._addresline.text,
                                      addressName: this._nameController.text,
                                      city: this._city,
                                      country: this._country,
                                      postalCode: this._postalcode.text,
                                      addressID: widget.addressID))
                                  .then((value) => Navigator.pop(context));
                            } else if (widget.addType == 1) {
                              User user = userService.getUser();
                              userService
                                  .addSellerAddress(Address(
                                addressLine: this._addresline.text,
                                addressName: this._nameController.text,
                                city: this._city,
                                country: this._country,
                                postalCode: this._postalcode.text,
                              ))
                                  .then((value) {
                                userService
                                    .becameSeller(user)
                                    .then((value) => Navigator.pop(context));
                              });
                            }
                           
                          }
                        })
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
