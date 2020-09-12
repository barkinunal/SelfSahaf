import 'package:Selfsahaf/views/registration/login.dart';
import 'package:flutter/material.dart';

class ErrorDialog {
  void showErrorDialog(BuildContext context, errorTitle, errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: Color(0xffe65100),
            title: Text(
              errorTitle,
              style: TextStyle(color: Colors.white),
            ),
            content: Text(errorMessage, style: TextStyle(color: Colors.white)),
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
  }

  void showLogin(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: Color(0xffe65100),
            title: Text(
              "Please Login!",
              style: TextStyle(color: Colors.white),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Container(
                width: 220,
                height: 45,
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                      side: BorderSide(color: Color.fromRGBO(230, 81, 0, 1))),
                  color: Colors.white,
                  onPressed: () async {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        ModalRoute.withName("/Login"));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Color.fromRGBO(230, 81, 0, 1), fontSize: 20),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  "Cancel",
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
  }
}
