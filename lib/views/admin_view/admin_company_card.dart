import 'package:Selfsahaf/controller/shipping_company_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ShippingCompaniesCardAdmin extends StatefulWidget {
  final String companyName;
  final double price;
  bool isSelected = false;
  ShippingCompaniesCardAdmin({
    @required this.companyName,
    @required this.price,
  });
  @override
  _ShippingCompaniesCardAdminState createState() => _ShippingCompaniesCardAdminState();
}

class _ShippingCompaniesCardAdminState extends State<ShippingCompaniesCardAdmin> {
    ShippingCompanyService companyService = GetIt.I<ShippingCompanyService>();
  
  _deleteCompany() async {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    print("sa");
                  },
                  child: FlatButton(
                    onPressed: () {
                      companyService.deleteCompany(widget.companyName).then((value) {
                        if(!value.error)
                          Navigator.pop(context);

                      });
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {},
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                )
              ],
              backgroundColor: Theme.of(context).primaryColor,
              content:Text("Do you want to delete  ${widget.companyName}?", style: TextStyle(color: Colors.white)),
              title:
                  Text("Add Category", style: TextStyle(color: Colors.white)),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:8.0,bottom: 8.0,right: 16.0,left: 16.0),
          child: Container(
            height: 70,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                       Text(
                          "${widget.companyName}",
                          style: TextStyle(color: Colors.white,fontSize: 20),
                        ),
                        SizedBox(height: 8,),
                        Text(
                          "${widget.price} TL",
                          style: TextStyle(color: Colors.white),
                        ),
                    ],
                  ),
                ),
                
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 35,
                    ),
                    onTap: () {
                      _deleteCompany();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 2,
          color: Colors.white,
        ),
      ],
    );
  }
}
