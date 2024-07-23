part of 'dri_config_bloc.dart';

enum DFT { dri, ul } // DRI Form Type

@immutable
abstract class DriConfigEvent {}

class DRIUpdate extends DriConfigEvent {
  final DFT dft;
  final DRI dri;
  late final num? newValue;

  DRIUpdate({required this.dft, required this.dri, required String newVal}) {
    newValue = fixDecimal(newVal);
  }

  bool isValid() {
    switch (dft) {
      case DFT.dri:
        if (newValue != null && dri.upperLimit != null) {
          if (newValue! >= dri.upperLimit!) {
            return false;
          }
        }
        break;
      case DFT.ul:
        if (newValue != null && dri.dri != null) {
          if (newValue! <= dri.dri!) {
            return false;
          }
        }
        break;
    }
    return true;
  }
}

class DRIActivation extends DriConfigEvent {
  final bool newToggle;
  final DRI dri;

  DRIActivation(this.newToggle, this.dri);
}
