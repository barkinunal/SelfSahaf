import 'package:Selfsahaf/models/user.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:Selfsahaf/controller/rating_controller.dart';
import 'package:Selfsahaf/models/book.dart';
import 'package:Selfsahaf/models/rating.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class SellerCommentsPage extends StatefulWidget {
  Book sellingBook;
   User user;
  int type;//o for normal user 1 for admin
  SellerCommentsPage({this.sellingBook,this.type,this.user});
  @override
  _SellerCommentsPage createState() => new _SellerCommentsPage();
}

class _SellerCommentsPage extends State<SellerCommentsPage> {
  Book sellingBook;
  User seller;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  RatingService _ratingService = GetIt.I<RatingService>();
  List<Rating> allRatings;
  @override
  void initState() {
    this.sellingBook = widget.sellingBook;
    this.seller=widget.user;
    _getRatings(context);
  }

  _getRatings(BuildContext context) async {
    _ratingService.getRatings((widget.type==0)?sellingBook.sellerID:seller.userID).then((value) {
      print(value.data);
      if (!value.error) {
        setState(() {
          this.allRatings = value.data;
        });
      } else {
        ErrorDialog().showErrorDialog(context, "Error", value.errorMessage);
        setState(() {
          this.allRatings = value.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () => _getRatings(context),
            key: _refreshIndicatorKey,
            child: ListView(
              children: <Widget>[
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    return (allRatings == null)
                        ? Center(
                            child: Text(
                              "No Comments Exists",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32) 
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Expanded(flex: 3,child: Text(allRatings[index].comment,style: TextStyle(color: Theme.of(context).primaryColor),)),
                                  Expanded(
                                    flex: 2,
                                    child: SmoothStarRating(
                                          allowHalfRating: true,
                                          onRated: (v) {},
                                          starCount: 5,
                                          rating: allRatings[index].rating.toDouble() ,
                                          size: 20.0,
                                          isReadOnly: true,
                                          filledIconData: Icons.star,
                                          halfFilledIconData: Icons.star_half,
                                          color: Colors.deepPurple,
                                          borderColor: Colors.deepPurple,
                                          spacing: 0.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                  },
                  itemCount: (allRatings == null) ? 1 : allRatings.length,
                ),
                SizedBox(height: 80,) 
              ],
            )));
  }
}
