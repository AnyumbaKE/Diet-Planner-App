import 'dart:io';
import 'dart:ui';
import 'package:ari_utils/ari_utils.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diet_planner/domain.dart';

part 'init_settings_event.dart';
part 'init_settings_state.dart';

class InitSettingsBloc extends Bloc<InitSettingsEvent, InitSettingsState> {
  InitSettingsBloc() : super(InitSettingsState.initial()) {
    on<MeasureUpdate>((event, emit) {
      if (event.measure == Measure.imperial) {
        emit(state.copyWith(measure_: event.measure, cm_: ''));
      } else {
        emit(state.copyWith(measure_: event.measure, inches_: '', feet_: ''));
      }
    });
    on<CmUpdate>((event, emit) {
      emit(state.copyWith(cm_: event.cm));
    });
    on<InchesUpdate>((event, emit) {
      emit(state.copyWith(inches_: event.inches));
    });
    on<FeetUpdate>((event, emit) {
      emit(state.copyWith(feet_: event.feet));
    });
    on<AgeUpdate>((event, emit) {
      emit(state.copyWith(age_: event.age));
    });
    on<WeightUpdate>((event, emit) {
      emit(state.copyWith(weight_: event.weight));
    });
    on<KgUpdate>((event, emit) {
      emit(state.copyWith(kg_: event.kg));
    });
    on<ActivityUpdate>((event, emit) {
      emit(state.copyWith(activity_: event.activity));
    });
    on<SexUpdate>((event, emit) {
      emit(state.copyWith(sex_: event.sex));
    });
    on<ApiKeyUpdate>((event, emit) {
      emit(state.copyWith(apiKey_: event.apiKey));
    });
    on<AppIdUpdate>((event, emit) {
      emit(state.copyWith(appId_: event.appId));
    });
    on<DarkModeUpdate>((event, emit) {
      emit(state.copyWith(darkMode_: event.darkMode));
    });
    on<SubmitInitSettings>((event, emit) {
      final newState = state.copyWith(
        errorAge_: state.age.isEmpty,
        errorApiKey_: state.apiKey.isEmpty,
        errorAppId_: state.appId.isEmpty,
        errorCm_: state.cm.isEmpty && state.measure == Measure.metric,
        errorFeet_: state.feet.isEmpty && state.measure == Measure.imperial,
        errorInches_: state.inches.isEmpty && state.measure == Measure.imperial,
        errorKg_: state.kg.isEmpty && state.measure == Measure.metric,
        errorWeight_: state.weight.isEmpty && state.measure == Measure.imperial,
      );
      print(newState.hasError);
      print(state.measure);
      print(state.errorInches);
      print(state.inches);
      print('kg');

      print(newState.sex);
      if (newState.hasError) {
        emit(newState);
      } else {
        final settings = Settings(
            anthroMetrics: state.measure == Measure.imperial
                ? AnthroMetrics(
                    sex: state.sex,
                    age: int.parse(state.age),
                    weight: int.parse(state.weight),
                    feet: int.parse(state.feet),
                    inches: int.parse(state.inches),
                    activity: state.activity,
                  )
                : AnthroMetrics.fromMetric(state.sex, int.parse(state.age),
                    int.parse(state.kg), int.parse(state.cm), state.activity),
            apikey: state.apiKey,
            appId: state.appId,
            darkMode: state.darkMode,
            measure: state.measure);
        print('word');
        emit(InitSettingsSuccessfulLoad(settings));
      }
    });
  }
}
