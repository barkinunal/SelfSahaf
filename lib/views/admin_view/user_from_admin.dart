import 'package:Selfsahaf/views/admin_view/admin_list_view.dart';
import 'package:flutter/material.dart';

class UserProfileFromAdmin extends StatefulWidget {
  @override
  _UserProfileFromAdminState createState() => _UserProfileFromAdminState();
}

class _UserProfileFromAdminState extends State<UserProfileFromAdmin> {
  bool _isSeller = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            height: 22,
            child: Image.asset("images/selfadmin_logo/selfadmin.png"),
          ),
          leading: InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: (_isSeller)
            ? Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Element("Customer Name: ", "Alios kocaman"),
                        Divider(
                          color: Colors.white,
                          thickness: 1.5,
                        ),
                        Element("E-Mail: ", "alioskocaman@mail.com"),
                        Divider(
                          color: Colors.white,
                          thickness: 1.5,
                        ),
                        Element("Customer phone number: ", "+905415993527"),
                        Divider(
                          color: Colors.white,
                          thickness: 1.5,
                        ),
                        Element("Is Seller: ", "True"),
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
                              "Seller's Products",
                              style: TextStyle(
                                  color: Color.fromRGBO(230, 81, 0, 1),
                                  fontSize: 20.0),
                            ),
                            onPressed: () {
                              Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AdminListView()),
  );
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
                            child: Text(
                              "Buy History",
                              style: TextStyle(
                                  color: Color.fromRGBO(230, 81, 0, 1),
                                  fontSize: 20.0),
                            ),
                            onPressed: () {
                              print("seller products");
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
                            child: Text(
                              "Sell History",
                              style: TextStyle(
                                  color: Color.fromRGBO(230, 81, 0, 1),
                                  fontSize: 20.0),
                            ),
                            onPressed: () {
                              print("seller products");
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
                                Icon(Icons.mail,color: Theme.of(context).primaryColor,),
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
                              print("seller products");
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Divider(
                          thickness: 1.5,
                          color: Colors.white,
                        ),
                        Container(
                          height: 40,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "Customer Name: ",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "alios kocaman",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1.5,
                          color: Colors.white,
                        ),
                        Container(
                          height: 40,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "Customer Name: ",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "alios kocaman",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1.5,
                          color: Colors.white,
                        ),
                        Container(
                          height: 40,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "Customer Name: ",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "alios kocaman",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1.5,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ));
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
