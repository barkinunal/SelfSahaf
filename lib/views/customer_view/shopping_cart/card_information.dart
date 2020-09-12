import 'package:Selfsahaf/models/address.dart';
import 'package:Selfsahaf/models/shipping_company_model.dart';
import 'package:flutter/material.dart';
import 'package:Selfsahaf/views/customer_view/shopping_cart/credit_card_view/credit_card.dart';
import 'credit_card_view/credit_card_widget.dart';

import 'credit_card_view/credit_card_model.dart';

class CardInformation extends StatefulWidget {
  final Address address;
  final double totalPrice;
  final ShippingCompanyModel company;
  CardInformation(
      {@required this.address,
      @required this.totalPrice,
      @required this.company});
  @override
  _CardInformationState createState() => _CardInformationState();
}

class _CardInformationState extends State<CardInformation> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cardHolderSurname = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  Address address;
  double totalPrice;
  ShippingCompanyModel company;
  TextEditingController _cardholdernameController;
  TextEditingController _cardnumberController;
  TextEditingController _cvcController;
  TextEditingController _expirationController;
  TextEditingController _cardholdersurnameController;
    final _formKey = GlobalKey<FormState>();
  String _cardholdernameValidation(String name) {
    bool emailValid = false;
    if (name.length >= 5) emailValid = true;
    return emailValid ? null : 'not valid name.';
  }

  double total;
  @override
  void initState() {
    this.address = widget.address;
    this.total = widget.totalPrice;
    this.company = widget.company;
  }

  @override
  Widget build(BuildContext widget) {
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
            padding: EdgeInsets.only(right: 5, top: 5, bottom: 5),
            child: Container(
                child: Center(
              child: Text(
                "${total} TL",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )),
          )
        ],
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 40,
                  child: Center(
                      child: Text(
                    "Card Information",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
                ),
                Divider(
                  thickness: 2.5,
                  color: Colors.white,
                ),
                CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cardHolderSurname: cardHolderSurname,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                ),
                Divider(
                  thickness: 1.5,
                  color: Colors.white,
                ),
                CreditCardForm(
                  address: address,
                  totalPrice: total,
                  company: company,
                  onCreditCardModelChange: onCreditCardModelChange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
