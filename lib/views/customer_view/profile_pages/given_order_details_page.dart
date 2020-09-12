import 'package:Selfsahaf/controller/order_service.dart';
import 'package:Selfsahaf/models/order.dart';
import 'package:Selfsahaf/views/customer_view/products_pages/bought_book_profile.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/views/customer_view/products_pages/product_card.dart';

class GivenOrderDetails extends StatefulWidget {
  final int id;
  GivenOrderDetails({this.id});

  @override
  _GivenOrderDetailsState createState() => _GivenOrderDetailsState();
}

class _GivenOrderDetailsState extends State<GivenOrderDetails> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  OrderService get _orderService => GetIt.I<OrderService>();
  List<Order> orderList;
  bool _isloading = true;

  @override
  void initState() {
    print("sa" + widget.id.toString());
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  Future<Null> _refresh() {
    return _orderService.givenOrderDetails(widget.id).then((e) {
      print(e.data);
      if (!e.error) {
        setState(() {
          _isloading = false;
          this.orderList = e.data;
        });
      } else {
        setState(() {
          _isloading = false;
          this.orderList = e.data;
        });
        ErrorDialog().showErrorDialog(context, "Error", e.errorMessage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 13,
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
              height: 50,
              child: Image.asset("images/logo_white/logo_white.png")),
        ),
        body: Container(
            color: Color(0xffe65100),
            padding: const EdgeInsets.all(16.0),
            child: RefreshIndicator(
              onRefresh: () => _refresh(),
              key: _refreshIndicatorKey,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  if (_isloading) {
                    return CircularProgressIndicator();
                  }
                  if (orderList == null) {
                    return Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: Center(
                          child: Text(
                        "No Books on Sale",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      )),
                    );
                  } else {
                    return Dismissible(
                      key: ValueKey(orderList[index].product.productID),
                      child: ProductCard(
                        bookName: orderList[index].product.name,
                        authorName: orderList[index].product.authorName,
                        publisherName: orderList[index].product.publisher,
                        price: orderList[index].product.price,
                        productID: orderList[index].product.productID,
                        sellerID: orderList[index].product.sellerID,
                        type: 0,
                        discount: orderList[index].product.discount,
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        print("sa");
                      },
                      confirmDismiss: (direction) async {
                        //right to left for information
                        if (direction == DismissDirection.endToStart) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BoughtBookProfile(
                                        selectedBook: orderList[index],
                                        amount: orderList[index].quantity,
                                      )));

                          return false;
                        }
                      },
                      //sağdan sola
                      secondaryBackground: Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.all(8),
                          child: Align(
                              child: Icon(Icons.edit,
                                  color: Colors.white, size: 50),
                              alignment: Alignment.centerRight),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                      //soldan sağa
                      background: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.only(left: 16),
                        child: Align(
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 50,
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    );
                  }
                },
                itemCount: (orderList == null) ? 1 : orderList.length,
              ),
            )));
  }
}
