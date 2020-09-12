import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/models/address.dart';
import 'package:Selfsahaf/views/customer_view/shopping_cart/shipping_company_list.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/addAddress.dart';

class OrderAddress extends StatefulWidget {
  final double total;
  OrderAddress({@required this.total});
  @override
  _OrderAddressState createState() => _OrderAddressState();
}

class _OrderAddressState extends State<OrderAddress> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  AuthService userService = GetIt.I<AuthService>();
  List<Address> _addresses = new List();
  int radioGroup;
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            height: 50, child: Image.asset("images/logo_white/logo_white.png")),
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
          actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5,top:5,bottom:5),
            child: Container(
                child: Center(
              child: Text(
                "${widget.total} TL",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                width: MediaQuery.of(context).size.width - 32,
                height: 60,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Color.fromRGBO(230, 81, 0, 1))),
                  color: Colors.white,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                              title: Text("Address Information",style: TextStyle(color: Colors.white),),
                              content: AddAddress(
                                addType: 0,
                              ),
                            )).then((value) {
                      _getAddresses(context);
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 15,
                        child: Text(
                          "Add New Address",
                          style: TextStyle(
                              color: Color.fromRGBO(230, 81, 0, 1),
                              fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Color.fromRGBO(230, 81, 0, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                width: MediaQuery.of(context).size.width - 32,
                height: 60,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Color.fromRGBO(230, 81, 0, 1))),
                  color: Colors.white,
                  onPressed: () async {
                   if(radioGroup!=null){
                
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShippingCompanyList(address:_addresses[radioGroup] ,total:widget.total)),
                    );
                   }
                   else{
                     ErrorDialog().showErrorDialog(context, "Error!", "Please select an address.");
                   }
                    
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 15,
                        child: Text(
                          "Select Shipping Company",
                          style: TextStyle(
                              color: Color.fromRGBO(230, 81, 0, 1),
                              fontSize: 20),
                        ),
                      ),
                      Expanded(
                        
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Color.fromRGBO(230, 81, 0, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Container(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Center(
            child: RefreshIndicator(
                onRefresh: () => _getAddresses(context),
                key: _refreshIndicatorKey,
                child: ListView(
                  children: <Widget>[
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                      child: Text(
                        "Saved Addresses",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    )),
                    Divider(
                      color: Colors.white,
                      thickness: 3,
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        return (_addresses == null)
                            ? Center(
                                child: Text(
                                  "No address",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Row(
                                children: <Widget>[
                                  Flexible(
                                      flex: 1,
                                      fit: FlexFit.loose,
                                      child: Radio(
                                          activeColor: Colors.white,
                                          value: index,
                                          groupValue: radioGroup,
                                          onChanged: (T) {
                                            setState(() {
                                              radioGroup = T;
                                            });
                                          })),
                                  Flexible(
                                      flex: 5,
                                      child: AddressElement(
                                          address: _addresses[index]))
                                ],
                              );
                      },
                      itemCount: (_addresses == null) ? 1 : _addresses.length,
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class AddressElement extends StatefulWidget {
  final Address address;
  AddressElement({@required this.address});
  // AddressElement(){
  //   @required int addressIndex;
  //   @required String address1;
  //   String address2;
  //   bool selected = false;
  // }
  _AddressElementState createState() => _AddressElementState();
}

class _AddressElementState extends State<AddressElement> {
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.address.addressName,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  widget.address.addressLine,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${widget.address.postalCode}   ${widget.address.city}/${widget.address.country}",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2.5,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
