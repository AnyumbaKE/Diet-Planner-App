import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diet_planner/domain.dart';
import 'package:diet_planner/utils.dart';

part 'dri_config_event.dart';
part 'dri_config_state.dart';

class DriConfigBloc extends Bloc<DriConfigEvent, DriConfigState> {
  DriConfigBloc(Diet diet) : super(DriConfigInitial.fromDiet(diet)) {
    on<DriConfigEvent>((event, emit) {});
    on<DRIActivation>((event, emit) {
      event.dri.tracked = event.newToggle;
      emit(DRIActivationState(driErrors: state.driErrors));
    });
    on<DRIUpdate>((event, emit) {
      if (event.isValid()) {
        // <editor-fold desc="Update DRI/UL Value">
        switch (event.dft) {
          case DFT.dri:
            event.dri.dri = event.newValue;
            break;
          case DFT.ul:
            event.dri.upperLimit = event.newValue;
            break;
        }
        // </editor-fold>
        // De-List from errors
        state.driErrors[event.dri] = false;
        emit(DRISuccessfulUpdate(driErrors: state.driErrors));
      } else {
        state.driErrors[event.dri] = true;
        emit(DRIErrorState(driErrors: state.driErrors));
      }
    });
  }
}
