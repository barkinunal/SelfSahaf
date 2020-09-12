import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextInputType inputType;
  final int lines;
  final String labelText;
  final Icon suffixIcon;
  final bool isPassword;
  final TextEditingController controller;
  final Function validation;
  final String initval;

  InputField(
      {this.inputType=TextInputType.text,
      this.initval,
      this.lines,
      @required this.controller,
      this.labelText,
      this.suffixIcon,
      this.isPassword = false,
      @required this.validation});

  @override
  State<StatefulWidget> createState() {
    return _InputFieldState();
  }
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initval,
      controller: widget.controller,
      validator: widget.validation,
      cursorColor: Colors.orange,
      keyboardType: widget.inputType,
      obscureText: widget.isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        errorStyle: TextStyle(
          color: Colors.white
        ),
        
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        labelText: widget.labelText,
        suffixIcon: widget.suffixIcon,
        labelStyle: TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
            gapPadding: 2.0,
            borderSide: BorderSide(color: Colors.white, width: 3.0),
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
            color:Colors.deepPurple,
            width: 3.0,
          ),
        ),
        focusedErrorBorder: new OutlineInputBorder(
          gapPadding: 2.0,
          borderRadius: new BorderRadius.circular(16.0),
          borderSide: new BorderSide(
            color:Colors.deepPurple,
            width: 3.0,
          ),
        )
      ),
    );
  }
}
