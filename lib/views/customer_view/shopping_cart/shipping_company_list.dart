import 'package:Selfsahaf/controller/shipping_company_service.dart';
import 'package:Selfsahaf/models/address.dart';
import 'package:Selfsahaf/views/customer_view/shopping_cart/card_information.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Selfsahaf/models/shipping_company_model.dart';
import 'package:get_it/get_it.dart';

class ShippingCompanyList extends StatefulWidget {
  final Address address;
  final double total;
  ShippingCompanyList({@required this.address, @required this.total});

  @override
  _ShippingCompanyListState createState() => _ShippingCompanyListState();
}

class _ShippingCompanyListState extends State<ShippingCompanyList> {
  Address address;
  int companyGroup;
  List<ShippingCompanyModel> _companies;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  ShippingCompanyService companyService = GetIt.I<ShippingCompanyService>();
  @override
  void initState() {
    this.address = widget.address;
    _refresh(context);
  }

  _refresh(BuildContext context) {
    companyService.getCompanies().then((value) {
      if (value.error) {
        ErrorDialog().showErrorDialog(context, "Error!", value.errorMessage);
      }
      setState(() {
        this._companies = value.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
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
               if(companyGroup==null){
                 ErrorDialog().showErrorDialog(context, "Error!", "Select a company!");
               }
               else{
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CardInformation(
                            address: widget.address,
                            totalPrice: widget.total + _companies[companyGroup].price,
                            company: _companies[companyGroup],
                          )),
                );
               }
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 15,
                    child: Text(
                      "Card Information",
                      style: TextStyle(
                          color: Color.fromRGBO(230, 81, 0, 1), fontSize: 20),
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
      body: Padding(
         padding: const EdgeInsets.all(16.0),
        child: Container(
      
            child: Center(
              child: RefreshIndicator(
                  onRefresh: ()async { _refresh(context);},
                  key: _refreshIndicatorKey,
                  child: ListView(
                    children: <Widget>[
                      Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                      child: Text(
                        "Shipping Companies",
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
                          return (_companies == null)
                              ? Center(
                                  child: Text(
                                    "No Shipping Company",
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
                                          groupValue: companyGroup,
                                          onChanged: (T) {
                                            setState(() {
                                              companyGroup = T;
                                            });
                                          })),
                                  Flexible(
                                      flex: 5,
                                      child: Company(
                                          company: _companies[index]))
                                ],
                              );
                        },
                        itemCount: (_companies == null) ? 1 : _companies.length,
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  )),
            )),
      ),
    );
  }
}
class Company extends StatefulWidget {

 final ShippingCompanyModel company;
Company({@required this.company});
  @override
  _CompanyState createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  @override
  Widget build(BuildContext context) {
   return Container(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.company.companyName,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.company.price.toString()+" TL",
                    style: TextStyle(color: Colors.white, fontSize: 16),
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