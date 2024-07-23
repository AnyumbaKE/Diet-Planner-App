import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diet_planner/domain.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(Settings settings) : super(SettingsState(settings)) {
    on<MeasureUpdate>((event, emit) {
      state.settings.measure = event.measure;
      emit(SettingsMeasureChange(state.settings));
    });
    on<CmUpdate>((event, emit) {
      if (event.cm.isNotEmpty) {
        state.settings.anthroMetrics.cm = int.parse(event.cm);
        emit(SettingsState(state.settings));
      }
    });
    on<InchesUpdate>((event, emit) {
      if (event.inches.isNotEmpty) {
        state.settings.anthroMetrics.inches = int.parse(event.inches);
        emit(SettingsState(state.settings));
      }
    });
    on<FeetUpdate>((event, emit) {
      if (event.feet.isNotEmpty) {
        state.settings.anthroMetrics.feet = int.parse(event.feet);
        emit(SettingsState(state.settings));
      }
    });
    on<AgeUpdate>((event, emit) {
      if (event.age.isNotEmpty) {
        state.settings.anthroMetrics.age = int.parse(event.age);
        emit(SettingsState(state.settings));
      }
    });
    on<WeightUpdate>((event, emit) {
      if (event.weight.isNotEmpty) {
        state.settings.anthroMetrics.weight = int.parse(event.weight);
        emit(SettingsState(state.settings));
      }
    });
    on<KgUpdate>((event, emit) {
      if (event.kg.isNotEmpty) {
        state.settings.anthroMetrics.kg = int.parse(event.kg);
        emit(SettingsState(state.settings));
      }
    });
    on<ActivityUpdate>((event, emit) {
      state.settings.anthroMetrics.activity = event.activity;
      print(state.settings);
      emit(SettingsState(state.settings));
    });
    on<SexUpdate>((event, emit) {
      state.settings.anthroMetrics.sex = event.sex;
      print(state.settings);
      emit(SettingsState(state.settings));
    });
    on<ApiKeyUpdate>((event, emit) {
      state.settings.apikey = event.apiKey;
      emit(SettingsState(state.settings));
    });
    on<AppIdUpdate>((event, emit) {
      state.settings.appId = event.appId;
      emit(SettingsState(state.settings));
    });
    on<DarkModeUpdate>((event, emit) {
      state.settings.darkMode = event.darkMode;
      emit(SettingsStateDarkModeUpdate(state.settings));
    });
    on<BackupSuccess>((event, emit) {
      emit(LocalBackUpSuccess(state.settings));
    });
    on<BackupFailure>((event, emit) {
      emit(LocalBackUpFailure(state.settings, event.err));
    });
  }
}
