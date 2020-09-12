import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/addAddress.dart';

class AddressWidget extends StatelessWidget {
  String addressName, addressLine, city, country, postalCode;
  AuthService userService = GetIt.I<AuthService>();
  AddressWidget(
      {this.addressName,
      this.addressLine,
      this.city,
      this.country,
      this.postalCode,
      this.addressID});
  int addressID;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 10, right: 10),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        addressName,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20),
                      ),
                      Text(
                        addressLine,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${postalCode}   ${city}/${country}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                  flex: 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            onTap: () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    actions: <Widget>[
                                      
                                    ],
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    content: AddAddress(
                                      addType: 2,
                                      addressID: addressID,
                                      addressLine: addressLine,
                                      addressName: addressName,
                                      city: city,
                                      country: country,
                                      postalCode: postalCode,
                                    ),
                                    title: Text(
                                      "Update Address Information",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                            child: Icon(
                              Icons.edit,
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            )),
                        InkWell(
                            onTap: () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    content: Text(
                                      "Do you want to delete $addressName",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    title: Text("Are you sure",
                                        style: TextStyle(color: Colors.white)),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            userService
                                                .deleteAddress(addressID)
                                                .then((value) {
                                              if (value == 200) {
                                                Navigator.pop(context);
                                                return null;
                                              } else
                                                print("HATATATAT");
                                            });
                                          },
                                          child: Text(
                                            "yes",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      FlatButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            "no",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ],
                                  ),
                                ).then((value) {}),
                            child: Icon(
                              Icons.delete,
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            ))
                      ]))
            ],
          ),
        ));
  }
}
