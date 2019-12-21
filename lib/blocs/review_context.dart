import 'package:rive_flutter/blocs/core/ride_bloc.dart';

class ReviewContext {
  ReviewBloc reviewBloc;

  ReviewContext() {
    reviewBloc = ReviewBloc();
  }

  void dispose() {
    reviewBloc.dispose();
  }
}