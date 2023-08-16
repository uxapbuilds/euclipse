// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:euclipse/bloc/user_register_bloc/user_register_bloc.dart';
import 'package:euclipse/constants/colors.dart';
import 'package:euclipse/constants/layout_constants.dart';
import 'package:euclipse/constants/strings.dart';
import 'package:euclipse/utility/navigator.dart';
import 'package:euclipse/view/signup/avatar.dart';
import 'package:euclipse/view/time_table_gen/generate_time_table.dart';
import 'package:euclipse/widgets/customtextfield.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../bloc/home_cubit/home_cubit.dart';
import '../../utility/local_data.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({this.isEdit = false, Key? key}) : super(key: key);
  final bool isEdit;
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late UserRegisterBloc _userRegisterBloc;
  late HomeCubit _homeCubit;
  late bool isEdit;

  List<TextEditingController> textControllers =
      signupFields.map((_) => TextEditingController()).toList();
  String pfpPath = '';

  @override
  void initState() {
    super.initState();
    _userRegisterBloc =
        BlocProvider.of<UserRegisterBloc>(context, listen: false);
    _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
    isEdit = widget.isEdit;
    if (isEdit) {
      preLoadTextController();
    }
  }

  void preLoadTextController() {
    var _userData = _homeCubit.userData;
    // ignore: unnecessary_null_comparison
    if (_userData != null) {
      textControllers[0].text = _userData.firstName;
      textControllers[1].text = _userData.lastName;
      textControllers[2].text = _userData.userName;
      textControllers[3].text = _userData.educationFacility;
      pfpPath = _userData.pfpPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var mediaQuery = MediaQuery.of(context);
    double _margin = 2;
    bool doValidate() {
      if (textControllers[0].text.isEmpty) {
        makeToast('please enter first name', doCapitalise: false);
        return false;
      } else if (textControllers[1].text.isEmpty) {
        makeToast('please enter last name', doCapitalise: false);
        return false;
      } else if (textControllers[2].text.isEmpty) {
        makeToast('please enter user name', doCapitalise: false);
        return false;
      } else if (textControllers[3].text.isEmpty) {
        makeToast('please enter school/University', doCapitalise: false);
        return false;
      }
      return true;
    }

    void saveUserData() {
      if (doValidate()) {
        _homeCubit.userData.firstName = textControllers[0].text.trim();
        _homeCubit.userData.lastName = textControllers[1].text.trim();
        _homeCubit.userData.userName = textControllers[2].text.trim();
        _homeCubit.userData.educationFacility = textControllers[3].text.trim();
        _homeCubit.updateUserInfo();
        _homeCubit.getUserData();
        if (!isEdit) {
          // _userRegisterBloc.add(SetFirstName(textControllers[0].text.trim()));
          // _userRegisterBloc.add(SetLastName(textControllers[1].text.trim()));
          // _userRegisterBloc.add(SetUserName(textControllers[2].text.trim()));
          // _userRegisterBloc
          //     .add(SetEducationFacility(textControllers[3].text.trim()));
          // _userRegisterBloc.add(SaveUserData());
          LocalData().updateInitUserStatus(status: 'gen_time_table');
          Navigate().navigate(const TimeTableGen(), context);
        } else {
          // _homeCubit.userData.firstName = textControllers[0].text.trim();
          // _homeCubit.userData.lastName = textControllers[1].text.trim();
          // _homeCubit.userData.userName = textControllers[2].text.trim();
          // _homeCubit.userData.educationFacility =
          //     textControllers[3].text.trim();
          // _homeCubit.updateUserInfo();
          // _homeCubit.getUserData();
          Navigate().popView(context);
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: white,
      body: Padding(
        padding: EdgeInsets.only(top: mediaQuery.padding.top),
        child: Stack(
          children: [
            // SvgPicture.asset(
            //   BACKGROUND_A1,
            //   fit: BoxFit.cover,
            // ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: mediaQuery.padding.top,
                    ),
                    Container(
                        alignment: Alignment.bottomLeft,
                        width: double.infinity,
                        child: UserAvatar(
                          inEdit: true,
                          pfpPath: pfpPath,
                        )),
                    Container(
                      padding: const EdgeInsets.only(left: 4),
                      width: double.infinity,
                      child: Text(
                        !isEdit ? 'Here is your\nfirst step.' : 'Edit Profile',
                        style: textTheme.headline1!.copyWith(fontSize: 32),
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    CustomTextField(
                        onChange: (_) {},
                        prefixIcon: const Icon(Icons.person_outline_sharp),
                        margin: _margin,
                        textController: textControllers[0],
                        labelText: signupFields[0]),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                        onChange: (_) {},
                        prefixIcon: const Icon(Icons.person_outline_sharp),
                        margin: _margin,
                        textController: textControllers[1],
                        labelText: signupFields[1]),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                        onChange: (_) {},
                        prefixIcon: const Icon(Icons.text_fields),
                        margin: _margin,
                        textController: textControllers[2],
                        labelText: signupFields[2]),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                        onChange: (_) {},
                        done: true,
                        prefixIcon: const Icon(Icons.school),
                        margin: _margin,
                        textController: textControllers[3],
                        labelText: signupFields[3]),
                    const SizedBox(
                      height: 22,
                    ),
                    Container(
                      height: .4,
                      width: 300, //MediaQuery.of(context).size.width - 140,
                      decoration: BoxDecoration(
                          border: Border.all(width: .5),
                          color: Colors.black.withOpacity(.2)),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: primaryColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.2),
                                blurRadius: 4,
                                spreadRadius: .2)
                          ]),
                      width: MediaQuery.of(context).size.width - 52 + _margin,
                      height: 55,
                      child: InkWell(
                        onTap: () => saveUserData(),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  !isEdit ? 'continue.' : 'save.',
                                  style: TextStyle(
                                      color: white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              height: double.infinity,
                              color: const Color.fromARGB(255, 60, 60, 60)
                                  .withOpacity(.01),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(Icons.arrow_right_alt_rounded,
                                  color: white),
                            )
                          ],
                        ),
                      ),
                    ),
                    // ),
                    const SizedBox(
                      height: 22,
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
                visible: isEdit,
                child: Positioned(
                  top: mediaQuery.padding.top + 20,
                  left: 20,
                  child: InkWell(
                    onTap: () {
                      Navigate().popView(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: black,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
