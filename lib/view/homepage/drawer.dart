// ignore_for_file: prefer_const_constructors

import 'package:euclipse/constants/colors.dart';
import 'package:euclipse/utility/navigator.dart';
import 'package:euclipse/view/homepage/my_info_card.dart';
import 'package:euclipse/view/signup/signup_page.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/strings.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Widget _listTile(String title, Icon icon, Function onPress) {
    return ListTile(
      title: Row(
        children: [
          icon,
          const SizedBox(
            width: 12,
          ),
          Text(title),
        ],
      ),
      onTap: () => onPress(),
    );
  }

  Widget _companyInfoHeader(BuildContext context) {
    var _textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          'Built by',
          style: _textTheme.headline2!.copyWith(
            fontSize: 13,
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'UX',
                style: _textTheme.headline1!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              TextSpan(
                text: 'AP',
                style: _textTheme.headline1!.copyWith(
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () async {
            Uri _gitUrl = Uri.parse(myGitUrl);
            if (await canLaunchUrl(_gitUrl)) {
              await launchUrl(_gitUrl,
                  mode: LaunchMode.externalApplication,
                  webOnlyWindowName: 'GIT');
            } else {
              throw "Could not launch $_gitUrl";
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                color: black.withOpacity(.1)),
            child: Text(
              myGitUrl,
              style: _textTheme.headline2!.copyWith(
                fontSize: 12,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('v$appVersion',
                style: _textTheme.headline2!.copyWith(
                  fontSize: 12,
                )),
          ],
        ),
      ],
    );
  }

  Widget _drawerHeader(BuildContext context) {
    return MyInfoCard();
  }

  Widget _timeDate(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        // analogClock(),
        const SizedBox(
          height: 20,
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 90),
            child: currentDateContainer(context)),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: secondaryColor),
              child: SizedBox(
                  height: _mediaQuery.height * .2,
                  child: _drawerHeader(context)) //_companyInfoHeader(context)),
              ),
          _timeDate(context),
          hMargin(),
          const SizedBox(
            height: 4,
          ),
          _listTile('Edit Profile', const Icon(Icons.edit), () {
            Navigate().navigate(
                const SignupPage(
                  isEdit: true,
                ), //make it editable
                context);
          }),
          _listTile('Summary', const Icon(Icons.summarize), () {}),
          _listTile(
              'Calendar', const Icon(Icons.calendar_today_outlined), () {}),
          _listTile(
              'Time Table', const Icon(Icons.table_chart_outlined), () {}),
          hMargin(),
          _companyInfoHeader(context),
        ],
      ),
    );
  }
}
