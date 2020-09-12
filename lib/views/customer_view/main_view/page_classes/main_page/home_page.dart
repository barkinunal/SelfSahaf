import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/controller/book_controller.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'package:Selfsahaf/models/book.dart';
import 'package:Selfsahaf/views/customer_view/main_view/page_classes/main_page/book_card.dart';
import 'package:Selfsahaf/views/customer_view/main_view/page_classes/main_page/home_page_carousel.dart';
import 'package:Selfsahaf/views/customer_view/main_view/page_classes/main_page/sahaf_drawer.dart';
import 'package:Selfsahaf/views/customer_view/shopping_cart/shopping_cart.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = new ScrollController();
  List<Book> bookList = [null];
  bool _isloading = true;
  int _index = 0;
  int page = 0, size = 8, localpage = 0;
  bool checkPage;
  String sortBy = "productID"; //ascending//currentPrice
  List<Widget> _pages;
  AuthService get userService => GetIt.I<AuthService>();
  BookService get _bookService => GetIt.I<BookService>();
bool increasing=true;
  bool _loading = true;

  @override
  void initState() {
    _fetchData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() async {
    setState(() {
      _isloading = true;
    });

    print("page: $page");
    List<Book> newbooks;
    newbooks = await _bookService.getBooks(page, size, increasing,  sortBy);
    setState(() {
      if (newbooks.length == 0) {
        _isloading = false;
        return;
      } else if (bookList.length % size != 0 || newbooks.length != size) {
        for (int i = (bookList.length % size); i < newbooks.length; i++) {
          bookList.add(newbooks[i]);
        }
        if (newbooks.length == size) page += 1;
      } else if (bookList.length % size == 0 &&
          newbooks.length == size &&
          (bookList[bookList.length - 1].productID !=
              newbooks[size - 1].productID)) {
        print("salam");
        bookList.addAll(newbooks);
        page = page + 1;
      }

      _isloading = false;
    });
  }

  _fetchData() async {
    _refresh().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  Future<Null> _refresh() {
    setState(() {
      _isloading = true;
    });
    return _bookService.getBooks(0, size,increasing, sortBy).then((e) {
      setState(() {
        if (e.length % size == 0)
          page = 1;
        else
          page = 0;

        this.bookList = e;
  
        _isloading = false;
      });
      print(bookList.length);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
       floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
            child: Icon(
              Icons.lightbulb_outline,
              color: Color(0xffe65100),
            ),
         onPressed: (){
         showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20))),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffe65100),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.8),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ListView(
                        children: <Widget>[
                         Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 10,
                                      child: Text(
                                        "Filter",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 24),
                                      )),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Color(0xffe65100),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          Center(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 5,
                                    child: Text(
                                      "By Price",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      FlatButton(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Text(
                                          "Increasing",
                                          style: TextStyle(
                                              color: Color(0xffe65100)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            sortBy="currentPrice";
                                            increasing=true;
                                              _loading=true;
                                          });
                                        _fetchData();
                                         Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Text(
                                          "Decreasing",
                                          style: TextStyle(
                                              color: Color(0xffe65100)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            sortBy="currentPrice";
                                            increasing=false;
                                              _loading=true;
                                          });
                                        
                                         _fetchData();
                                         Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            color: Colors.white,
                          ),
                          Center(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 5,
                                    child: Text(
                                      "By Date",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      FlatButton(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Text(
                                          "Increasing",
                                          style: TextStyle(
                                              color: Color(0xffe65100)),
                                        ),
                                        onPressed: () {
                                           setState(() {
                                            sortBy="productID";
                                            increasing=true;
                                              _loading=true;
                                          });
                                        _fetchData();
                                         Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Text(
                                          "Decreasing",
                                          style: TextStyle(
                                              color: Color(0xffe65100)),
                                        ),
                                        onPressed: () {
                                         setState(() {
                                            sortBy="productID";
                                            increasing=false;
                                              _loading=true;
                                          });
                                         _fetchData();
                                         Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
       }),
        appBar: AppBar(
          title: Container(
              height: 50,
              child: Image.asset("images/logo_white/logo_white.png")),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  (userService.getUser().role == "ROLE_ANON")
                      ? ErrorDialog().showLogin(context)
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShoppingCart()),
                        );
                }),
          ],
        ),
        drawer: SahafDrawer(),
        body: (_loading)
            ? Container(
                color: Colors.transparent,
                child: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )))
            : RefreshIndicator(
                onRefresh: () => _refresh(),
                key: _refreshIndicatorKey,
                child: ListView(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    HomePageCarousel(),
                    (bookList.length == 0)
                        ? Center(
                            child: Text(
                              "No books on sale",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          )
                        : GridView.builder(
                            physics: ScrollPhysics(),
                            itemCount: bookList.length,
                            shrinkWrap: true,
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return BookCard(book: bookList[index]);
                            }),
                    Container(
                      height: _isloading ? 50.0 : 0,
                      color: Colors.transparent,
                      child: Center(
                        child: new CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}

class FilterFloating extends StatefulWidget {
  @override
  _FilterFloatingState createState() => _FilterFloatingState();
}

class _FilterFloatingState extends State<FilterFloating> {
  bool _show = true;
  @override
  Widget build(BuildContext context) {
    return _show
        ? FloatingActionButton(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.lightbulb_outline,
              color: Color(0xffe65100),
            ),
            onPressed: () {
              var sheetController = showBottomSheet(
                context: context,
                builder: (context) => Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20))),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffe65100),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.8),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ListView(
                        children: <Widget>[
                         Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 10,
                                      child: Text(
                                        "Filtrele",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 24),
                                      )),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Color(0xffe65100),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          Center(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 5,
                                    child: Text(
                                      "By Price",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      FlatButton(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Text(
                                          "Increasing",
                                          style: TextStyle(
                                              color: Color(0xffe65100)),
                                        ),
                                        onPressed: () {
                                          print("BURA DAHA BITMEDI BITER INS");
                                        },
                                      ),
                                      FlatButton(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Text(
                                          "Decreasing",
                                          style: TextStyle(
                                              color: Color(0xffe65100)),
                                        ),
                                        onPressed: () {
                                          print("BURA DAHA BITMEDI BITER INS");
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            color: Colors.white,
                          ),
                          Center(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 5,
                                    child: Text(
                                      "By Alphabet",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      FlatButton(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Text(
                                          "A-Z",
                                          style: TextStyle(
                                              color: Color(0xffe65100)),
                                        ),
                                        onPressed: () {
                                          print("BURA DAHA BITMEDI BITER INS");
                                        },
                                      ),
                                      FlatButton(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Text(
                                          "Z-A",
                                          style: TextStyle(
                                              color: Color(0xffe65100)),
                                        ),
                                        onPressed: () {
                                          print("BURA DAHA BITMEDI BITER INS");
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              _showButton(false);

              sheetController.closed.then((value) {
                _showButton(true);
              });
            },
          )
        : Container();
  }

  void _showButton(bool value) {
    setState(() {
      _show = value;
    });
  }
}
