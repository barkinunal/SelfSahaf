import 'dart:io';

import 'package:Selfsahaf/controller/order_service.dart';
import 'package:Selfsahaf/models/refund_model.dart';
import 'package:Selfsahaf/views/customer_view/products_pages/book_profile.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

class RefundDetailsPage extends StatefulWidget {
  RefundModel refundItem;
  RefundDetailsPage({@required this.refundItem});
  @override
  _RefundDetailsPageState createState() => _RefundDetailsPageState();
}

class _RefundDetailsPageState extends State<RefundDetailsPage> {
  List<Image> _imagesList = new List();

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
                    "Refund Status: " + widget.refundItem.status,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
                  SizedBox(height: 10,),
              
              (_imagesList==null)
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
                child: Text("User message: \n\t\t\t\t\t\t"+
                  widget.refundItem.message,
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
                  Navigator.push(context,MaterialPageRoute(builder: (_)=>BookProfile(selectedBook: widget.refundItem.order.product, type: 3)));

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
