import 'package:Selfsahaf/views/admin_view/admin_main_page.dart';
import 'package:Selfsahaf/views/customer_view/orders_page/taken_orders.dart';
import 'package:Selfsahaf/views/customer_view/products_pages/refund_seller_page.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:Selfsahaf/views/registration/login.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/views/customer_view/products_pages/productsDialog.dart';
import 'package:Selfsahaf/views/customer_view/products_pages/products_page.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/settings_page.dart';

class SahafDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SahafDrawer();
  }
}

class _SahafDrawer extends State<SahafDrawer> {
  AuthService userService = GetIt.I<AuthService>();
  bool seller = false;
  int role; //0 for anon
  //1 for user
  //2 for seller
  //3 for admin
  @override
  void initState() {
    switch (userService.getUser().role) {
      case "ROLE_ADMIN":
        role = 3;
        break;
      case "ROLE_SELLER":
        role = 2;
        break;
      case "ROLE_USER":
        role = 1;
        break;
      case "ROLE_ANON":
        role = 0;
        break;
      default:
    }
    if (role == 3 || role == 2)
      setState(() {
        seller = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 100.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(192, 72, 46, 1),
        ),
        child: ListView(
          children: <Widget>[
            Container(
              height: 200,
              child: DrawerHeader(
                padding: EdgeInsets.only(top: 0, bottom: 0),
                margin: EdgeInsets.only(left: 8, top: 0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child:
                              Image.asset('images/logo_white/logo_white.png'),
                          height: 150,
                          width: 200),
                      Text(
                          userService.getUser().name +
                              " " +
                              userService.getUser().surname,
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .copyWith(fontSize: 24)),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.white60,
            ),
        
            InkWell(
              child: ListTile(
                  leading: Icon(
                    Icons.attach_money,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Products",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
              onTap: () {
                (role == 0)
                    ? ErrorDialog().showLogin(context)
                    : (seller)
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductsPage()))
                        : showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ProductsDialog();
                            });
              },
            ),
            (!seller)
                ? Container()
                : InkWell(
                    child: ListTile(
                        leading: Icon(
                          Icons.swap_horizontal_circle,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Taken Orders",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                    onTap: () {
                      (role == 0)
                          ? ErrorDialog().showLogin(context)
                          : (seller)
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TakenOrders()))
                              : showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ProductsDialog();
                                  });
                    },
                  ),
            (!seller)
                ? Container()
                : InkWell(
                    child: ListTile(
                        leading: Icon(
                          Icons.record_voice_over,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Refund Orders",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                    onTap: () {
                      (role == 0)
                          ? ErrorDialog().showLogin(context)
                          : (seller)
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RefundRequest()))
                              : showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ProductsDialog();
                                  });
                    },
                  ),
            InkWell(
              child: ListTile(
                  leading: Icon(Icons.settings, color: Colors.white),
                  title: Text(
                    "Settings",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
              onTap: () {
                if (role == 0) {
                  ErrorDialog().showLogin(context);
                } else
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
            (role == 0)
                ? InkWell(
                    child: ListTile(
                        leading: Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Login",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          ModalRoute.withName("/Login"));
                    })
                : InkWell(
                    child: ListTile(
                        leading: Icon(
                          Icons.error_outline,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Logout",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          ModalRoute.withName("/Login"));
                    }),
            (role == 3)
                ? InkWell(
                    child: ListTile(
                        leading: Icon(
                          Icons.adb,
                          color: Colors.white,
                        ),
                        title: Text(
                          "AdminPanel",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminMainPage()),
                          ModalRoute.withName("/AdminPanel"));
                    })
                : Container(),
          ],
        ),
      ),
    );
  }
}
