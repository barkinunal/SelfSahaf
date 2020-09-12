import 'package:Selfsahaf/controller/order_service.dart';
import 'package:Selfsahaf/models/given_orders.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/history_widget.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HistoryPage extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _HistoryPage createState() => new _HistoryPage();
}

class _HistoryPage extends State<HistoryPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  OrderService _orderService = GetIt.I<OrderService>();
  List<GivenOrders> _givenOrdes;
  @override
  void initState() {
    _getHistory(context);
  }

  _getHistory(BuildContext context) async {
    _orderService.givenOrders().then((value) {
      if (!value.error) {
        setState(() {
          this._givenOrdes = value.data;
        });
      } else {
        ErrorDialog().showErrorDialog(context, "Error", value.errorMessage);
        setState(() {
          this._givenOrdes = value.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () => _getHistory(context),
            key: _refreshIndicatorKey,
            child: ListView(
              children: <Widget>[
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    return (_givenOrdes == null)
                        ? Center(
                            child: Text(
                              "No Orders",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : HistoryWidget(
                            givenOrders: _givenOrdes[index],
                          );
                  },
                  itemCount: (_givenOrdes == null) ? 1 : _givenOrdes.length,
                ),
                SizedBox(
                  height: 80,
                )
              ],
            )));
  }
}
