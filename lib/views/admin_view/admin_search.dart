import 'package:Selfsahaf/controller/search_service.dart';
import 'package:Selfsahaf/models/user.dart';
import 'package:Selfsahaf/views/admin_view/user_card_for_admin.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

class AdminSearch extends StatefulWidget {
  @override
  _AdminSearchState createState() => new _AdminSearchState();
}

class _AdminSearchState extends State<AdminSearch> {
  SearchService get searchService => GetIt.I<SearchService>();
  TextEditingController _nameController = TextEditingController();
  List<User> users;
  bool _isloading = false;
  _searchUser(String name) async {
    setState(() {
      _isloading = true;
    });
    searchService.searchUserByName(name).then((value) {
      if (!value.error) {
        setState(() {
          users = value.data;
          _isloading = false;
        });
      } else {
        users = value.data;
        _isloading = false;
        ErrorDialog().showErrorDialog(context, "Error!", value.errorMessage);
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    _getUsers();
  }
  _getUsers()async{
    searchService.getAllUsers().then((value) {
  if (!value.error) {
        setState(() {
          users = value.data;
          _isloading = false;
        });
      } else {
        users = value.data;
        _isloading = false;
        ErrorDialog().showErrorDialog(context, "Error!", value.errorMessage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe65100),
        title: TextField(
          controller: _nameController,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              suffixIcon: InkWell(
                  onTap: () {
                    _searchUser(_nameController.text);
                  },
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
              hintText: 'Search...',
              hintStyle: TextStyle(
                color: Colors.white,
              )),
        ),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Color(0xffe65100),
        child: Padding(
            padding: const EdgeInsets.only(
                right: 16.0, left: 16.0, top: 8, bottom: 8),
            child: ListView.builder(
                itemCount:
                    (_isloading) ? 1 : (users == null) ? 1 : users.length,
                itemBuilder: (context, index) {
                  return (_isloading)
                      ? Center(
                          child: Text("Searching...",style: TextStyle(color: Colors.white,fontSize: 25)),
                        )
                      : (users == null)
                          ? Center(
                              child: Text(
                                "No user can found",
                                style: TextStyle(color: Colors.white,fontSize: 25),
                              ),
                            )
                          : Column(
                            children: <Widget>[
                              UserCardForAdmin(user: users[index]),
                              SizedBox(height: 10,)
                            ],
                          );
                })),
      ),
    );
  }
}
