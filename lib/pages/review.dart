import 'package:flutter/material.dart';

import 'package:loading_overlay/loading_overlay.dart';
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

  var isLoading = false;

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
    if (state is ReviewUninitializedState || state is ReviewFetchingState) {
      return;
    }
    else if (state is ReviewSuccessState) {
      createSuccessFlushbar('Your feedback is highly appreciated!')
          .show(context);
    } else if (state is ReviewErrorState) {
      createErrorFlushbar(state.errorMessage).show(context);
    }

    setLoading(false);
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
    setLoading(true);

    if (reviewGlobalKey.currentState.saveAndValidate()) {
      var reviewModel = ReviewModel.fromJson(reviewGlobalKey.currentState.value);

      reviewBloc.add(ReviewSendEvent(
        reviewModel: reviewModel,
      ));
    } else {
      setLoading(false);
    }
  }

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(),
      opacity: 0.3,
      color: Colors.teal[400],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Review'
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
                      decoration: InputDecoration(labelText: "Rating"),
                      iconSize: 32.0,
                      initialValue: 1,
                      max: 5,
                    ),
                    FormBuilderTextField(
                      attribute: "description",
                      decoration: InputDecoration(labelText: "Description", ),
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
                  RaisedButton(
                    onPressed: onSubmit,
                    child: Text("Submit"),
                    textColor: Colors.white,
                    color: Colors.teal[400],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    onPressed: onReset,
                    child: Text("Reset"),
                    textColor: Colors.white,
                    color: Colors.teal[400],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                      'Don\'t want to submit a review?'
                  ),
                  FlatButton(
                    onPressed: onMap,
                    child: Text(
                      'Go back to map!',
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

  @override
  void dispose() {
    super.dispose();
    reviewBloc.close();
  }
}