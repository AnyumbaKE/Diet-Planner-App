part of 'init_settings_bloc.dart';

abstract class InitSettingsEvent {}

class MeasureUpdate extends InitSettingsEvent {
  Measure measure;
  MeasureUpdate(this.measure);
}

class CmUpdate extends InitSettingsEvent {
  String cm;
  CmUpdate(this.cm);
}

class InchesUpdate extends InitSettingsEvent {
  String inches;
  InchesUpdate(this.inches);
}

class FeetUpdate extends InitSettingsEvent {
  String feet;
  FeetUpdate(this.feet);
}

class AgeUpdate extends InitSettingsEvent {
  String age;
  AgeUpdate(this.age);
}

class WeightUpdate extends InitSettingsEvent {
  String weight;
  WeightUpdate(this.weight);
}

class KgUpdate extends InitSettingsEvent {
  String kg;
  KgUpdate(this.kg);
}

class ActivityUpdate extends InitSettingsEvent {
  Activity activity;
  ActivityUpdate(this.activity);
}

class SexUpdate extends InitSettingsEvent {
  Sex sex;
  SexUpdate(this.sex);
}

class ApiKeyUpdate extends InitSettingsEvent {
  String apiKey;
  ApiKeyUpdate(this.apiKey);
}

class AppIdUpdate extends InitSettingsEvent {
  String appId;
  AppIdUpdate(this.appId);
}

class DarkModeUpdate extends InitSettingsEvent {
  bool darkMode;
  DarkModeUpdate(this.darkMode);
}

class SubmitInitSettings extends InitSettingsEvent {}
