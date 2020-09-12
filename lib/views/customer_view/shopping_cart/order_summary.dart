import 'package:Selfsahaf/controller/order_service.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/models/address.dart';
import 'package:Selfsahaf/models/shipping_company_model.dart';
import 'package:Selfsahaf/views/customer_view/main_view/main_page.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Selfsahaf/models/card_model.dart';
import 'package:get_it/get_it.dart';

class OrderSummary extends StatefulWidget {
  final Address address;
  final double totalPrice;
  final ShippingCompanyModel company;
  final CardModel myCard;
  OrderSummary(
      {@required this.address,
      @required this.totalPrice,
      @required this.company,
      @required this.myCard});
  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  double totalPrice;
  ShippingCompanyModel company;
  CardModel myCard;
  Address address;
  @override
  void initState() {
    super.initState();
    this.address = widget.address;
    this.totalPrice = widget.totalPrice;
    this.company = widget.company;
    this.myCard = widget.myCard;
  }

  OrderService get orderService => GetIt.I<OrderService>();
  AuthService get userService => GetIt.I<AuthService>();
  @override
  Widget build(BuildContext widget) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            height: 50, child: Image.asset("images/logo_white/logo_white.png")),
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
      floatingActionButton: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 32,
            height: 60,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Color.fromRGBO(230, 81, 0, 1))),
              color: Colors.white,
              onPressed: () async {
                orderService
                    .confirmOrder(
                        address.addressID, company.shippingCompanyID, myCard)
                    .then((value) {
                  if (!value.error) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainPage(
                                  user: userService.getUser(),
                                )),
                        ModalRoute.withName("/Home"));
                  } else {
                    ErrorDialog()
                        .showErrorDialog(context, "Error", value.errorMessage);
                  }
                });
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: Text(
                      "Place Order",
                      style: TextStyle(
                          color: Color.fromRGBO(230, 81, 0, 1), fontSize: 20),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      "${totalPrice}" + "TL",
                      style: TextStyle(
                          color: Color.fromRGBO(230, 81, 0, 1), fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Color.fromRGBO(230, 81, 0, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 60,
                  child: Center(
                      child: Text(
                    "Order Summary",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
                ),
                Divider(
                  thickness: 1.5,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SingleChildScrollView(
                    child: Container(
                      height: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Order Adderess",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text("${address.addressName}",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text("${address.addressLine}",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1.5,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 80,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Text(
                            "Shipping Company: ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text("${company.companyName}",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1.5,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 120,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Text(
                            "Card Information: ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text("${myCard.cardNumber}",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                        Expanded(
                          flex: 4,
                          child:
                              Text("${myCard.ownerName} ${myCard.ownerSurname}",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
