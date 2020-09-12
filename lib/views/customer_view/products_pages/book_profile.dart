import 'dart:typed_data';

import 'package:Selfsahaf/controller/cart_service.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/models/user.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/seller_profile.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Selfsahaf/models/book.dart';
import 'package:Selfsahaf/views/customer_view/main_view/page_classes/main_page/home_page_carousel.dart';
import 'package:Selfsahaf/views/customer_view/products_pages/book_settings.dart';
import 'package:Selfsahaf/controller/product_services.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/views/customer_view/shopping_cart/shopping_cart.dart';

class BookProfile extends StatefulWidget {
  final Book selectedBook;
  final int type; //0 product  1 buy product 2 update cart
  int amount;
  BookProfile({@required this.selectedBook, @required this.type, this.amount});
  @override
  _BookProfileState createState() => _BookProfileState();
}

class _BookProfileState extends State<BookProfile> {
  ProductService get _productService => GetIt.I<ProductService>();
  CartService get _cartService => GetIt.I<CartService>();
  AuthService get _userService => GetIt.I<AuthService>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  User _user;
  int _itemCount = 1;
  List<Image> images;
  bool _loading = true;
  @override
  void initState() {
    _user = _userService.getUser();
    if (widget.amount != null) {
      this._itemCount = widget.amount;
    }
    print(widget.selectedBook.userName);
    print(widget.selectedBook.userSurname);
    _fetchData();
  }

  _fetchData() async {
    _productService.getAllImages(widget.selectedBook.productID).then((value) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 12,
        title: Container(
            height: 50, child: Image.asset("images/logo_white/logo_white.png")),
        actions: <Widget>[
          (widget.type == 0)
              ? IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookSettingsPage(
                            selectedBook: widget.selectedBook,
                          ),
                        )).then((e) {
                      if (e != null) {
                        Navigator.of(context).pop(e);
                      }
                    });
                  })
              : (widget.type == 1)
                  ? IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        (_user.role == "ROLE_ANON")
                            ? ErrorDialog().showLogin(context)
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShoppingCart()));
                      })
                  : (widget.type == 3)
                      ? Container()
                      : IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () {
                            print("salam");
                            Navigator.of(context).pop(this._itemCount);
                          })
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
                      child: SafeArea(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 20,
                              child: Container(
                                width: double.maxFinite,
                                height: 50,
                                child: Center(
                                    child: Text(
                                  widget.selectedBook.name,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                )),
                              ),
                            ),
                            Expanded(flex: 2, child: SizedBox()),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 70,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 20,
                              child: Row(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text("Amount: ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                ),
                                (_itemCount != 1)
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                        onPressed: () =>
                                            setState(() => _itemCount--),
                                      )
                                    : new Container(
                                        width: 50,
                                      ),
                                new Container(
                                    alignment: Alignment.center,
                                    width: 50,
                                    height: 30,
                                    color: Colors.white,
                                    child: Text(
                                      "$_itemCount",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 25),
                                    )),
                                (widget.selectedBook.quantity == _itemCount)
                                    ? Container()
                                    : new IconButton(
                                        icon: new Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                        onPressed: () =>
                                            setState(() => _itemCount++)),
                              ])),
                          Expanded(
                              flex: 11,
                              child: InkWell(
                                  child: Container(
                               alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(bottom: 30,left: 15,),
                                    margin: EdgeInsets.only(right: 15,bottom: 10),
                                  
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    child: Center(
                                        child: (widget.selectedBook.discount ==
                                                0)
                                            ? Text(
                                                "${widget.selectedBook.price * _itemCount} TL",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 16),
                                              )
                                            : ListTile(
                                                title: Text(
                                                  "${(widget.selectedBook.price - widget.selectedBook.price * widget.selectedBook.discount / 100) * _itemCount} TL",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 16),
                                                ),
                                                subtitle: Text(
                                                  "${widget.selectedBook.price * _itemCount} TL",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 13,
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                ),
                                              )),
                                  ),
                                  onTap: () {
                                    (_user.role == "ROLE_ANON")
                                        ? ErrorDialog().showLogin(context)
                                        : (widget.selectedBook.sellerID ==
                                                _user.userID)
                                            ? ErrorDialog().showErrorDialog(
                                                context,
                                                "Error!",
                                                "You can not buy your product!")
                                            : _cartService
                                                .addItemToCart(
                                                    _itemCount,
                                                    widget
                                                        .selectedBook.productID,
                                                    widget
                                                        .selectedBook.sellerID)
                                                .then((value) {
                                                if (!value.error) {
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    backgroundColor:
                                                        Colors.white,
                                                    content: Text(
                                                      "Added to the cart.",
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            230, 81, 0, 1),
                                                        fontSize: 18,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ));
                                                } else {
                                                  ErrorDialog().showErrorDialog(
                                                      context,
                                                      "Error!",
                                                      value.errorMessage);
                                                }
                                              });
                                  }))
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
                                            seller: widget.selectedBook,
                                            type: 0)),
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
                                            "${widget.selectedBook.userName}" +
                                                " ${widget.selectedBook.userSurname}",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
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
                                      Text(widget.selectedBook.authorName,
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45,
                                child: Center(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Status: ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(widget.selectedBook.status,
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
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
                                      Text(widget.selectedBook.language,
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
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
                                      Text(widget.selectedBook.categoryName,
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
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
                                      Text(widget.selectedBook.isbn,
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45,
                                child: Center(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Quantity: ",
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
                                height: 5,
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
                                      widget.selectedBook.publisher,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                              ),
                              SizedBox(
                                height: 5,
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
                                                widget.selectedBook.description,
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
