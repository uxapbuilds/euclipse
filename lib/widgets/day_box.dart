import 'package:euclipse/constants/colors.dart';
import 'package:flutter/material.dart';

class DayBox extends StatelessWidget {
  const DayBox({Key? key, this.title = '', this.isSelected = false})
      : super(key: key);
  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 55,
      width: 50,
      margin: const EdgeInsets.only(right: 6, top: 10, bottom: 10, left: 4),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : white,
        border:
            Border.all(width: 1.2, color: isSelected ? primaryColor : white),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 4,
              spreadRadius: .2)
        ],
      ),
      child: Center(
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 16, color: isSelected ? white : black)),
      ),
    );
  }
}
