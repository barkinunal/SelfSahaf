import 'package:Selfsahaf/models/user.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/seller_profile.dart';
import 'package:flutter/material.dart';

class UserCardForUser extends StatefulWidget {
  User seller;
  UserCardForUser({this.seller});
  @override
  _UserCardForUserState createState() => _UserCardForUserState();
}

class _UserCardForUserState extends State<UserCardForUser> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Icon(
                    Icons.person,
                    color: Color(0xffe65100),
                    size: 60,
                  )
                  // : ClipRRect(
                  //     borderRadius: BorderRadius.circular(25),
                  //     child: Image.memory(
                  //       photo,
                  //       fit: BoxFit.cover,
                  //     )),
                  ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: Text(
                            "Name: ${widget.seller.name} " +
                                "${widget.seller.surname}",
                            style: TextStyle(
                              color: Color(0xffe65100),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: Text(
                            "Mail: ${widget.seller.email}",
                            style: TextStyle(
                              color: Color(0xffe65100),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SellerProfilePage(
                              type: 1,
                              user: widget.seller,
                            )),
                  );
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xffe65100),
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
