import 'package:Selfsahaf/controller/cart_service.dart';
import 'package:Selfsahaf/controller/order_service.dart';
import 'package:Selfsahaf/controller/rating_controller.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/models/order.dart';
import 'package:Selfsahaf/models/rating.dart';
import 'package:Selfsahaf/models/user.dart';
import 'package:Selfsahaf/views/customer_view/products_pages/refund_page.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/seller_profile.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Selfsahaf/views/customer_view/main_view/page_classes/main_page/home_page_carousel.dart';
import 'package:Selfsahaf/controller/product_services.dart';
import 'package:get_it/get_it.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class BoughtBookProfile extends StatefulWidget {
  final Order selectedBook;
  int amount;
  BoughtBookProfile({@required this.selectedBook, this.amount});
  @override
  _BoughtBookProfileState createState() => _BoughtBookProfileState();
}

class _BoughtBookProfileState extends State<BoughtBookProfile> {
  Order ourOrder;
  ProductService get _productService => GetIt.I<ProductService>();
  OrderService get _orderService => GetIt.I<OrderService>();
  RatingService get _ratingService => GetIt.I<RatingService>();
  CartService get _cartService => GetIt.I<CartService>();
  AuthService get _userService => GetIt.I<AuthService>();
  TextEditingController commentController = new TextEditingController();
  int finalRate = 0;
  String commentValidation(String comment) {
    bool valid = false;
    if (comment.length > 20) {
      valid = true;
    }
    return valid ? null : "Please make comments in detail";
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  User _user;
  int _itemCount = 1;
  List<Image> images;
  bool _loading = true;
  int status; // 1=> order cancel is able.  2=> confirm/shipping/delivered ise refund is able. 3=> delivered ise rate seller is able
  @override
  void initState() {
    print(widget.selectedBook.status);
    if (widget.selectedBook.status == "ACTIVE") {
      this.status = 1;
      print(this.status);
    } else if (widget.selectedBook.status == "CONFIRM" ||
        widget.selectedBook.status == "SHIPPING") {
      this.status = 2;
    } else if (widget.selectedBook.status == "DELIVERED") {
      this.status = 3;
    } else
      this.status = 4;

    this.ourOrder = widget.selectedBook;
    _user = _userService.getUser();
    if (widget.amount != null) {
      this._itemCount = widget.amount;
    }
    _fetchData();
  }

  _fetchData() async {
    _productService
        .getAllImages(widget.selectedBook.product.productID)
        .then((value) {
      setState(() {
        if (value.error) {
          print("error");
        } else {
          images = value.data;
          _loading = false;
        }
      });
    });
  }

  _cancelOrder(int orderDetailID) {
    _orderService.cancelOrder(orderDetailID).then((value) {
      if (value.error) {
        ErrorDialog().showErrorDialog(context, "Error!", value.errorMessage);
      } else {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(
                  "OK!",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                content: Text("Cancellation is Successful.",
                    style: TextStyle(
                      color: Colors.white,
                    )),
                actions: <Widget>[
                  FlatButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              );
            });
      }
    });
  }

  _rateSeller(int orderDetailID, Rating rating){
    _ratingService
        .rateSeller(orderDetailID, rating)
        .then((value) {
      print(value.data);
      if (!value.error) {
        setState(() {
          return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        title: Text("Rating"),
                        content: Text("Your comment submission has been saved!"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK!",style: TextStyle(color: Theme.of(context).primaryColor),),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                  );
        });
      } else {
        ErrorDialog().showErrorDialog(context, "Error", value.errorMessage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (this.status == 3)
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.star,
                color: Colors.deepPurple,
              ),
              onPressed: () {
                return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        title: Text(
                          "Rate ${widget.selectedBook.seller.name} ${widget.selectedBook.seller.surname}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        content: Container(
                          height: 250,
                          child: Column(
                            children: <Widget>[
                              Text("Rate seller out of 5",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              SmoothStarRating(
                                allowHalfRating: false,
                                defaultIconData: Icons.star_border,
                                filledIconData: Icons.star,
                                borderColor: Colors.deepPurple,
                                color: Colors.deepPurple,
                                size: 40,
                                isReadOnly: false,
                                onRated: (value) {
                                  setState(() {
                                    finalRate = value.toInt();
                                  });
                                  // print("rating value dd -> ${value.truncate()}");
                                },
                                starCount: 5,
                                spacing: 2,
                              ),
                              SizedBox(height: 15,),
                              TextFormField(
                                maxLines: 6,
                                controller: commentController,
                                validator: commentValidation,
                                cursorColor: Colors.orange,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.white),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    labelText: "Comments About Seller",
                                    labelStyle: TextStyle(color: Colors.white),
                                    focusedBorder: OutlineInputBorder(
                                        gapPadding: 2.0,
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 3.0),
                                        borderRadius:
                                            new BorderRadius.circular(16.0)),
                                    enabledBorder: new OutlineInputBorder(
                                      gapPadding: 2.0,
                                      borderRadius:
                                          new BorderRadius.circular(16.0),
                                      borderSide: new BorderSide(
                                        color: Colors.white,
                                        width: 3.0,
                                      ),
                                    ),
                                    errorBorder: new OutlineInputBorder(
                                      gapPadding: 2.0,
                                      borderRadius:
                                          new BorderRadius.circular(16.0),
                                      borderSide: new BorderSide(
                                        color: Colors.deepPurple,
                                        width: 3.0,
                                      ),
                                    ),
                                    focusedErrorBorder: new OutlineInputBorder(
                                      gapPadding: 2.0,
                                      borderRadius:
                                          new BorderRadius.circular(16.0),
                                      borderSide: new BorderSide(
                                        color: Colors.deepPurple,
                                        width: 3.0,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () {
                              Rating newRating = new Rating(comment: commentController.text,rating: finalRate);
                              _rateSeller(widget.selectedBook.orderDetailID, newRating);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Accept",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          FlatButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      );
                    });
              },
            )
          : null,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 12,
        title: Container(
            height: 50, child: Image.asset("images/logo_white/logo_white.png")),
        actions: <Widget>[
          (this.status == 1)
              ? IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                            title: Text(
                              "Cancel Order",
                              style: TextStyle(color: Colors.white),
                            ),
                            content: Text(
                              "Are you sure about cancelling order?",
                              style: TextStyle(color: Colors.white),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _cancelOrder(
                                      widget.selectedBook.orderDetailID);
                                },
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              FlatButton(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("No",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor)),
                              ),
                            ],
                          );
                        });
                  },
                )
              : (this.status == 2 || this.status == 3)
                  ? IconButton(
                      icon: Icon(
                        Icons.assignment,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RefundPage(
                                    ourOrder: widget.selectedBook,
                                  )),
                        );
                      },
                    )
                  : Icon(
                      Icons.cancel,
                      color: Colors.transparent,
                    ),
        ],
      ),
      body: (_loading)
          ? Container(
              color: Colors.transparent,
              child: Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              )))
          : Center(
              child: Container(
                color: Color(0xffe65100),
                child: Column(
                  children: <Widget>[
                    HomePageCarousel(
                      bookImages: images,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.maxFinite,
                            height: 40,
                            child: Center(
                                child: Text(
                              widget.selectedBook.product.name,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            )),
                          ),
                          Container(
                            width: double.maxFinite,
                            height: 40,
                            child: Center(
                                child: Text(
                              "Price: " +
                                  (widget.selectedBook.price *
                                          widget.amount.toInt())
                                      .toString() +
                                  " TL",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2.2,
                      color: Colors.white,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SellerProfilePage(
                                              seller:
                                                  widget.selectedBook.product,
                                              type: 0,
                                            )),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20),
                                        topRight: const Radius.circular(20),
                                        bottomLeft: const Radius.circular(20),
                                        bottomRight: const Radius.circular(20),
                                      )),
                                  width: double.maxFinite,
                                  height: 45,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Seller: ",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        Text(
                                            "${widget.selectedBook.product.userName}" +
                                                " ${widget.selectedBook.product.userSurname}",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45,
                                child: Center(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Author: ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                          widget
                                              .selectedBook.product.authorName,
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45,
                                child: Center(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Language: ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(widget.selectedBook.product.language,
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45,
                                child: Center(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Book Status: ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(widget.selectedBook.product.status,
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45,
                                child: Center(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Order Status: ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(widget.selectedBook.status,
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45,
                                child: Center(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Category: ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                          widget.selectedBook.product
                                              .categoryName,
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45,
                                child: Center(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "ISBN: ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(widget.selectedBook.product.isbn,
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45,
                                child: Center(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Copies You Bought: ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                          widget.selectedBook.quantity
                                              .toString(),
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45,
                                child: Center(
                                    child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Publisher: ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      widget.selectedBook.product.publisher,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45,
                                child: Center(
                                    child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Shipping Company: ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      widget.selectedBook.shippingInfo
                                          .shippingcompany.companyName,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45,
                                child: Center(
                                    child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Shipping Tracking Number: ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      widget.selectedBook.shippingInfo
                                          .trackingNumber,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45,
                                child: Center(
                                    child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Seller Name: ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      widget.selectedBook.seller.name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45,
                                child: Center(
                                    child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Seller Phone Number: ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      widget.selectedBook.seller.phoneNumber,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Divider(
                                thickness: 1.2,
                                color: Colors.white,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 120,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SingleChildScrollView(
                                              child: Text(
                                            "More About Book:\n " +
                                                widget.selectedBook.product
                                                    .description,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
