import 'package:Selfsahaf/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/views/customer_view/main_view/page_classes/main_page/home_page.dart';
import 'package:Selfsahaf/views/customer_view/main_view/page_classes/notification_pages/notifications.dart';
import 'package:Selfsahaf/views/customer_view/main_view/page_classes/search_pages/search_page.dart';
import 'package:Selfsahaf/views/customer_view/profile_pages/profile_page.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/models/book.dart';
import 'package:Selfsahaf/controller/book_controller.dart';

class MainPage extends StatefulWidget {
  final User user;
  MainPage({@required this.user});
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = new ScrollController();
  List<Book> bookList = [null];
  bool _isloading = true;
  int _index = 0;
  int page = 0, size = 4, localpage = 0;
  bool checkPage;
  List<Widget> _pages= [
    HomePage(),
    SearchPage(),
    NotificationsPage(),
    ProfilePage(),
  ];
  AuthService get userService => GetIt.I<AuthService>();
  BookService get _bookService => GetIt.I<BookService>();

  bool _loading = true;
  @override
  void initState() {
    print(widget.user.name);
      userService.setUser(widget.user);
    _index=0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffe65100),
            ),
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(top:5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      InkWell(
                        child: _index == 0
                            ? Icon(
                                Icons.home,
                                size: 35,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.home,
                                size: 30,
                                color: Colors.white,
                              ),
                        onTap: () {
                          _changeIndex(0);
                        },
                      ),
                      _index == 0
                          ? Text(
                              "Home",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold,color: Colors.white),
                            )
                          : SizedBox(),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      InkWell(
                        child: _index == 1
                            ? Icon(
                                Icons.search,
                                size: 25,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.search,
                                size: 30,
                                color: Colors.white,
                              ),
                        onTap: () {
                          _changeIndex(1);
                        },
                      ),
                      _index == 1
                          ? Text(
                              "Search",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold,color: Colors.white),
                            )
                          : SizedBox(),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      InkWell(
                        child: _index == 2
                            ? Icon(
                                Icons.favorite,
                                size: 25,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.favorite_border,
                                size: 30,
                                color: Colors.white,
                              ),
                        onTap: () {
                          _changeIndex(2);
                        },
                      ),
                      _index == 2
                          ? Text(
                              "Hotlist",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold,color: Colors.white),
                            )
                          : SizedBox(),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      InkWell(
                        child: _index == 3
                            ? Icon(
                                Icons.person,
                                size: 25,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.person_outline,
                                size: 30,
                                color: Colors.white,
                              ),
                        onTap: () {
                          _changeIndex(3);
                        },
                      ),
                      _index == 3
                          ? Text(
                              "Profile",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold,color: Colors.white),
                            )
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        
        
        body: _pages[_index],);
  }

  _changeIndex(int i) {
    _index = i;
    setState(() {});
  }
}