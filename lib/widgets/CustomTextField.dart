import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final Size deviceSize;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final dynamic fieldFocusChange;
  final int maxLines;

  CustomTextField({
    @required this.controller,
    @required this.labelText,
    @required this.icon,
    this.deviceSize,
    this.focusNode,
    this.nextFocusNode,
    this.fieldFocusChange,
    this.maxLines,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
        bottom: 10,
      ),
      height: deviceSize.height * 0.1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          textInputAction: inputAction,
          focusNode: focusNode,
          onFieldSubmitted: fieldFocusChange,
          autofocus: false,
          keyboardType: inputType,
          maxLines: maxLines,
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: labelText,
            hintStyle: TextStyle(color: Colors.grey),
            focusColor: Theme.of(context).accentColor,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10,
            ),
          ),
        ),
      ),
    );
  }
}
