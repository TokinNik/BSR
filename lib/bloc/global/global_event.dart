part of 'global_bloc.dart';

abstract class GlobalEvent extends Equatable {
  const GlobalEvent();

  @override
  List<Object> get props => [];
}

class LogInEvent extends GlobalEvent {}

class LogOutEvent extends GlobalEvent {}

class GetPreferencesEvent extends GlobalEvent {}

class SetPreferencesEvent extends GlobalEvent {
  final Preferences preferences;

  SetPreferencesEvent(this.preferences);
}

