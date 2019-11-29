import 'package:rive_flutter/blocs/core/ride_bloc.dart';

class HistoryContext {
  HistoryBloc historyBloc;

  HistoryContext() {
    historyBloc = HistoryBloc();
  }

  void dispose() {
    historyBloc.dispose();
  }
}