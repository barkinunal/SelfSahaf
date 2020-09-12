import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/controller/book_controller.dart';
import 'package:Selfsahaf/models/book.dart';
import "package:Selfsahaf/views/customer_view/products_pages/book_profile.dart";

class BookCard extends StatefulWidget {
  Book book;
  BookCard({this.book});

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  BookService get _bookService => GetIt.I<BookService>();
  Uint8List photo;
  @override
  void initState() {
    super.initState();
   _getbookphoto();
  }
  _getbookphoto(){
      _bookService
        .getImage(widget.book.sellerID, widget.book.productID, 1)
        .then((value) {
      setState(() {
        this.photo = value;
      });
    });
  }

  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      child: Padding(
        child: InkWell(
          onTap: () {
            setState(() {
              clicked = !clicked;
            });
          },
          child: (clicked)
              ? Container(
                  width: 40,
                  
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(252, 140, 3, 0.8),
                    borderRadius: BorderRadius.circular(25)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 6,
                                child: Text(widget.book.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white)),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Author: " + widget.book.authorName,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Expanded(

                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.only(left:30),
                                  alignment: Alignment.centerRight,
                                  child:
                               (widget.book.discount ==
                                                0)
                                            ? Text(
                                                "${widget.book.price } TL",
                                                style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                              )
                                            : ListTile(
                                                title: Text(
                                                  "${(widget.book.price - widget.book.price * widget.book.discount / 100) } TL",
                                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                                )),
                                                subtitle: Text(
                                                  "${widget.book.price } TL",
                                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800, decoration: TextDecoration.lineThrough)
                                                ),
                                              ),
                                ), /*Text(
                                  "${widget.book.price} TL",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                )*/
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            BookProfile(selectedBook: widget.book, type: 1,)));
                              },
                              child: Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 50),
                            )),
                      ],
                    ),
                  ))
              : GridTile(
                  child: Container(
                    child: (photo == null)
                        ? Icon(
                            Icons.book,
                            color: Colors.white,
                            size: 80,
                          )
                        : ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.memory(
                          photo,
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
        ),
        padding: EdgeInsets.all(4.0),
      ),
    ));
  }
}
