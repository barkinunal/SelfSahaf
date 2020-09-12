import 'package:Selfsahaf/controller/admin_service.dart';
import 'package:Selfsahaf/models/user.dart';
import 'package:Selfsahaf/views/customer_view/main_view/page_classes/notification_pages/user_card_for_user.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NotificationTopSellers extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _NotificationTopSellers createState() => new _NotificationTopSellers();
}

class _NotificationTopSellers extends State<NotificationTopSellers> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  AdminService _adminService = GetIt.I<AdminService>();
  List<User> bestSahafs;
  var error;
  @override
  void initState() {
    _getSellers(context);
  }

  _getSellers(BuildContext context) async {
    _adminService.getTopSellers(2).then((value) {
      if (!value.error) {
        setState(() {
          this.bestSahafs = value.data;
        });
      } else {
        ErrorDialog().showErrorDialog(context, "Error", value.errorMessage);
        setState(() {
          this.bestSahafs = value.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () => _getSellers(context),
            key: _refreshIndicatorKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {
                      return (bestSahafs == null)
                          ? Center(
                              child: Text(
                                "No Best Sahaf Exist.",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : UserCardForUser(seller: bestSahafs[index],);
                    },
                    itemCount: (bestSahafs == null) ? 1 : bestSahafs.length,
                  ),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
            )));
  }
}
