import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:rive_flutter/pages/map.dart';
import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/widgets/builders/flushbar_builders.dart';
import 'package:rive_flutter/blocs/core/ride_bloc.dart';
import 'package:rive_flutter/blocs/core/ride_bloc_events.dart';
import 'package:rive_flutter/blocs/core/ride_bloc_states.dart';

class ReviewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReviewPageState();
}

class ReviewPageState extends State<ReviewPage> {
  final reviewGlobalKey = GlobalKey<FormBuilderState>();

  ReviewBloc reviewBloc;

  @override
  void initState() {
    super.initState();

    reviewBloc = ReviewBloc();

    initStreams();
  }

  void initStreams() {
    reviewBloc.listen(onReviewResult);
  }

  void onReviewResult(ReviewState state) {
    if (state is ReviewSuccessState) {
      createSuccessFlushbar(AppLocalizations.of(context).tr('review.review_success'))
          .show(context);
    } else if (state is ReviewErrorState) {
      createErrorFlushbar(state.errorMessage).show(context);
    }
  }

  void onMap() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(),
      ),
    );
  }

  void onReset() {
    reviewGlobalKey.currentState.reset();
  }

  void onSubmit() {
    if (reviewGlobalKey.currentState.saveAndValidate()) {
      var reviewModel = ReviewModel.fromJson(reviewGlobalKey.currentState.value);

      reviewBloc.add(ReviewSendEvent(
        reviewModel: reviewModel,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReviewBloc>(
      create: (context) => reviewBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).tr('review.title'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              FormBuilder(
                key: reviewGlobalKey,
                initialValue: {
                  'rating': 1,
                  'description': '',
                },
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    FormBuilderRate(
                      attribute: "rating",
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).tr('review.rating_label'),
                      ),
                      iconSize: 32.0,
                      initialValue: 1,
                      max: 5,
                    ),
                    FormBuilderTextField(
                      attribute: "description",
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).tr('review.description_label'),
                      ),
                      minLines: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  BlocBuilder<ReviewBloc, ReviewState>(
                    builder: (context, state) {
                      return createSubmitButton(state);
                    }
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    onPressed: onReset,
                    child: Text(
                      AppLocalizations.of(context).tr('review.reset_button'),
                    ),
                    textColor: Colors.white,
                    color: Colors.teal[400],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).tr('review.no_review'),
                  ),
                  FlatButton(
                    onPressed: onMap,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Text(
                      AppLocalizations.of(context).tr('review.map_button'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createSubmitButton(ReviewState state) {
    Widget displayWidget = Text(
      AppLocalizations.of(context).tr('review.submit_button'),
    );

    if (state is ReviewFetchingState) {
      displayWidget = Container(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ); 
    }

    return RaisedButton(
      onPressed: state is ReviewFetchingState ? () {} : onSubmit,
      child: displayWidget,
      textColor: Colors.white,
      color: Colors.teal[400],
    );
  }

  @override
  void dispose() {
    super.dispose();
    reviewBloc.close();
  }
}