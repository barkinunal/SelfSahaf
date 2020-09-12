import 'package:Selfsahaf/controller/mail_service.dart';
import 'package:Selfsahaf/models/user.dart';
import 'package:Selfsahaf/views/errors/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AdminMailPage extends StatefulWidget {
  bool everyone;
  User user;
  AdminMailPage({@required this.user,@required this.everyone});
  @override
  _AdminMailPageState createState() => _AdminMailPageState();
}

class _AdminMailPageState extends State<AdminMailPage> {
  final _mailKey = GlobalKey<FormState>();
  MailService mailService = GetIt.I<MailService>();
  String mail;
  bool error = false;
  String errorMessage;
  String popMessage;

  
  _sendEveryone(String content, String title){
    mailService.sendEmailToAllUsers(content,title).then((value) {
      if (!value.error) {
        popMessage = "Mails Successfully Sent";
        
        return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Success!",style: TextStyle(color: Colors.white),),
            content: Text(popMessage,style: TextStyle(color: Colors.white)),
            actions: <Widget>[
              FlatButton(
                child: Text("OK!", style: TextStyle(color: Colors.white),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
          }
        ).then((value) => Navigator.pop(context));
      } else {
        setState(() {
          error = true;
          errorMessage = value.errorMessage;
        });
        ErrorDialog().showErrorDialog(context, "Error", value.errorMessage);
        print(value.errorMessage);
      }
    });
  }
  _sendMail(String content, String mail, String title) {
    mailService.sendEmailToUser(content, mail, title).then((value) {
      if (!value.error) {
        popMessage = "Mail Successfully Sent";

        return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Success!",style: TextStyle(color: Colors.white),),
            content: Text(popMessage,style: TextStyle(color: Colors.white)),
            actions: <Widget>[
              FlatButton(
                child: Text("OK!", style: TextStyle(color: Colors.white),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
          }
        ).then((value) => Navigator.pop(context));
      } else {
        setState(() {
          error = true;
          errorMessage = value.errorMessage;
        });
        ErrorDialog().showErrorDialog(context, "Error", value.errorMessage);
        print(value.errorMessage);
      }
    });
  }

  User user;
  String mailcontentValidation(String content) {
    if (content.length < 60) {
      return "Please explain to customer in detail.";
    } else
      return null;
  }

  String mailtitleValidation(String title) {
    if (title.length < 10) {
      return "Please use formal language to customers.";
    } else
      return null;
  }

  final _mailcontentController = TextEditingController();
  final _mailtitleController = TextEditingController();

  @override
  void initState() {
    this.mail = widget.user.email;
    this.user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
            height: 50, child: Image.asset("images/logo_white/logo_white.png")),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Form(
          key: _mailKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Container(
                    child: Center(
                      child: (widget.everyone) ? Text(
                        "Send Mail To Everyone",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      )
                      :
                      Text(
                        "Send Mail To: " +
                            widget.user.name +
                            " " +
                            widget.user.surname,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1.5,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    maxLines: 2,
                    controller: _mailtitleController,
                    validator: mailtitleValidation,
                    cursorColor: Colors.orange,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.white),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        labelText: "Mail Title",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            gapPadding: 2.0,
                            borderSide:
                                BorderSide(color: Colors.white, width: 3.0),
                            borderRadius: new BorderRadius.circular(16.0)),
                        enabledBorder: new OutlineInputBorder(
                          gapPadding: 2.0,
                          borderRadius: new BorderRadius.circular(16.0),
                          borderSide: new BorderSide(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        errorBorder: new OutlineInputBorder(
                          gapPadding: 2.0,
                          borderRadius: new BorderRadius.circular(16.0),
                          borderSide: new BorderSide(
                            color: Colors.deepPurple,
                            width: 3.0,
                          ),
                        ),
                        focusedErrorBorder: new OutlineInputBorder(
                          gapPadding: 2.0,
                          borderRadius: new BorderRadius.circular(16.0),
                          borderSide: new BorderSide(
                            color: Colors.deepPurple,
                            width: 3.0,
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    maxLines: 10,
                    controller: _mailcontentController,
                    validator: mailcontentValidation,
                    cursorColor: Colors.orange,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.white),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        labelText: "Mail Content",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            gapPadding: 2.0,
                            borderSide:
                                BorderSide(color: Colors.white, width: 3.0),
                            borderRadius: new BorderRadius.circular(16.0)),
                        enabledBorder: new OutlineInputBorder(
                          gapPadding: 2.0,
                          borderRadius: new BorderRadius.circular(16.0),
                          borderSide: new BorderSide(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        errorBorder: new OutlineInputBorder(
                          gapPadding: 2.0,
                          borderRadius: new BorderRadius.circular(16.0),
                          borderSide: new BorderSide(
                            color: Colors.deepPurple,
                            width: 3.0,
                          ),
                        ),
                        focusedErrorBorder: new OutlineInputBorder(
                          gapPadding: 2.0,
                          borderRadius: new BorderRadius.circular(16.0),
                          borderSide: new BorderSide(
                            color: Colors.deepPurple,
                            width: 3.0,
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "Send Mail",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    if(widget.everyone){
                      if (_mailKey.currentState.validate()) {
                      _sendEveryone(_mailcontentController.text, _mailtitleController.text);
                    }
                    }
                    else{
                      if (_mailKey.currentState.validate()) {
                      _sendMail(_mailcontentController.text, widget.user.email, _mailtitleController.text);
                    }
                    }
                    
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
