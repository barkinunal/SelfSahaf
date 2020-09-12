import 'package:flutter/material.dart';

class ShippingCard extends StatefulWidget {
  final String companyName;
  final String price;
  bool isSelected = false;
  ShippingCard({
    @required this.companyName,
    @required this.price,
    
  });

  @override
  _ShippingCardState createState() {
    return _ShippingCardState();
  }
}

class _ShippingCardState extends State<ShippingCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Checkbox(
                activeColor: Colors.deepOrange[300],
                checkColor: Colors.white,
                value: widget.isSelected,
                onChanged: (value) {
                  widget.isSelected = value;
                } ,
              ),
            ),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "${widget.companyName}",
                  style: TextStyle(
                    color: Color(0xffe65100),
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {},
                child: Icon(
                  Icons.edit,
                  color: Color(0xffe65100),
                  size: 40,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {},
                child: Icon(
                  Icons.delete,
                  color: Color(0xffe65100),
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
