import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/views/admin_view/admin_send_mail.dart';
import 'package:Selfsahaf/views/customer_view/main_view/main_page.dart';
import 'package:flutter/material.dart';
import 'package:Selfsahaf/views/admin_view/admin_search.dart';
import 'package:Selfsahaf/views/admin_view/admin_shipping_companies.dart';
import 'package:Selfsahaf/views/admin_view/edit_categories.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/views/admin_view/refund_admin_page.dart';
class AdminDrawer extends StatelessWidget {
  AuthService get userService=>GetIt.I<AuthService>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 100.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(192, 72, 46, 1),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.only(top:36.0),
                child: Container(
                  height: 100,
                  padding: EdgeInsets.only(top: 10, bottom: 0),
                  margin: EdgeInsets.only(left: 50, top: 0, right: 50),
                  child: Center(
                    child: Image.asset('images/selfadmin_logo/selfadmin.png'),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: InkWell(
                
                child: ListTile(
                    leading: Icon(Icons.search, color: Colors.white),
                    title: Text(
                      "Search Users",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminSearch()),
                  );
                },
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              flex: 5,
              child: InkWell(
                child: ListTile(
                    leading: Icon(
                      Icons.local_shipping,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Shipping Companies",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShippingCompanies()),
                  );
                },
              ),
            ),
           
            Expanded(
              flex: 5,
              child: InkWell(
                child: ListTile(
                    leading: Icon(Icons.edit, color: Colors.white),
                    title: Text(
                      "Edit Categories",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditCategories()),
                  );
                },
              ),
            ),
            Expanded(
              flex: 5,
              child: InkWell(
                child: ListTile(
                    leading: Icon(Icons.mail, color: Colors.white),
                    title: Text(
                      "Inform Everyone",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                onTap: () {
                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminMailPage(
                            user: userService.getUser(),
                            everyone: true,
                          )));
          
                },
              ),
            ),
               InkWell(
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
                      Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RefundRequestForAdmin()));
                             
                    },
                  ),
             Expanded(
              flex: 3,
              child: InkWell(
                child: ListTile(
                    leading: Icon(Icons.directions_run, color: Colors.white),
                    title: Text(
                      "Go App",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                onTap: () {
                Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage(
                            user: userService.getUser(),
                          )),
                          ModalRoute.withName("/Home"));
                },
              ),
            ),
            
            Expanded(
              flex: 25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
