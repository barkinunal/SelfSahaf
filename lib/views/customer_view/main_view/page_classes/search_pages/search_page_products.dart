import 'package:Selfsahaf/controller/search_service.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import "package:Selfsahaf/models/book.dart";
import 'package:Selfsahaf/views/customer_view/products_pages/book_profile.dart';
import 'package:Selfsahaf/views/customer_view/products_pages/product_card.dart';

class SearchPageProducts extends StatefulWidget {
  final int type; //0 for search by category
  //1 for search by isbn
  //2 for search by language
  //3 for search by bookName
  //4 for search by price range
  String searchValue;
  double to, from;
  SearchPageProducts(
      {@required this.type, this.searchValue, this.to, this.from});

  @override
  _SearchPageProductsState createState() => _SearchPageProductsState();
}

class _SearchPageProductsState extends State<SearchPageProducts> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  SearchService get _searchService => GetIt.I<SearchService>();

  int page = 0, size = 8, localpage = 0;
  List<Book> bookList;
      List<Book> newbooks;
  bool _isloading = true;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    print(widget.searchValue);
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


    switch (widget.type) {
      case 0:
        _searchService
            .searchBookByCategory(widget.searchValue, page, size)
            .then((e) {
          if (!e.error) {
            setState(() {
              newbooks = e.data;
            });
          } else {
            setState(() {
              newbooks = e.data;
              ErrorDialog().showErrorDialog(context, "Error", e.errorMessage);
            });
          }
        });
        break;
      case 1:
        _searchService
            .searchBookByISBN(widget.searchValue, page, size)
            .then((e) {
          if (!e.error) {
            setState(() {
              newbooks = e.data;
            });
          } else {
            setState(() {
              newbooks = e.data;
              ErrorDialog().showErrorDialog(context, "Error", e.errorMessage);
            });
          }
        });
        break;
      case 2:
        _searchService
            .searchBookByLanguage(widget.searchValue, page, size)
            .then((e) {
          if (!e.error) {
            setState(() {
              newbooks = e.data;
            });
          } else {
            setState(() {
              newbooks = e.data;
              ErrorDialog().showErrorDialog(context, "Error", e.errorMessage);
            });
          }
        });
        break;
      case 3:
        _searchService
            .searchBooksByName(widget.searchValue, page, size)
            .then((e) {
          if (!e.error) {
            print(e.data);
            setState(() {
              newbooks = e.data;
            });
          } else {
            setState(() {
              newbooks = e.data;
              ErrorDialog().showErrorDialog(context, "Error", e.errorMessage);
            });
          }
        });
        break;
      case 4:
        _searchService
            .searchBookByPriceRange(widget.to, widget.from, page, size)
            .then((e) {
          if (!e.error) {
            setState(() {
              newbooks = e.data;
            });
          } else {
            setState(() {
              newbooks = e.data;
              ErrorDialog().showErrorDialog(context, "Error", e.errorMessage);
            });
          }
        });
        break;
      default:
    }

    if (newbooks != null) {

      setState(() {
        if (newbooks.length == 0) {
          print("sa");
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
  }

  _fetchData() async {
    _refresh();
  }

  Future<Null> _refresh() {
    setState(() {
      _isloading = true;
    });
    switch (widget.type) {
      case 0:
        return _searchService
            .searchBookByCategory(widget.searchValue, 0, size)
            .then((e) {
          if (!e.error) {
            if (e.data != null) {
              setState(() {
                if (e.data.length % size == 0)
                  page = 1;
                else
                  page = 0;

                this.bookList = e.data;

                _isloading = false;
              });
            } else
              setState(() {
                this.bookList = e.data;
                _isloading = false;
              });
          } else {
            setState(() {
              bookList = e.data;
              return ErrorDialog()
                  .showErrorDialog(context, "Error", e.errorMessage);
            });
          }
        });
        break;
      case 1:
        return _searchService
            .searchBookByISBN(widget.searchValue, 0, size)
            .then((e) {
          if (!e.error) {
            if (e.data != null) {
              setState(() {
                if (e.data.length % size == 0)
                  page = 1;
                else
                  page = 0;

                this.bookList = e.data;

                _isloading = false;
              });
            } else
              setState(() {
                this.bookList = e.data;
                _isloading = false;
              });
          } else {
            setState(() {
              bookList = e.data;
              return ErrorDialog()
                  .showErrorDialog(context, "Error", e.errorMessage);
            });
          }
        });
        break;
      case 2:
        return _searchService
            .searchBookByLanguage(widget.searchValue, 0, size)
            .then((e) {
          if (!e.error) {
            if (e.data != null) {
              setState(() {
                if (e.data.length % size == 0)
                  page = 1;
                else
                  page = 0;

                this.bookList = e.data;

                _isloading = false;
              });
            } else
              setState(() {
                this.bookList = e.data;
                _isloading = false;
              });
          } else {
            setState(() {
              bookList = e.data;
              return ErrorDialog()
                  .showErrorDialog(context, "Error", e.errorMessage);
            });
          }
        });
        break;
      case 3:
        return _searchService
            .searchBooksByName(widget.searchValue, 0, size)
            .then((e) {
          if (!e.error) {
            if (e.data != null) {
              setState(() {
                if (e.data.length % size == 0)
                  page = 1;
                else
                  page = 0;

                this.bookList = e.data;

                _isloading = false;
              });
            } else
              setState(() {
                this.bookList = e.data;
                _isloading = false;
              });
          } else {
            setState(() {
              bookList = e.data;
              return ErrorDialog()
                  .showErrorDialog(context, "Error", e.errorMessage);
            });
          }
        });
        break;
      case 4:
        return _searchService
            .searchBookByPriceRange(widget.to, widget.from, 0, size)
            .then((e) {
          if (!e.error) {
            if (e.data != null) {
              setState(() {
                if (e.data.length % size == 0)
                  page = 1;
                else
                  page = 0;

                this.bookList = e.data;

                _isloading = false;
              });
            } else
              setState(() {
                this.bookList = e.data;
                _isloading = false;
              });
          } else {
            setState(() {
              bookList = e.data;
              return ErrorDialog()
                  .showErrorDialog(context, "Error", e.errorMessage);
            });
          }
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 13,
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
              height: 50,
              child: Image.asset("images/logo_white/logo_white.png")),
        ),
        body: Container(
            color: Color(0xffe65100),
            padding: const EdgeInsets.all(16.0),
            child: RefreshIndicator(
              onRefresh: () => _refresh(),
              key: _refreshIndicatorKey,
              child: ListView(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      if (bookList == null) {
                        return Padding(
                          padding: const EdgeInsets.all(35.0),
                          child: Center(
                              child: Text(
                            "No Books Found",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          )),
                        );
                      } else {
                        return Dismissible(
                          key: ValueKey(bookList[index].productID),
                          child: ProductCard(
                            bookName: bookList[index].name,
                            authorName: bookList[index].authorName,
                            publisherName: bookList[index].publisher,
                            price: bookList[index].price,
                            productID: bookList[index].productID,
                            sellerID: bookList[index].sellerID,
                            type: 0,
                            discount: bookList[index].discount,
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            print("sa");
                          },
                          confirmDismiss: (direction) async {
                            //right to left for information
                            if (direction == DismissDirection.endToStart) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookProfile(
                                            selectedBook: bookList[index],
                                            type: 1,
                                          )));

                              return false;
                            }
                          },
                          //sağdan sola
                          secondaryBackground: Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.all(8),
                              child: Align(
                                  child: Icon(Icons.edit,
                                      color: Colors.white, size: 50),
                                  alignment: Alignment.centerRight),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                          //soldan sağa
                          background: Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.only(left: 16),
                            child: Align(
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 50,
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        );
                      }
                    },
                    itemCount: (bookList == null) ? 1 : bookList.length,
                  ),
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
            )));
  }
}
