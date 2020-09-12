import 'package:Selfsahaf/models/user.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/views/customer_view/main_view/main_page.dart';
import 'input_field.dart';
import 'package:Selfsahaf/views/registration/signup.dart';
import 'package:Selfsahaf/views/registration/input_field.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthService api = new AuthService();

  void _login() async {
    api
        .loginWithEmail(_emailController.text, _passwordController.text)
        .then((val) {
      if (!val.error) {
        api.initUser().then((value) {
          if (!value.error) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPage(
                          user: api.getUser(),
                        )),
                ModalRoute.withName("/Home"));
          }
        });
      } else if (val.data == 404)
        return ErrorDialog()
            .showErrorDialog(context, "Error!", "Server does not found");
      else {
        print(val.data);
        return ErrorDialog()
            .showErrorDialog(context, "Error!", val.errorMessage);
      }
    });
  }

  String emailValidation(String email) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.]+@([a-zA-Z0-9]+(\.))[a-zA-Z.]+").hasMatch(email);
    return emailValid ? null : 'not valid email.';
  }

  String passwrdValidation(String passwrd) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[.!@#\$&*~]).{8,24}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(passwrd) ? null : """Password must include at least
    1 uppercase letter,
    1 lowercase letter,
    1 number and 1 sign.
    Password length must be between 8 and 24""";
  }

  String message(statusCode) {
    if (statusCode == 401) {
      return "Girdiğiniz E-mail veya Şifre Hatalıdır";
    } else {
      return "Bağlantı Hatası\nlütfen daha sonra tekrar deneyiniz.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(230, 81, 0, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                    ),
                  ),
                  Container(
                    height: 150,
                    child: Image.asset("images/logo_white/logo_white.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: InputField(
                      lines: 1,
                      controller: _emailController,
                      inputType: TextInputType.emailAddress,
                      labelText: "Email",
                      suffixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      validation: emailValidation,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: InputField(
                      lines: 1,
                      validation: passwrdValidation,
                      isPassword: true,
                      controller: _passwordController,
                      inputType: TextInputType.emailAddress,
                      labelText: "Password",
                      suffixIcon: Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Container(
                      width: 220,
                      height: 45,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            side: BorderSide(
                                color: Color.fromRGBO(230, 81, 0, 1))),
                        color: Colors.white,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _login();
                          } 
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Color.fromRGBO(230, 81, 0, 1),
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      width: 220,
                      height: 45,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            side: BorderSide(
                                color: Color.fromRGBO(230, 81, 0, 1))),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
                        },
                        child: Text(
                          "Signup",
                          style: TextStyle(
                              color: Color.fromRGBO(230, 81, 0, 1),
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      width: 250,
                      height: 45,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            side: BorderSide(
                                color: Color.fromRGBO(230, 81, 0, 1))),
                        color: Colors.white,
                        onPressed: () async {
                          User newuser = new User(
                              name: "Anonim",
                              surname: "Sahaf",
                              role: "ROLE_ANON");
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage(
                                        user: newuser,
                                      )),
                              ModalRoute.withName("/Home"));
                        },
                        child: Text(
                          "I have a friend inside!",
                          style: TextStyle(
                              color: Color.fromRGBO(230, 81, 0, 1),
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
