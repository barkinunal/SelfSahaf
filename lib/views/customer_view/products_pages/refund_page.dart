import 'dart:io';

import 'package:Selfsahaf/controller/order_service.dart';
import 'package:Selfsahaf/models/order.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class RefundPage extends StatefulWidget {
  Order ourOrder;
  RefundPage({@required this.ourOrder});
  @override
  _RefundPageState createState() => _RefundPageState();
}

class _RefundPageState extends State<RefundPage> {
  final _formKey = GlobalKey<FormState>();
  List<File> _imagesList = new List();
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(
        source: source, maxHeight: 640, maxWidth: 640, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _imagesList.add(File(pickedFile.path));
      }
      print("list size = ${_imagesList.length}");
    });
  }

  void clearImage(int index) {
    setState(() {
      _imagesList.removeAt(index);
      print(_imagesList.length);
    });
  }

  String refundreasonValidation(String reason) {
    if (reason.length < 60) {
      return "Please explain your reason in detail.";
    } else
      return null;
  }

  final _refundreasonController = TextEditingController();
  OrderService get orderService => GetIt.I<OrderService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        elevation: 8.0,
        backgroundColor: Colors.white,
        closeManually: false,
        overlayOpacity: 0,
        curve: Curves.bounceIn,
        shape: CircleBorder(),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        child: Icon(
          Icons.add_a_photo,
          color: Color(0xffe65100),
        ),
        children: [
          SpeedDialChild(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.photo_camera,
              color: Color(0xffe65100),
            ),
            label: "Camera",
            labelStyle: TextStyle(
              fontSize: 15.0,
            ),
            onTap: () => getImage(ImageSource.camera),
          ),
          SpeedDialChild(
              elevation: 8.0,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.photo_album,
                color: Color(0xffe65100),
              ),
              label: "Gallery",
              labelStyle: TextStyle(
                fontSize: 15.0,
              ),
              onTap: () => getImage(ImageSource.gallery)),
        ],
      ),
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
                      "Refund for: " + widget.ourOrder.product.name,
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
              (_imagesList.length == 0)
                  ? Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Text(
                        "No photo selected",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  : CarouselSlider.builder(
                      itemCount: _imagesList.length,
                      itemBuilder: (BuildContext context, int itemIndex) =>
                          Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  Container(
                                    child: Image.file(
                                      _imagesList[itemIndex],
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                        onPressed: () => clearImage(itemIndex)),
                                  ),
                                ],
                              )),
                      options: CarouselOptions(
                        autoPlay: false,
                        enableInfiniteScroll: false,
                        initialPage: 0,
                        enlargeCenterPage: true,
                      )),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    maxLines: 8,
                    minLines: 3,
                    controller: _refundreasonController,
                    validator: refundreasonValidation,
                    cursorColor: Colors.orange,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        labelText: "Reason for refunding",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            gapPadding: 2.0,
                            borderSide:
                                BorderSide(color: Colors.white, width: 3.0),
                            borderRadius: new BorderRadius.circular(16.0)),
                        enabledBorder: new OutlineInputBorder(
                          gapPadding: 2.0,
                          borderRadius: new BorderRadius.circular(16.0),
                          borderSide: new BorderSide(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        errorBorder: new OutlineInputBorder(
                          gapPadding: 2.0,
                          borderRadius: new BorderRadius.circular(16.0),
                          borderSide: new BorderSide(
                            color: Colors.deepPurple,
                            width: 3.0,
                          ),
                        ),
                        focusedErrorBorder: new OutlineInputBorder(
                          gapPadding: 2.0,
                          borderRadius: new BorderRadius.circular(16.0),
                          borderSide: new BorderSide(
                            color: Colors.deepPurple,
                            width: 3.0,
                          ),
                        )),
                  ),
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
                  "Submit Refund",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    orderService
                        .sendRefundRequest(
                            _imagesList,
                            widget.ourOrder.orderDetailID,
                            _refundreasonController.text)
                        .then((value) {
                      if (!value.error) {
                        Navigator.pop(context);
                      } else {
                        ErrorDialog().showErrorDialog(
                            context, "Error!", value.errorMessage);
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
