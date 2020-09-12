import 'package:Selfsahaf/views/admin_view/history_book_card.dart';
import 'package:flutter/material.dart';

class AdminListView extends StatefulWidget{
  @override
  _AdminListViewState createState() => _AdminListViewState();
}

class _AdminListViewState extends State<AdminListView>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
            height: 22,
            child: Image.asset("images/selfadmin_logo/selfadmin.png"),
          ),
          leading: InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: <Widget>[
                HistoryCard(userID: "12",userName: "sdasd",),

              ],
            ),
          ),
        ),
    );
  }
}