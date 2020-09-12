import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/controller/product_services.dart';

class UserCard extends StatefulWidget {
  final String userName;
  final String userID;
  
  UserCard(
          {@required this.userName,@required this.userID});

  @override
  _UserCardState createState(){  return _UserCardState(); }
}
class _UserCardState extends State<UserCard> {
  ProductService get _userService => GetIt.I<ProductService>();
   Uint8List photo;
  /*@override
  void initState() {
    super.initState();
    _productService.getImage(widget.sellerID, widget.productID, 1).then((value) {
      setState(() {
        this.photo=value;
      });
    });
  }*/
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
                        flex:5,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.all(Radius.circular(25))),
                          child:(photo==null)? Icon(Icons.book, color: Color(0xffe65100), size: 60,):ClipRRect(borderRadius:BorderRadius.circular(25),child: Image.memory(photo, fit: BoxFit.cover,)),
                        ),
                      ),
                      Expanded(
                        flex: 9,
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
                                      "Name: ${widget.userName}",
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



