import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaverBloc extends Bloc<SaverEvent, SaverState> {
  SaverBloc() : super(SaverState.init()) {
    on<SaverEvent>((event, emit) {});
    on<SavedApp>((event, emit) {
      emit(SaverState(message: 'app'));
    });
    on<SavedDiet>((event, emit) {
      emit(SaverState(message: event.message));
    });
  }
}

@immutable
abstract class SaverEvent {}

class SavedApp extends SaverEvent {}

class SavedDiet extends SaverEvent {
  final String message;

  SavedDiet(this.message);
}

class SaverState {
  String message;

  factory SaverState.init() => SaverState(message: '');
  //<editor-fold desc="Data Methods">
  SaverState({
    required this.message,
  });

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     (other is SaverState &&
  //         runtimeType.toString() == other.runtimeType.toString() &&
  //         message.runtimeType == other.message.runtimeType &&
  //         message.toString() == other.message.toString());
  //
  // @override
  // int get hashCode => message.hashCode;

  @override
  String toString() {
    return 'SaverState{'
        'message: $message}';
  }

  SaverState copyWith({
    String? message_,
  }) {
    return SaverState(message: message_ ?? message);
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
    };
  }

  factory SaverState.fromMap(Map<String, dynamic> map) {
    return SaverState(
      message: map['message'] as String,
    );
  }

//</editor-fold>
}
