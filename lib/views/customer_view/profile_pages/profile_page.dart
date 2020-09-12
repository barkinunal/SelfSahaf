import 'package:Selfsahaf/views/customer_view/main_view/page_classes/main_page/sahaf_drawer.dart';
import 'package:Selfsahaf/views/registration/login.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/adress_page.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/history_page.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/settings_page.dart';

class ProfilePage extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _ProfilePage createState() => new _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  AuthService userService = GetIt.I<AuthService>();
  String _name;
  @override
  void initState() {
    _name = userService.getUser().name + " " + userService.getUser().surname;
  }

  List<Widget> _pages = [AdressesPage(), HistoryPage()];
  var controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
            height: 50, child: Image.asset("images/logo_white/logo_white.png")),
        actions: <Widget>[
          (userService.getUser().role == "ROLE_ANON")?Text(""):
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              })
        ],
      ),
      drawer: SahafDrawer(),
      body: (userService.getUser().role == "ROLE_ANON")
          ? Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Padding(
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
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
                ),
              ),
            )
          : Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                children: <Widget>[
                  Container(
                      child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.perm_identity,
                            color: Color(0xffe65100),
                            size: 128,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        width: 150,
                        height: 50,
                        margin: EdgeInsets.fromLTRB(20, 20, 20, 100),
                        child: Center(
                          child: Text(
                            _name,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      )),
                    ],
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(20, 5, 50, 5),
                        child: Text(
                          "History",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.fromLTRB(50, 5, 20, 5),
                        child: Text(
                          "Adresses",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textDirection: TextDirection.ltr,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.white60,
                  ),
                  Expanded(
                    child: PageView(
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[HistoryPage(), AdressesPage()],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
