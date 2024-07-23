part of 'dri_config_bloc.dart';

@immutable
abstract class DriConfigState {
  final Map<DRI, bool> driErrors;
  const DriConfigState({
    required this.driErrors,
  });
}

class DriConfigInitial extends DriConfigState {
  const DriConfigInitial({required super.driErrors});
  factory DriConfigInitial.fromDiet(Diet diet) {
    final driErrors = diet.dris.attributes__
        .map<DRI, bool>((key, value) => MapEntry(value, false));
    return DriConfigInitial(driErrors: driErrors);
  }

  DriConfigInitial copyWith({
    Map<DRI, bool>? driErrors_,
  }) {
    return DriConfigInitial(driErrors: driErrors_ ?? driErrors);
  }
}

class DRIErrorState extends DriConfigState {
  const DRIErrorState({required super.driErrors});
}

class DRISuccessfulUpdate extends DriConfigState {
  const DRISuccessfulUpdate({required super.driErrors});
}

class DRIActivationState extends DriConfigState {
  const DRIActivationState({required super.driErrors});
}
