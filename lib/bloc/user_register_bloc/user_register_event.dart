part of 'user_register_bloc.dart';

@immutable
abstract class UserRegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SetProfilePicture extends UserRegisterEvent {
  SetProfilePicture(this.pfpPath);
  final String pfpPath;
  @override
  List<Object> get props => [pfpPath];
}

class SetFirstName extends UserRegisterEvent {
  SetFirstName(this.firstname);
  final String firstname;
  @override
  List<Object> get props => [firstname];
}

class SetLastName extends UserRegisterEvent {
  SetLastName(this.lastname);
  final String lastname;
  @override
  List<Object> get props => [lastname];
}

class SetUserName extends UserRegisterEvent {
  SetUserName(this.username);
  final String username;
  @override
  List<Object> get props => [username];
}

class SetEducationFacility extends UserRegisterEvent {
  SetEducationFacility(this.educationfrom);
  final String educationfrom;
  @override
  List<Object> get props => [educationfrom];
}

class SaveUserData extends UserRegisterEvent {
  SaveUserData();
  @override
  List<Object?> get props => [];
}
