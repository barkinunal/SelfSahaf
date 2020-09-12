import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/controller/product_services.dart';

class ProductCard extends StatefulWidget {
  final String bookName;
  final String authorName;
  final String publisherName;
  final double price;
  final int sellerID, productID;
  final int type;
  final int amount;
  final int discount;
  ProductCard(
      {@required this.bookName,
      @required this.authorName,
      @required this.publisherName,
      @required this.price,
      @required this.sellerID,
      @required this.productID,
      @required this.type,
      this.amount,
      this.discount});

  @override
  _ProductsCardState createState() {
    return _ProductsCardState();
  }
}

class _ProductsCardState extends State<ProductCard> {
  ProductService get _productService => GetIt.I<ProductService>();
  Uint8List photo;
  double currentprice;
  @override
  void initState() {
    
    if(widget.discount==0){
   currentprice=widget.price;
    }
    else{
      currentprice=widget.price-widget.price*widget.discount/100;
    }
    super.initState();
    _productService
        .getImage(widget.sellerID, widget.productID, 1)
        .then((value) {
      setState(() {
        this.photo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: (photo == null)
                    ? Icon(
                        Icons.book,
                        color: Color(0xffe65100),
                        size: 60,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.memory(
                          photo,
                          fit: BoxFit.cover,
                        )),
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: Text(
                            "Name: ${widget.bookName}",
                            style: TextStyle(
                              color: Color(0xffe65100),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: Text(
                            "Author: ${widget.authorName}",
                            style: TextStyle(
                              color: Color(0xffe65100),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: Text(
                            "Publisher:${widget.publisherName} ",
                            style: TextStyle(
                              color: Color(0xffe65100),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: Text(
                            (widget.type == 1 && widget.amount!=null)
                                ? "Amount: " +
                                    widget.amount.toString() +
                                    "    " +
                                    currentprice.toString() +
                                    " TL"
                                : currentprice.toString() + " TL",
                            style: TextStyle(
                              color: Color(0xffe65100),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 100,
                width: 100,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xffe65100),
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
