import 'package:Selfsahaf/controller/admin_service.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Selfsahaf/views/admin_view/admin_drawer.dart';
import 'package:get_it/get_it.dart';

class AdminMainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AdminMainPageState();
  }
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _userCount = 0, _ordersCount = 0, _sellerCount = 0;
  AdminService _adminService = GetIt.I<AdminService>();
  bool _isloading = true;
  _getUserCount() async{
    _adminService.getUserCount().then((value) {
      if (!value.error) {
        setState(() {

          this._userCount = value.data;
        });
      } else {
        setState(() async{

          this._userCount = value.data;
        });
        ErrorDialog().showErrorDialog(context, "Error", value.errorMessage);
      }
    });
  }

  _getSellerCount() async{
    _adminService.getSellerCount().then((value) {
      if (!value.error) {
        setState(() {
          this._sellerCount = value.data;
        });
      } else {
        setState(() {
          this._sellerCount = value.data;
        });
        ErrorDialog().showErrorDialog(context, "Error", value.errorMessage);
      }
    });
  }

  _getOrderCount() {
    _adminService.getOrderCount().then((value) {
      if (!value.error) {
        setState(() {
          this._ordersCount = value.data;
        });
      } else {
        setState(() {
          this._ordersCount = value.data;
        });
        ErrorDialog().showErrorDialog(context, "Error", value.errorMessage);
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    _getSellerCount();
    _getOrderCount();
    _getUserCount().then((value){
      _isloading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Container(
            height: 22,
            child: Image.asset("images/selfadmin_logo/selfadmin.png"),
          ),
        ),
        drawer: AdminDrawer(),
        body: (_isloading)
          ? Container(
              color: Colors.transparent,
              child: Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              )))
          : Center(
            child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "$_userCount",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      child: Text(
                        "Users Exist",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "$_ordersCount",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      child: Text(
                        "Orders Given",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "$_sellerCount",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      child: Text(
                        "Sahafs Exist",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )));
  }
}
