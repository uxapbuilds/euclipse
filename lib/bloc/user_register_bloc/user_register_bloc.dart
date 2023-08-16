// ignore_for_file: prefer_final_fields
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:euclipse/models/userProfileData_Model.dart';
import 'package:euclipse/utility/local_data.dart';
import 'package:euclipse/widgets/widgets.dart';
import 'package:meta/meta.dart';

part 'user_register_event.dart';
part 'user_register_state.dart';
/*

  REDUNTANT BLOC, REMOVE LATER

*/

class UserRegisterBloc extends Bloc<UserRegisterEvent, UserRegisterState> {
  String _pfpPath = '';
  String _firstName = '';
  String _lastName = '';
  String _userName = '';
  String _educationFacility = '';
  bool _dataSaved = false;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get profilePicture => _pfpPath;
  String get username => _userName;
  String get educationFacility => _educationFacility;
  bool get isDataSaved => _dataSaved;

  UserRegisterBloc() : super(UserRegisterInitial()) {
    on<UserRegisterEvent>(
      (event, emit) {
        if (event is SetProfilePicture) {
          _pfpPath = event.pfpPath;
        }
        if (event is SetFirstName) {
          _firstName = event.firstname;
        }
        if (event is SetLastName) {
          _lastName = event.lastname;
        }
        if (event is SetUserName) {
          _userName = event.username;
        }
        if (event is SetEducationFacility) {
          _educationFacility = event.educationfrom;
        }
        if (event is SaveUserData) {
          var _userData = UserProfileData(_pfpPath, _firstName, _lastName,
              _userName, _educationFacility, []);
          var _res = LocalData().saveUserProfileData(_userData);
          if (_res == 0) {
            _dataSaved = true;
            makeToast('Done!');
          } else {
            _dataSaved = false;
            makeToast('Error Saving Data');
          }
        }
      },
    );
  }
}
