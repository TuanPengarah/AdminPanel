import 'package:flutter/material.dart';

class TextBar extends StatelessWidget {
  TextBar({
    @required this.hintTitle,
    @required this.valueChange,
    @required this.keyType,
    this.controll,
    this.err,
    this.max,
    this.hintEdit,
    @required this.focus,
  });

  final String hintTitle;
  final Function valueChange;
  final TextInputType keyType;
  final String err;
  final TextEditingController controll;
  final int max;
  final String hintEdit;
  final bool focus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextField(
        controller: controll,
        maxLines: max,
        autofocus: focus,
        keyboardType: keyType,
        onChanged: valueChange,
        // textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hintEdit,
          errorText: err,
          labelText: hintTitle,
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              width: 2,
              color: Colors.red,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              width: 2,
              color: Colors.blueGrey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.blueGrey,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
