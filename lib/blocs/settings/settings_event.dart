part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class MeasureUpdate extends SettingsEvent {
  final Measure measure;
  MeasureUpdate(this.measure);
}

class CmUpdate extends SettingsEvent {
  final String cm;
  CmUpdate(this.cm);
}

class InchesUpdate extends SettingsEvent {
  final String inches;
  InchesUpdate(this.inches);
}

class FeetUpdate extends SettingsEvent {
  final String feet;
  FeetUpdate(this.feet);
}

class AgeUpdate extends SettingsEvent {
  final String age;
  AgeUpdate(this.age);
}

class WeightUpdate extends SettingsEvent {
  final String weight;
  WeightUpdate(this.weight);
}

class KgUpdate extends SettingsEvent {
  final String kg;
  KgUpdate(this.kg);
}

class ActivityUpdate extends SettingsEvent {
  final Activity activity;
  ActivityUpdate(this.activity);
}

class SexUpdate extends SettingsEvent {
  final Sex sex;
  SexUpdate(this.sex);
}

class ApiKeyUpdate extends SettingsEvent {
  final String apiKey;
  ApiKeyUpdate(this.apiKey);
}

class AppIdUpdate extends SettingsEvent {
  final String appId;
  AppIdUpdate(this.appId);
}

class DarkModeUpdate extends SettingsEvent {
  final bool darkMode;
  DarkModeUpdate(this.darkMode);
}

class BackupSuccess extends SettingsEvent {}

class BackupFailure extends SettingsEvent {
  final String err;
  BackupFailure(this.err);
}
