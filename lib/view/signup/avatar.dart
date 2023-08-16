import 'dart:developer';
import 'dart:io';
import 'package:euclipse/bloc/home_cubit/home_cubit.dart';
import 'package:euclipse/bloc/user_register_bloc/user_register_bloc.dart';
import 'package:euclipse/constants/colors.dart';
import 'package:euclipse/constants/layout_constants.dart';
import 'package:euclipse/constants/strings.dart';
import 'package:euclipse/utility/navigator.dart';
import 'package:euclipse/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/widgets.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar(
      {this.canEdit = true,
      this.pfpPath = '',
      this.radius = 52,
      this.inEdit = false,
      Key? key})
      : super(key: key);

  final bool canEdit;
  final String pfpPath;
  final bool inEdit;
  final double radius;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  late String pfpURL;
  XFile? imageXfile;
  late UserRegisterBloc _userRegisterBloc;
  late HomeCubit _homeCubit;
  @override
  void initState() {
    super.initState();
    _userRegisterBloc =
        BlocProvider.of<UserRegisterBloc>(context, listen: false);
    _homeCubit = BlocProvider.of<HomeCubit>(context, listen: false);
    pfpURL = widget.pfpPath;
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant UserAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    pfpURL = _homeCubit.userData.pfpPath;
  }

  void getImagePicker(ImageSource source) async {
    if (await requestPermission(Permission.manageExternalStorage)) {
      if (await requestPermission(source == ImageSource.camera
          ? Permission.camera
          : Permission.storage)) {
        imageXfile = await ImagePicker().pickImage(source: source);
        if (imageXfile != null && imageXfile!.path.isNotEmpty) {
          pfpURL = imageXfile!.path.toString();
          if (widget.inEdit) {
            _homeCubit.userData.pfpPath = pfpURL.trim();
          } else {
            _userRegisterBloc.add(SetProfilePicture(pfpURL.trim()));
          }
          Navigate().popView(context);
        }
        _updateState();
      }
    }
  }

  void removePfp() {
    pfpURL = '';
    _userRegisterBloc.add(SetProfilePicture(''));
    _homeCubit.userData.pfpPath = '';
    Navigate().popView(context);
    _updateState();
  }

  dynamic getBackground() {
    if (pfpURL.isEmpty) {
      return const AssetImage(
        NO_USER_IMAGE,
      );
    } else {
      return FileImage(File(pfpURL));
    }
  }

  void showImageSelectionSheet() {
    showCustomBottomSheet(context, bottomImageSelection());
  }

  Widget bottomImageSelection() {
    return SizedBox(
      height: 115,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageSelectButton(
              context,
              Icon(Icons.image_outlined, size: 26, color: primaryColor),
              'Gallery',
              () => getImagePicker(ImageSource.gallery)),
          const SizedBox(
            width: 30,
          ),
          vMargin(height: 40),
          const SizedBox(
            width: 30,
          ),
          imageSelectButton(
              context,
              Icon(
                Icons.camera_alt,
                size: 26,
                color: primaryColor,
              ),
              'Camera',
              () => getImagePicker(ImageSource.camera)),
          // const Spacer(),
          const SizedBox(
            width: 30,
          ),
          vMargin(height: 40),
          const SizedBox(
            width: 30,
          ),
          imageSelectButton(
              context,
              Icon(
                Icons.delete,
                size: 26,
                color: pfpURL.isEmpty ? disabledColor : primaryColor,
              ),
              'Remove',
              () => pfpURL.isEmpty
                  ? makeToast('Can\'t remove what is not there.',
                      doCapitalise: false)
                  : removePfp(),
              isDisabled: pfpURL.isEmpty),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(330)),
          elevation: 5,
          child: Stack(
            children: [
              CircleAvatar(
                backgroundImage: getBackground(),
                radius: widget.radius,
                backgroundColor: const Color.fromARGB(255, 242, 241, 241),
              ),
              if (widget.canEdit)
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: InkWell(
                    onTap: () => showImageSelectionSheet(), //getImagePicker(),
                    child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(330)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          pfpURL.isEmpty ? Icons.add : Icons.edit,
                          size: 19,
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        if (widget.canEdit)
          const SizedBox(
            height: 45,
          )
      ],
    );
  }
}
