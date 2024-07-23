import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BarcodeBloc extends Bloc<BarcodeEvent, BarcodeState> {
  BarcodeBloc() : super(BarcodeInitial()) {
    on<BarcodeEvent>((event, emit) {});
  }
}

@immutable
abstract class BarcodeEvent {}

class BarcodeState {}

class BarcodeInitial extends BarcodeState {}
