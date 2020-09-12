import 'package:flutter/material.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/models/user.dart';
import 'package:Selfsahaf/views/customer_view/main_view/main_page.dart';
import 'package:Selfsahaf/views/registration/input_field.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  AuthService api = new AuthService();
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
        print(dob);
      });
    }
  }

  var dob = "Please Select Your Birthday";

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final MaskedTextController _phoneController =
      MaskedTextController(mask: '000 000 00 00');
  final _fnameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _passController = TextEditingController();
  final _passCheckController = TextEditingController();
  bool _kvkk = false;

  String nameValidation(String firstname) {
    if (firstname.length < 2) {
      return "Name field cannot be empty";
    } else
      return null;
  }

  String surnameValidation(String surname) {
    if (surname.length < 2) {
      return "Lastname field cannot be empty";
    } else
      return null;
  }

  String telephoneNumberValidation(String number) {
    bool numberValid = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
        .hasMatch(number);
    return numberValid ? null : "Please enter valid phone number";
  }

  String emailValidation(String email) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid ? null : "Please enter valid email address";
  }

  String passwrdValidation(String passwrd) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[.!@#\$&*~]).{8,24}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(passwrd) ? null : "Password isn't valid";
  }

  bool doppelValidation(String random, String random2) {
    if (random.compareTo(random2) == 0) {
      return true;
    } else {
      return false;
    }
  }

  void _signup(data) async {
    var message = "";
    api.signup(data).then((val) {
      if (val.data == "200" || val.data == "302" || val.data == "Saved") {
        api
            .loginWithEmail(_emailController.text, _passController.text)
            .then((value) {
          if (!value.error) {
            api.initUser().then((value) {
              if (!value.error) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainPage(user: api.getUser())),
                    ModalRoute.withName("/Home"));
              } else {
                return ErrorDialog()
                    .showErrorDialog(context, "Error!", value.errorMessage);
              }
            });
          }
          else {
                return ErrorDialog()
                    .showErrorDialog(context, "Error!", value.errorMessage);
              }
        });
      } else {
        print("sasa" + val.data);
        message = "This e-mail is linked to different account";
        return ErrorDialog().showErrorDialog(context, "Error!", message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 13.0, right: 13.0),
                      child: Container(
                          child: Image.asset(
                            "images/logo_white/logo_white.png",
                            fit: BoxFit.contain,
                          ),
                          height: 100.0,
                          width: 100.0),
                    ),
                    SizedBox(height: 20.0),
                    InputField(
                      lines: 1,
                      controller: _fnameController,
                      inputType: TextInputType.text,
                      validation: nameValidation,
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
                    SizedBox(height: 12.0),
                    InputField(
                      lines: 1,
                      controller: _passController,
                      inputType: TextInputType.visiblePassword,
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
                      inputType: TextInputType.visiblePassword,
                      validation: passwrdValidation,
                      isPassword: true,
                      labelText: "Validate Password",
                      suffixIcon: Icon(
                        Icons.verified_user,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 12,
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
                    SizedBox(height: 10.0),
                    Row(children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Checkbox(
                          activeColor: Colors.white,
                          checkColor: Colors.white,
                          onChanged: (bool value) {
                            setState(() => this._kvkk = value);
                          },
                          value: this._kvkk,
                        ),
                      ),
                      Expanded(
                        flex: 18,
                        child: Text(
                          "I accept terms including my information according to this app.",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ]),
                    SizedBox(height: 12.0),
                    Container(
                        width: 50.0,
                        height: 50.0,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                              side: BorderSide(color: Colors.white)),
                          color: Colors.white,
                          child: Text(
                            "Signup",
                            style: TextStyle(
                                color: Color.fromRGBO(230, 81, 0, 1),
                                fontSize: 20.0),
                          ),
                          onPressed: () {
                            CircularProgressIndicator();
                            User newuser = new User();

                            if (doppelValidation(_passController.value.text,
                                    _passCheckController.value.text) &&
                                _kvkk) {
                              if (_formKey.currentState.validate()) {
                                newuser.name = _fnameController.value.text;
                                newuser.surname = _surnameController.value.text;
                                newuser.password = _passController.value.text;
                                newuser.email = _emailController.value.text;
                                newuser.phoneNumber =
                                    _phoneController.value.text;
                                if (dob.compareTo(
                                        "Please Select Your Birthday") !=
                                    0) {
                                  String _date =
                                      dob.split("/").reversed.join("-");

                                  newuser.dateOfBirth = _date;

                                  var userjson = newuser.toJsonsignup();
                                  _signup(userjson);
                                } else {
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
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
                            } else if (!_kvkk) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.white,
                                content: Text(
                                  "Please Accept Terms",
                                  style: TextStyle(
                                      color: Color.fromRGBO(230, 81, 0, 1),
                                      fontSize: 18),
                                ),
                                duration: Duration(seconds: 2),
                              ));
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
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
                    SizedBox(height: 30.0),
                    Center(
                        child: GestureDetector(
                            child: Text("Already Have an Account? Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            })),
                    SizedBox(
                      height: 30,
                    )
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
