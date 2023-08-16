import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {required this.textController,
      this.hintText = '',
      required this.labelText,
      this.margin = 0,
      required this.prefixIcon,
      this.done = false,
      this.maxLines = 1,
      this.onChange,
      this.readOnly = false,
      this.onTap,
      Key? key})
      : super(key: key);
  final TextEditingController textController;
  final String hintText;
  final String labelText;
  final double margin;
  final Widget prefixIcon;
  final bool done;
  final int maxLines;
  final Function(String)? onChange;
  final Function()? onTap;
  final bool readOnly;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final OutlineInputBorder _borderAll = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: white, width: 0.0),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: primaryColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.2),
                blurRadius: 4,
                spreadRadius: .2)
          ]),
      margin: EdgeInsets.symmetric(horizontal: widget.margin),
      child: TextFormField(
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        onChanged: widget.onChange,
        maxLines: widget.maxLines,
        textInputAction:
            widget.done ? TextInputAction.done : TextInputAction.next,
        autofocus: false,
        controller: widget.textController,
        decoration: InputDecoration(
            filled: true,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            fillColor: Colors.white,
            labelText: widget.labelText,
            labelStyle: Theme.of(context).textTheme.headline2!.copyWith(
                backgroundColor: white,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 15),
            enabledBorder: _borderAll,
            focusedBorder: _borderAll,
            border: _borderAll),
      ),
    );
  }
}
