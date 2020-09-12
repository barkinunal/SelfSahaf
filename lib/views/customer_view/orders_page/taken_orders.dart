import 'package:Selfsahaf/controller/order_service.dart';
import 'package:Selfsahaf/models/order.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TakenOrders extends StatefulWidget {
  @override
  _TakenOrdersState createState() => _TakenOrdersState();
}

class _TakenOrdersState extends State<TakenOrders> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  OrderService get orderService => GetIt.I<OrderService>();
  List<Order> allorders;
  bool _isloading = true;
  List<String> allStatus = ["CONFIRMED", "SHIPPING", "DELIVERED"];
  _fetchData() async {
    _refresh();
  }

  _markDialog(BuildContext context, Order order) {
    List<String> status;
    String markedAs;
    bool error = false;
    String errorMessage;
    String orderStatus = order.status;
    if (order.status == "CONFIRMED")
      status = ["SHIPPING", "DELIVERED"];
    else if (order.status == "SHIPPING")
      status = ["DELIVERED"];
    else if (order.status == "CANCELLED")
      status = ["CANCELLED"];
    else if (order.status == "DELIVERED")
      status = ["DELIVERED"];
    else if (order.status == "REFUNDREQUEST")
      status = ["REFUNDREQUEST"];
    else if (order.status == "REFUNDED")
      status = ["REFUNDED"];
    else if (order.status == "BLOCKED")
      status = ["BLOCKED"];
    else {
      status = ["CONFIRMED", "SHIPPING", "DELIVERED"];
      orderStatus = "Select Status";
    }

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title:
                Text("Mark Order As:", style: TextStyle(color: Colors.white)),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton<String>(
                    hint: Text(
                      orderStatus,
                      style: TextStyle(color: Colors.white),
                    ),
                    items: status.map((String dropdownItem) {
                      return DropdownMenuItem<String>(
                        value: dropdownItem,
                        child: Text(
                          dropdownItem,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      setState(() {
                        markedAs = newValueSelected;
                      });
                    },
                    value: markedAs,
                  ),
                  (error)
                      ? Text(
                          errorMessage,
                          style: TextStyle(color: Colors.white),
                        )
                      : Container(),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 6,
                            child: SizedBox(
                              width: 50,
                            )),
                        Expanded(
                          flex: 4,
                          child: FlatButton(
                            onPressed: () {
                              if (markedAs == null) {
                                setState(() {
                                  error = true;
                                  errorMessage = "Please select a status";
                                });

                                print("please mark order.");
                              } else {
                                print(markedAs);
                                orderService
                                    .markOrder(order.orderDetailID,
                                        markedAs)
                                    .then((value) {
                                  if (!value.error) {
                                    _refresh();
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {
                                      error = true;
                                      errorMessage = value.errorMessage;
                                    });

                                    print(value.errorMessage);
                                  }
                                });
                              }
                            },
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              "Apply",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: 20,
                            )),
                        Expanded(
                          flex: 5,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }),
          );
        });
  }

  Future<Null> _refresh() {
    return orderService.getTakenOrders().then((e) {
      if (!e.error) {
        setState(() {
          _isloading = false;
          this.allorders = e.data;
        });
      } else {
        setState(() {
          _isloading = false;
          this.allorders = e.data;
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
                itemCount: (allorders == null) ? 1 : allorders.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return (_isloading)
                      ? CircularProgressIndicator()
                      : (allorders == null)
                          ? Padding(
                              padding: const EdgeInsets.all(35.0),
                              child: Center(
                                  child: Text(
                                "No Books Waiting For Acceptance",
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
                                                        "OrderID: ",
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
                                                        allorders[index]
                                                            .orderDetailID
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
                                                        allorders[index]
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
                                                        allorders[index]
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
                                                        allorders[index]
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
                                                        allorders[index]
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
                                                        allorders[index]
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
                                                        allorders[index]
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
                                                        allorders[index]
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
                                                        "Status: ",
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
                                                        allorders[index].status,
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
                                                        ((allorders[index].price *
                                                                        allorders[index]
                                                                            .quantity) +
                                                                    allorders[
                                                                            index]
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
                                                        allorders[index]
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
                                              _markDialog(
                                                  context, allorders[index]);
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
