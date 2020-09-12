import 'package:Selfsahaf/controller/product_services.dart';
import 'package:Selfsahaf/models/book.dart';
import 'package:Selfsahaf/views/customer_view/products_pages/book_profile.dart';
import 'package:Selfsahaf/views/customer_view/products_pages/product_card.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NotificationBestBooks extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _NotificationBestBooks createState() => new _NotificationBestBooks();
}

class _NotificationBestBooks extends State<NotificationBestBooks> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  ProductService _productService = GetIt.I<ProductService>();
  List<Book> bestBooks;
  @override
  void initState() {
    _getTopBooks(context);
    super.initState();
  }

  _getTopBooks(BuildContext context) async {
    _productService.getTopBooks(0, 10).then((value) {
      print(value.data.length);
      if (!value.error) {
        setState(() {
          this.bestBooks = value.data;
        });
      } else {
        ErrorDialog().showErrorDialog(context, "Error", value.errorMessage);
        setState(() {
          this.bestBooks = value.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () => _getTopBooks(context),
            key: _refreshIndicatorKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {
                      return (bestBooks == null)
                          ? Center(
                              child: Text(
                                "No Books",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookProfile(
                                            selectedBook: bestBooks[index],
                                            type: 1,
                                          )),
                                );
                              },
                              child: ProductCard(
                                  authorName: bestBooks[index].authorName,
                                  bookName: bestBooks[index].name,
                                  price: bestBooks[index].price,
                                  productID: bestBooks[index].productID,
                                  sellerID: bestBooks[index].sellerID,
                                  publisherName: bestBooks[index].publisher,
                                  discount: bestBooks[index].discount,
                                  type: 1),
                            );
                    },
                    itemCount: (bestBooks == null) ? 1 : bestBooks.length,
                  ),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
            )));
  }
}
