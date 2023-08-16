import 'package:euclipse/constants/colors.dart';
import 'package:euclipse/constants/layout_constants.dart';
import 'package:euclipse/constants/strings.dart';
import 'package:flutter/material.dart';

class OnboardingPageLayout extends StatelessWidget {
  const OnboardingPageLayout(
    this.title,
    this.description,
    this.asset,
    this.index, {
    Key? key,
  }) : super(key: key);
  final String title;
  final String description;
  final List<String> asset;
  final int index;

  Widget multiImage(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              asset[0],
              height: mediaQuery.height * 0.18,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              asset[1],
              height: mediaQuery.height * 0.18,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              asset[2],
              height: mediaQuery.height * 0.18,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      color: Colors.black.withOpacity(.03),
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                asset[0],
                height: mediaQuery.height * .75,
              ),
            ),
          ]),
    );
  }
}
