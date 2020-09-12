import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/models/address.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/address_widget.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/addAddress.dart';

class AdressesPage extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _AdressesPage createState() => new _AdressesPage();
}

class _AdressesPage extends State<AdressesPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  AuthService userService = GetIt.I<AuthService>();
  List<Address> _addresses = new List();
  @override
  void initState() {
    _getAddresses(context);
  }

  _getAddresses(BuildContext context) async {
    userService.getUserAddresses().then((value) {
      if (!value.error) {
        setState(() {
          this._addresses = value.data;
        });
      } else {
        ErrorDialog().showErrorDialog(context, "Error", value.errorMessage);
        setState(() {
          this._addresses = value.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: Theme.of(context).primaryColor,
                    title: Text("Address informations",style: TextStyle(color: Colors.white),),
                    content: AddAddress(
                      addType: 0,
                    ),
                  )).then((value) {
            _getAddresses(context);
          }),
          backgroundColor: Colors.white,
          child: Icon(Icons.add,color: Theme.of(context).primaryColor,),
        ),
        body: RefreshIndicator(
            onRefresh: () => _getAddresses(context),
            key: _refreshIndicatorKey,
            child: ListView(
              children: <Widget>[
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    return (_addresses == null)
                        ? Center(
                            child: Text(
                              "No address",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : AddressWidget(
                            addressID: _addresses[index].addressID,
                            addressLine: _addresses[index].addressLine,
                            addressName: _addresses[index].addressName,
                            city: _addresses[index].city,
                            country: _addresses[index].country,
                            postalCode: _addresses[index].postalCode,
                          );
                  },
                  itemCount: (_addresses == null) ? 1 : _addresses.length,
                ),
                SizedBox(height: 80,) 
              ],
            )));
  }
}
