import 'package:Selfsahaf/models/user.dart';
import 'package:Selfsahaf/views/admin_view/admin_send_mail.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/seller_profile.dart';
import 'package:flutter/material.dart';

class UserCardForAdmin extends StatefulWidget {
  final User user;
  UserCardForAdmin({@required this.user});
  @override
  _UserCardForAdminState createState() => _UserCardForAdminState();
}

class _UserCardForAdminState extends State<UserCardForAdmin> {
  User user;
  bool _isSeller = true;
  @override
  void initState() {
    this.user = widget.user;
    super.initState();
    if (widget.user.role == "ROLE_USER") {
      _isSeller = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_isSeller)
        ? Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 5),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Element("Customer Name: ",
                        widget.user.name + "  " + widget.user.surname),
                    Divider(
                      color: Colors.white,
                      thickness: 1.5,
                    ),
                    Element("E-Mail: ", widget.user.email),
                    Divider(
                      color: Colors.white,
                      thickness: 1.5,
                    ),
                    Element("Customer phone number: ", widget.user.phoneNumber),
                    Divider(
                      color: Colors.white,
                      thickness: 1.5,
                    ),
                    Element("Is Seller: ", (!_isSeller) ? "No" : "Yes"),
                    Divider(
                      color: Colors.white,
                      thickness: 1.5,
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12.0),
                            side: BorderSide(color: Colors.white)),
                        color: Colors.white,
                        child: Text(
                          "Seller Profile",
                          style: TextStyle(
                              color: Color.fromRGBO(230, 81, 0, 1),
                              fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SellerProfilePage(
                                        type: 1,
                                        user: widget.user,
                                      )));
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12.0),
                            side: BorderSide(color: Colors.white)),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.mail,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Send Mail",
                              style: TextStyle(
                                  color: Color.fromRGBO(230, 81, 0, 1),
                                  fontSize: 20.0),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminMailPage(
                                      user: this.user,
                                      everyone: false,
                                    )),
                          );
                        },
                      ),
                    ),

                    // Element(""),
                  ],
                ),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 5),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Element("Customer Name: ",
                        widget.user.name + "  " + widget.user.surname),
                    Divider(
                      color: Colors.white,
                      thickness: 1.5,
                    ),
                    Element("E-Mail: ", widget.user.email),
                    Divider(
                      color: Colors.white,
                      thickness: 1.5,
                    ),
                    Element("Customer phone number: ", widget.user.phoneNumber),
                    Divider(
                      color: Colors.white,
                      thickness: 1.5,
                    ),
                    Element("Is Seller: ", (!_isSeller) ? "No" : "Yes"),
                    Divider(
                      color: Colors.white,
                      thickness: 1.5,
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12.0),
                            side: BorderSide(color: Colors.white)),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.mail,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Send Mail",
                              style: TextStyle(
                                  color: Color.fromRGBO(230, 81, 0, 1),
                                  fontSize: 20.0),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminMailPage(
                                      user: this.user,
                                      everyone: false,
                                    )),
                          );
                        },
                      ),
                    ),

                    // Element(""),
                  ],
                ),
              ),
            ),
          );
  }
}

class Element extends StatelessWidget {
  final String title;
  final String content;
  Element(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Text(
              this.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              this.content,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
