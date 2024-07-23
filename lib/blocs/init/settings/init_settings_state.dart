part of 'init_settings_bloc.dart';

class InitSettingsState {
// <editor-fold desc="Params">
  Measure measure =
      Platform.localeName.endsWith('US') ? Measure.imperial : Measure.metric;
  String cm = '';
  String inches = '';
  String feet = '';
  String age = '';
  String weight = '';
  String kg = '';
  Activity activity = Activity.Sedentary;
  Sex sex = Sex.M;
  String apiKey = '';
  String appId = '';
  bool darkMode =
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  bool errorCm = false;
  bool errorInches = false;
  bool errorFeet = false;
  bool errorAge = false;
  bool errorWeight = false;
  bool errorKg = false;
  bool errorApiKey = false;
  bool errorAppId = false;
// </editor-fold>

// <editor-fold desc="Constructors">
  InitSettingsState.initial();

  InitSettingsState({
    Measure? measure,
    String? cm,
    String? inches,
    String? feet,
    String? age,
    String? weight,
    String? kg,
    Activity? activity,
    Sex? sex,
    String? apiKey,
    String? appId,
    bool? darkMode,
    bool? errorCm,
    bool? errorInches,
    bool? errorFeet,
    bool? errorAge,
    bool? errorWeight,
    bool? errorKg,
    bool? errorApiKey,
    bool? errorAppId,
  }) {
    this.measure = measure ?? this.measure;
    this.cm = cm ?? this.cm;
    this.inches = inches ?? this.inches;
    this.feet = feet ?? this.feet;
    this.age = age ?? this.age;
    this.weight = weight ?? this.weight;
    this.kg = kg ?? this.kg;
    this.activity = activity ?? this.activity;
    this.sex = sex ?? this.sex;
    this.apiKey = apiKey ?? this.apiKey;
    this.appId = appId ?? this.appId;
    this.darkMode = darkMode ?? this.darkMode;
    this.errorCm = errorCm ?? this.errorCm;
    this.errorInches = errorInches ?? this.errorInches;
    this.errorFeet = errorFeet ?? this.errorFeet;
    this.errorAge = errorAge ?? this.errorAge;
    this.errorWeight = errorWeight ?? this.errorWeight;
    this.errorKg = errorKg ?? this.errorKg;
    this.errorApiKey = errorApiKey ?? this.errorApiKey;
    this.errorAppId = errorAppId ?? this.errorAppId;
  }

  InitSettingsState copyWith({
    Measure? measure_,
    String? cm_,
    String? inches_,
    String? feet_,
    String? age_,
    String? weight_,
    String? kg_,
    Activity? activity_,
    Sex? sex_,
    String? apiKey_,
    String? appId_,
    bool? darkMode_,
    bool? errorCm_,
    bool? errorInches_,
    bool? errorFeet_,
    bool? errorAge_,
    bool? errorWeight_,
    bool? errorKg_,
    bool? errorApiKey_,
    bool? errorAppId_,
  }) {
    return InitSettingsState(
        measure: measure_ ?? measure,
        cm: cm_ ?? cm,
        inches: inches_ ?? inches,
        feet: feet_ ?? feet,
        age: age_ ?? age,
        weight: weight_ ?? weight,
        kg: kg_ ?? kg,
        activity: activity_ ?? activity,
        sex: sex_ ?? sex,
        apiKey: apiKey_ ?? apiKey,
        appId: appId_ ?? appId,
        darkMode: darkMode_ ?? darkMode,
        errorCm: errorCm_ ?? errorCm,
        errorInches: errorInches_ ?? errorInches,
        errorFeet: errorFeet_ ?? errorFeet,
        errorAge: errorAge_ ?? errorAge,
        errorWeight: errorWeight_ ?? errorWeight,
        errorKg: errorKg_ ?? errorKg,
        errorApiKey: errorApiKey_ ?? errorApiKey,
        errorAppId: errorAppId_ ?? errorAppId);
  }
// </editor-fold>

  bool get hasError => Logical.any([
        errorApiKey,
        errorAge,
        errorAppId,
        errorCm,
        errorFeet,
        errorInches,
        errorKg,
        errorWeight
      ]);
}

class InitSettingsErrors extends InitSettingsState {}

class InitSettingsSuccessfulLoad extends InitSettingsState {
  Settings settings;

  InitSettingsSuccessfulLoad(this.settings);
}
