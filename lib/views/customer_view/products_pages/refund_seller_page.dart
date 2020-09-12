import 'package:Selfsahaf/controller/order_service.dart';
import 'package:Selfsahaf/models/order.dart';
import 'package:Selfsahaf/models/refund_model.dart';
import 'package:Selfsahaf/views/customer_view/products_pages/refund_seller_detail_page.dart';
import 'package:Selfsahaf/views/customer_view/shopping_cart/shopping_cart.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RefundRequest extends StatefulWidget {
  @override
  _RefundRequestState createState() => _RefundRequestState();
}

class _RefundRequestState extends State<RefundRequest> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  OrderService get orderService => GetIt.I<OrderService>();
  List<RefundModel> refundList;
  bool _isloading = true;
  _fetchData() async {
    _refresh();
  }

  Future<Null> _refresh() {
    return orderService.getRefundRequestsForSeller().then((e) {
      if (!e.error) {
        setState(() {
          _isloading = false;
          this.refundList = e.data;
        });
      } else {
        setState(() {
          _isloading = false;
          this.refundList = e.data;
        });
        ErrorDialog().showErrorDialog(context, "Error!", e.errorMessage);
      }
    });
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
              height: 50,
              child: Image.asset("images/logo_white/logo_white.png")),
        ),
        body: RefreshIndicator(
            onRefresh: () => _refresh(),
            key: _refreshIndicatorKey,
            child: new ListView.builder(
                itemCount: (refundList == null) ? 1 : refundList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return (_isloading)
                      ? CircularProgressIndicator()
                      : (refundList == null)
                          ? Padding(
                              padding: const EdgeInsets.all(35.0),
                              child: Center(
                                  child: Text(
                                "No Books Refunded",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              )),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 11,
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        "RefundID: ",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        refundList[index]
                                                            .refundID
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        "Book's Name: ",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        refundList[index]
                                                            .order
                                                            .product
                                                            .name,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        "Author's Name: ",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        refundList[index]
                                                            .order
                                                            .product
                                                            .authorName,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        "Book Price: ",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        refundList[index]
                                                                .order
                                                                .product
                                                                .price
                                                                .toString() +
                                                            " TL",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        "Shipping Company: ",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        refundList[index]
                                                            .order
                                                            .shippingInfo
                                                            .shippingcompany
                                                            .companyName,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        "Shipping Company Price: ",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        refundList[index]
                                                                .order
                                                                .shippingInfo
                                                                .shippingcompany
                                                                .price
                                                                .toString() +
                                                            " TL",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        "Buyer Name: ",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        refundList[index]
                                                            .order
                                                            .buyer
                                                            .name,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        "Buyer Phone Number: ",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        refundList[index]
                                                            .order
                                                            .buyer
                                                            .phoneNumber,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        "Refund Status: ",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        refundList[index]
                                                            .status,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                               Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        "Order Status: ",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        refundList[index].order
                                                            .status,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        "Price: ",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        ((refundList[index]
                                                                            .order
                                                                            .price *
                                                                        refundList[index]
                                                                            .order
                                                                            .quantity) +
                                                                    refundList[
                                                                            index]
                                                                        .order
                                                                        .shippingInfo
                                                                        .shippingcompany
                                                                        .price)
                                                                .toString() +
                                                            " TL",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        "Amount: ",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 12,
                                                      child: Text(
                                                        refundList[index]
                                                            .order
                                                            .quantity
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,MaterialPageRoute(builder: (_)=>RefundDetailsPage(refundItem:refundList[index])));
                                            },
                                            child: Container(
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                })));
  }
}
