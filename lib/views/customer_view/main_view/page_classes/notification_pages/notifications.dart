import 'package:Selfsahaf/views/customer_view/main_view/page_classes/main_page/sahaf_drawer.dart';
import 'package:Selfsahaf/views/customer_view/main_view/page_classes/notification_pages/notification_best_selling_books.dart';
import 'package:Selfsahaf/views/customer_view/main_view/page_classes/notification_pages/notification_top_sellers.dart';
import 'package:flutter/material.dart';
import 'package:Selfsahaf/views/customer_view/shopping_cart/shopping_cart.dart';

class NotificationsPage extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _NotificationsPageState createState() => new _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>{
  
  var controller = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SahafDrawer(),
      appBar: AppBar(
          title: Container(
              height: 50,
              child: Image.asset("images/logo_white/logo_white.png")),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShoppingCart()),
                  );
                }),
          ],
        ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 15,),
            Container(child: Text(
              "Best of the Best",style: TextStyle(color: Colors.white,fontSize: 25),
            ),),
            Divider(thickness: 2,color: Colors.white,),
            Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(20, 5, 50, 5),
                        child: Text(
                          "Sellers",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.fromLTRB(50, 5, 20, 5),
                        child: Text(
                          "Books",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textDirection: TextDirection.ltr,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: PageView(
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[NotificationTopSellers(), NotificationBestBooks()],
                    ),
                  )
          ],
        ),
      ),
    );
  }
  
}