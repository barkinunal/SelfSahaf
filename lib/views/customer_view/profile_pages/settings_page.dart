import 'package:Selfsahaf/models/address.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/models/user.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/addAddress.dart';
import 'package:Selfsahaf/views/registration/input_field.dart';

class SettingsPage extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _SettingsPage createState() => new _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  User _user;
  AuthService userService = GetIt.I<AuthService>();
  DateTime _date = DateTime.now();
  Future<Null> selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1923),
      lastDate: _date,
    );

    if (pickedDate != null && pickedDate != _date) {
      setState(() {
        _date = pickedDate;
        dob = _date.toString().split(' ')[0].split('-').reversed.join('/');
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _user = userService.getUser();
    _emailController.text = _user.email;
    _phoneController.text = _user.phoneNumber;
    _fnameController.text = _user.name;
    _surnameController.text = _user.surname;
    dob = _user.dateOfBirth.split("-").reversed.join("/").toString();
    _date = DateTime(
        int.parse(_user.dateOfBirth.split("-")[0]),
        int.parse(_user.dateOfBirth.split("-")[1]),
        int.parse(_user.dateOfBirth.split("-")[2]));
  }

  String dob;
  bool _checkPasswordChange = false;
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final MaskedTextController _phoneController =
      MaskedTextController(mask: '000 000 00 00');
  final _fnameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _passController = TextEditingController();
  final _passCheckController = TextEditingController();
  String fnameValidation(String fullname) {
    if (fullname.length < 2) {
      return "Isim kismi bos birakilamaz.";
    } else
      return null;
  }

  String surnameValidation(String fullname) {
    if (fullname.length < 2) {
      return "Soyisim kismi bos birakilamaz.";
    } else
      return null;
  }

  String telephoneNumberValidation(String number) {
    bool numberValid = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
        .hasMatch(number);
    return numberValid ? null : "Lütfen geçerli bir telefon numarası giriniz.";
  }

  String emailValidation(String email) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid ? null : "Lütfen geçerli bir mail adresi giriniz.";
  }

  String passwrdValidation(String passwrd) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[.!@#\$&*~]).{8,24}$';
    RegExp regExp = new RegExp(pattern);
    return (!doppelValidation(_passController.text, _passCheckController.text))
        ? "password does not match"
        : regExp.hasMatch(passwrd) ? null : "Lütfen geçerli bir şifre giriniz.";
  }

  bool doppelValidation(String random, String random2) {
    if (random.compareTo(random2) == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            height: 50, child: Image.asset("images/logo_white/logo_white.png")),
      ),
      backgroundColor: Color.fromRGBO(230, 81, 0, 1),
      key: _scaffoldKey,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    InputField(
                      lines: 1,
                      controller: _fnameController,
                      inputType: TextInputType.text,
                      validation: fnameValidation,
                      labelText: "Name",
                      suffixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    InputField(
                      lines: 1,
                      controller: _surnameController,
                      inputType: TextInputType.text,
                      validation: surnameValidation,
                      labelText: "Surname",
                      suffixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    InputField(
                      lines: 1,
                      controller: _emailController,
                      inputType: TextInputType.emailAddress,
                      validation: emailValidation,
                      labelText: "Email",
                      suffixIcon: Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    InputField(
                      lines: 1,
                      controller: _phoneController,
                      inputType: TextInputType.phone,
                      validation: telephoneNumberValidation,
                      labelText: "Phone Number",
                      suffixIcon: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                          side: BorderSide(color: Colors.white)),
                      color: Colors.white,
                      child: Text(
                        "Change Password",
                        style: TextStyle(
                            color: Color.fromRGBO(230, 81, 0, 1),
                            fontSize: 20.0),
                      ),
                      onPressed: () {
                        _checkPasswordChange = false;
                        _passController.text = "";
                        _passCheckController.text = "";

                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Theme.of(context).primaryColor,
                                content: StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return SafeArea(
                                      child: Form(
                                    key: _passwordFormKey,
                                    child: Container(
                                      width: 300,
                                      height: 350,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 12.0),
                                          InputField(
                                            lines: 1,
                                            controller: _passController,
                                            inputType:
                                                TextInputType.visiblePassword,
                                            validation: passwrdValidation,
                                            labelText: "Password",
                                            isPassword: true,
                                            suffixIcon: Icon(
                                              Icons.lock,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 12.0),
                                          InputField(
                                            lines: 1,
                                            controller: _passCheckController,
                                            inputType:
                                                TextInputType.visiblePassword,
                                            validation: passwrdValidation,
                                            isPassword: true,
                                            labelText: "Validate Password",
                                            suffixIcon: Icon(
                                              Icons.verified_user,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                                child: Text(
                                                  "Change",
                                                  style: TextStyle(
                                                      color: Color(0xffe65100),
                                                      fontSize: 20),
                                                ),
                                                onPressed: () {
                                                  if (_passwordFormKey
                                                      .currentState
                                                      .validate()) {
                                                    setState(() {
                                                      _checkPasswordChange =
                                                          true;
                                                    });
                                                    Navigator.pop(context);
                                                  } else {
                                                    setState(() {
                                                      _checkPasswordChange =
                                                          true;
                                                    });
                                                  }
                                                },
                                              ),
                                              SizedBox(width: 20.0),
                                              FlatButton(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Color(0xffe65100),
                                                      fontSize: 20),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                                }),
                                title: Text(
                                  "Change Password",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            });
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                          side: BorderSide(color: Colors.white)),
                      color: Colors.white,
                      child: Text(
                        dob,
                        style: TextStyle(
                            color: Color.fromRGBO(230, 81, 0, 1),
                            fontSize: 20.0),
                      ),
                      onPressed: () {
                        selectDate(context);
                      },
                    ),
                    SizedBox(height: 8.0),
                    Container(
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                              side: BorderSide(color: Colors.white)),
                          color: Colors.white,
                          child: Text(
                            (_user.role == "ROLE_USER")
                                ? "Be Seller"
                                : "Change Seller Address",
                            style: TextStyle(
                                color: Color.fromRGBO(230, 81, 0, 1),
                                fontSize: 20.0),
                          ),
                          onPressed: () {
                            if (_user.role != "ROLE_USER") {
                              Address sellerAddress;
                              userService.getSellerAddress().then((value) {
                                if (!value.error) {
                                  sellerAddress = value.data;
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          content: AddAddress(
                                            addType: 2,
                                            addressID: sellerAddress.addressID,
                                            addressLine:
                                                sellerAddress.addressLine,
                                            addressName:
                                                sellerAddress.addressName,
                                            city: sellerAddress.city,
                                            country: sellerAddress.country,
                                            postalCode:
                                                sellerAddress.postalCode,
                                          )));
                                }else{
                                  ErrorDialog().showErrorDialog(context, "Error!", value.errorMessage);
                                }
                              });
                            }
                            else{
                              showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          content: AddAddress(
                                            addType: 1
                                          )));
                            }
                          },
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                              side: BorderSide(color: Colors.white)),
                          color: Colors.white,
                          child: Text(
                            "Save",
                            style: TextStyle(
                                color: Color.fromRGBO(230, 81, 0, 1),
                                fontSize: 20.0),
                          ),
                          onPressed: () {
                            CircularProgressIndicator();
                            User newuser = new User();
                            if (doppelValidation(_passController.value.text,
                                _passCheckController.value.text)) {
                              if (_formKey.currentState.validate()) {
                                newuser.name = _fnameController.value.text;
                                newuser.surname = _surnameController.value.text;
                                if (_checkPasswordChange) {
                                  newuser.password = _passController.value.text;
                                  print(newuser.password);
                                  print(_checkPasswordChange);
                                }
                                newuser.role = _user.role;
                                newuser.email = _emailController.value.text;
                                newuser.phoneNumber =
                                    _phoneController.value.text;
                                if (dob.compareTo(
                                        "Please Select Your Birthday") !=
                                    0) {
                                  String _date =
                                      dob.split("/").reversed.join("-");
                                  newuser.dateOfBirth = _date;
                                  newuser.userID = _user.userID;
                                  userService
                                      .updateUser(newuser, _checkPasswordChange)
                                      .then((value) {
                                    userService.initUser().then((value) {
                                      setState(() {
                                        _user = userService.getUser();
                                      });
                                    });
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      duration: Duration(seconds: 1),
                                      backgroundColor: Colors.white,
                                      content: Text(
                                        "SAVED",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(230, 81, 0, 1),
                                            fontSize: 18),
                                      ),
                                    ));
                                  });
                                } else {
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    duration: Duration(seconds: 1),
                                    backgroundColor: Colors.white,
                                    content: Text(
                                      "Please Select Your Birthday",
                                      style: TextStyle(
                                          color: Color.fromRGBO(230, 81, 0, 1),
                                          fontSize: 18),
                                    ),
                                  ));
                                }
                              }
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                duration: Duration(seconds: 1),
                                backgroundColor: Colors.white,
                                content: Text(
                                  "Passwords Not Matching.",
                                  style: TextStyle(
                                      color: Color.fromRGBO(230, 81, 0, 1),
                                      fontSize: 18),
                                ),
                              ));
                            }
                          },
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
