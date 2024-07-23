part of 'init_bloc.dart';

@immutable
abstract class InitEvent {}

class AppInit extends InitEvent {}

class LoadFileInitEvent extends InitEvent {}

class CreatedNewSettings extends InitEvent {
  final Settings settings;
  CreatedNewSettings(this.settings);
}

class ReloadApp extends InitEvent {
  final App? app;
  ReloadApp({this.app});
}

class FactoryReset extends InitEvent {}
