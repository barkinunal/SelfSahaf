import 'package:Selfsahaf/models/given_orders.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/given_order_details_page.dart';
import 'package:flutter/material.dart';


class HistoryWidget extends StatelessWidget {
 final GivenOrders givenOrders;
  HistoryWidget(
      {@required this.givenOrders});
  int addressID;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=> GivenOrderDetails(id: givenOrders.orderID) ));
        },
          child: Padding(
          padding:
              const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 10, right: 10),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Given Order Count:  "+givenOrders.itemCount.toString(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            givenOrders.dateTime,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16),
                          ),
                        ),
                        
                      ],
                    ),
                  ),

       
          
          ),
    );
  }
}
