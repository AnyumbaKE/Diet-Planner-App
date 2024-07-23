part of 'index_bloc.dart';

@immutable
class IndexState {
  final App app;

  const IndexState(this.app);

  IndexState copyWith({
    App? app,
  }) {
    return IndexState(app ?? this.app);
  }
}

class FailedToLoadDiet extends IndexState {
  final String errMessage;
  const FailedToLoadDiet(super.app, this.errMessage);
}
