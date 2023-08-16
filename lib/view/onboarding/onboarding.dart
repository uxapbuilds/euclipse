import 'package:euclipse/constants/colors.dart';
import 'package:euclipse/constants/strings.dart';
import 'package:euclipse/utility/local_data.dart';
import 'package:euclipse/utility/navigator.dart';
import 'package:euclipse/view/onboarding/onboarding_layout.dart';
import 'package:euclipse/view/signup/signup_page.dart';
import 'package:flutter/material.dart';

class Onboarder extends StatefulWidget {
  const Onboarder({Key? key}) : super(key: key);

  @override
  State<Onboarder> createState() => _OnboarderState();
}

class _OnboarderState extends State<Onboarder> {
  int pageNumber = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
              // scrollDirection: Axis.vertical,
              controller: _pageController,
              onPageChanged: (value) => setState(() {
                    pageNumber = value;
                  }),
              children: onboadingData
                  .map((page) => OnboardingPageLayout(page['title'] as String,
                      page['desc'] as String, page['asset'], pageNumber))
                  .toList()),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Material(
                  color: white,
                  borderRadius: BorderRadius.circular(18),
                  elevation: 9,
                  child: SizedBox(
                    height: mediaQuery.height * .32,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * .03,
                          horizontal: 24),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: Text(
                                onboadingData[pageNumber]['title'] ?? '',
                                textAlign: TextAlign.center,
                                style: textTheme.headline1!
                                    .copyWith(fontSize: 24, color: black),
                              ),
                            ),
                            SizedBox(
                              height: mediaQuery.height * .0,
                            ),
                            SizedBox(
                              height: 50,
                              width: mediaQuery.width * .8,
                              child: Text(
                                onboadingData[pageNumber]['desc'] ?? '',
                                textAlign: TextAlign.center,
                                style: textTheme.headline1!.copyWith(
                                    fontSize: 13,
                                    color: black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            InkWell(
                              highlightColor: Colors.transparent,
                              onTap: () {
                                _pageController.nextPage(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.fastOutSlowIn);
                                if (pageNumber == onboadingData.length - 1) {
                                  LocalData()
                                      .updateInitUserStatus(status: 'signup');
                                  Navigate().navigateAndRemoveUntil(
                                      const SignupPage(), context);
                                }
                              },
                              child: AnimatedCrossFade(
                                firstCurve: Curves.fastOutSlowIn,
                                secondCurve: Curves.fastOutSlowIn,
                                duration: const Duration(milliseconds: 300),
                                reverseDuration:
                                    const Duration(milliseconds: 300),
                                firstChild: Container(
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * .05,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 104),
                                  child: Center(
                                    child: Text(
                                      'get started.',
                                      style: TextStyle(
                                          color: white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                secondChild: Container(
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * .05,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 104),
                                  child: Center(
                                    child: Text(
                                      'continue.',
                                      style: TextStyle(
                                          color: white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                crossFadeState:
                                    onboadingData.length - 1 == pageNumber
                                        ? CrossFadeState.showFirst
                                        : CrossFadeState.showSecond,
                              ),
                            ),
                            SizedBox(
                              height: mediaQuery.height * .02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: onboadingData.asMap().entries.map((e) {
                                return Row(
                                  children: [
                                    Container(
                                      color: pageNumber >= e.key
                                          ? primaryColor
                                          : Colors.grey.withOpacity(.5),
                                      width: 50,
                                      height: 1.4,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    )
                                  ],
                                );
                              }).toList(),
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
