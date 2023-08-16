import 'dart:io';

import 'package:euclipse/utility/navigator.dart';
import 'package:euclipse/utility/utility.dart';
import 'package:euclipse/view/signup/avatar.dart';
import 'package:euclipse/view/signup/signup_page.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../bloc/home_cubit/home_cubit.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';

class MyInfoCard extends StatelessWidget {
  const MyInfoCard({Key? key}) : super(key: key);
  dynamic getBackground(String pfpURL) {
    if (pfpURL.isEmpty) {
      return const AssetImage(
        NO_USER_IMAGE,
      );
    } else {
      return FileImage(File(pfpURL));
    }
  }

  @override
  Widget build(BuildContext context) {
    var _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
    var _style = Theme.of(context)
        .textTheme
        .headline1!
        .copyWith(fontSize: 38, color: black, fontWeight: FontWeight.normal);

    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onLongPress: () {
                    showDialog(
                        builder: (context) => Dialog(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              child: companyInfoHeader(context),
                            ),
                        context: context);
                  },
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          APP_ICO,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getGreeting() + ',',
                        style: _style.copyWith(
                          fontSize: 22,
                          color: secondaryColor,
                        )),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, snapshot) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * .4),
                            child: Text(_homeCubit.userData.firstName,
                                overflow: TextOverflow.ellipsis,
                                style: _style.copyWith(
                                    fontSize: 28,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold)),
                          );
                        }),
                        const SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () {
                            Navigate().navigate(
                                const SignupPage(
                                  isEdit: true,
                                ),
                                context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: black.withOpacity(.03),
                                shape: BoxShape.circle),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    currentDateContainer(context)
                  ],
                ),
              ],
            ),

            const Spacer(),
            // const SizedBox(
            //   width: 10,
            // ),
            BlocBuilder<HomeCubit, HomeState>(builder: (context, snapshot) {
              return UserAvatar(
                radius: MediaQuery.of(context).size.height * .06,
                pfpPath: _homeCubit.userData.pfpPath,
                canEdit: false,
              );
            }),
            const SizedBox(
              width: 10,
            )
            // analogClock()
          ],
        ),
        // FractionalTranslation(
        //   translation: Offset(MediaQuery.of(context).size.width * .0090,
        //       MediaQuery.of(context).size.width * .0028),
        //   child: Container(
        //       height: 45,
        //       width: 45,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(8),
        //           image: DecorationImage(
        //               fit: BoxFit.cover,
        //               image: getBackground(_homeCubit.userData.pfpPath)))),
        // ),
      ],
    );
  }
}
