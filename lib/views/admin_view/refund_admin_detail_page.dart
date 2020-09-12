import 'package:Selfsahaf/controller/order_service.dart';
import 'package:Selfsahaf/models/refund_model.dart';
import 'package:Selfsahaf/views/customer_view/products_pages/book_profile.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/seller_profile.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

class RefundDetailsPageForAdmin extends StatefulWidget {
  RefundModel refundItem;
  RefundDetailsPageForAdmin({@required this.refundItem});
  @override
  _RefundDetailsPageForAdminState createState() =>
      _RefundDetailsPageForAdminState();
}

class _RefundDetailsPageForAdminState extends State<RefundDetailsPageForAdmin> {
  List<Image> _imagesList;

  String refundreasonValidation(String reason) {
    if (reason.length < 60) {
      return "Please explain your reason in detail.";
    } else
      return null;
  }

  bool _loading = true;
  OrderService get orderService => GetIt.I<OrderService>();
  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() {
    orderService.getRefundImages(widget.refundItem.refundID).then((value) {
      if (!value.error) {
        setState(() {
          _loading = false;
          this._imagesList = value.data;
        });
      } else {
        setState(() {
          _loading = false;
          this._imagesList = value.data;
          ErrorDialog().showErrorDialog(context, "Error!", value.errorMessage);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            height: 50, child: Image.asset("images/logo_white/logo_white.png")),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Container(
                  child: Center(
                    child: Text(
                      "Refund for: " + widget.refundItem.order.product.name,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 1.5,
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Status: " + widget.refundItem.status,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
              SizedBox(
                height: 10,
              ),
              (_imagesList == null)
                  ? Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Text(
                        "No photo ",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  : CarouselSlider.builder(
                      itemCount: _imagesList.length,
                      itemBuilder: (BuildContext context, int itemIndex) =>
                          Container(
                            width: 640,
                            height: 640,
                            padding: EdgeInsets.only(bottom: 10),
                            child: _imagesList[itemIndex],
                          ),
                      options: CarouselOptions(
                        autoPlay: false,
                        enableInfiniteScroll: false,
                        initialPage: 0,
                        enlargeCenterPage: false,
                      )),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  "User message: \n\t\t\t\t\t\t" + widget.refundItem.message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "Book Profile",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BookProfile(
                              selectedBook: widget.refundItem.order.product,
                              type: 3)));
                },
              ),
               
              SizedBox(
                height: 10,
              ),
              FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "Seller Profile",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SellerProfilePage(
                            user: widget.refundItem.order.seller,
                              type: 1)));
                },
              ),
               SizedBox(
                height: 10,
              ),
               Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                            child: SizedBox(
                          width: 10,
                        )),
                        Expanded(
                          flex: 4,
                          child: FlatButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Confrim",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              orderService
                                  .refundEvaulate(
                                      true, widget.refundItem.refundID)
                                  .then((value) {
                                if (!value.error) {
                                  Navigator.pop(context);
                                } else {
                                  ErrorDialog().showErrorDialog(
                                      context, "Error", value.errorMessage);
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                            child: SizedBox(
                          width: 10,
                        )),
                        Expanded(
                          flex: 4,
                          child: FlatButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              orderService
                                  .refundEvaulate(
                                      false, widget.refundItem.refundID)
                                  .then((value) {
                                if (!value.error) {
                                  Navigator.pop(context);
                                } else {
                                  ErrorDialog().showErrorDialog(
                                      context, "Error", value.errorMessage);
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: SizedBox(
                              width: 10,
                            )),
                      ],
                    )
                 ,
            ],
          ),
        ),
      ),
    );
  }
}
