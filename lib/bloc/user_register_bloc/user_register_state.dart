part of 'user_register_bloc.dart';

@immutable
abstract class UserRegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserRegisterInitial extends UserRegisterState {}

class UserRegisterUpdating extends UserRegisterState {}

class UserRegisterUpdated extends UserRegisterState {}
