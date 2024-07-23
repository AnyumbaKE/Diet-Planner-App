part of 'init_bloc.dart';

@immutable
abstract class InitState {
  App? get app => null;
}

class InitInitial extends InitState {}

class SuccessfulLoad extends InitState {
  @override
  final App app;
  SuccessfulLoad(this.app);
}

class FailedLoad extends InitState {
  final String basename;
  FailedLoad(this.basename);
}
