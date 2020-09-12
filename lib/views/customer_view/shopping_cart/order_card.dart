import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  final String bookName;
  final String authorName;
  final String publisherName;
  final String price;

  OrderCard(
          {@required this.bookName,
          @required this.authorName,
          @required this.publisherName,
          @required this.price,
          });

  @override
  _OrderCardState createState(){  return _OrderCardState(); }
}
class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context){
    return Padding(
      
      padding: const EdgeInsets.only(top:4.0, bottom: 4.0),
      child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:2,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.all(Radius.circular(25))),
                          child: Icon(Icons.book, color: Color(0xffe65100), size: 60,),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top:3.0,bottom:3.0),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.5),
                                    child: Text(
                                      "Name: ${widget.bookName}"
                                      ,
                                      style: TextStyle(
                                        color: Color(0xffe65100),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.5),
                                    child: Text("Author: ${widget.authorName}"
                                      ,
                                      style: TextStyle(
                                        color: Color(0xffe65100),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.5),
                                    child: Text("Publisher:${widget.publisherName} "
                                      ,
                                      style: TextStyle(
                                        color: Color(0xffe65100),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.5),
                                    child: Text(
                                      widget.price+" TL",
                                      style: TextStyle(
                                        color: Color(0xffe65100),
                                        fontSize: 15,
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
                        flex:2,
                        child: Container(
                          height: 100,
                          width: 100,
                          
                          child: Icon(Icons.arrow_forward_ios, color: Color(0xffe65100), size: 40,),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}



