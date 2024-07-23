part of 'settings_bloc.dart';

class SettingsState {
  Settings settings;

  SettingsState(this.settings);

  SettingsState copyWith({
    Settings? settings_,
  }) {
    return SettingsState(settings_ ?? settings);
  }

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is SettingsState &&
  //         runtimeType == other.runtimeType &&
  //         settings == other.settings;
  //
  // @override
  // int get hashCode => settings.hashCode;
}

class SettingsStateDarkModeUpdate extends SettingsState {
  SettingsStateDarkModeUpdate(super.settings);
}

class SettingsMeasureChange extends SettingsState {
  Measure get measure => settings.measure;
  SettingsMeasureChange(super.settings);
}

class LocalBackUpSuccess extends SettingsState {
  LocalBackUpSuccess(super.settings);
}

class LocalBackUpFailure extends SettingsState {
  String err;
  LocalBackUpFailure(super.settings, this.err);
}
