import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/blocs/core/ride_bloc.dart';
import 'package:rive_flutter/blocs/core/ride_bloc_events.dart';
import 'package:rive_flutter/blocs/core/ride_bloc_states.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  HistoryBloc historyBloc;

  AppLocalizations dict;

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    dict = AppLocalizations.of(context);

    historyBloc = HistoryBloc();
    historyBloc.add(HistoryPaginatedEvent());

    initListeners();
  }

  void initListeners() {
    scrollController.addListener(onScrollControllerChanged);
  }

  void onScrollControllerChanged() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      historyBloc.add(HistoryPaginatedEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryBloc>(
      create: (context) => historyBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            dict.tr('history.title'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<HistoryBloc, HistoryState>(
            condition: (prevState, state) {
              return !(state is HistoryPaginatedFinishedState || state is HistoryFetchingState);
            },
            builder: (context, state) {
              return createHistoryList(state);
            }
          ),
        ),
      ),
    );
  }

  Widget createHistoryList(HistoryState state) {
    var history = List<Ride>();

    if (state is HistorySuccessState) {
      history = state.history;
    } else if (state is HistoryPaginatedSuccessState) {
      history = state.history;
    }

    return AnimationLimiter(
      child: ListView.builder(
        controller: scrollController,
        itemCount: history.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Container(
                    child: createHistoryCard(history[index])
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget createHistoryCard(Ride ride) {
    final dateTimeFormat = DateFormat('yyyy-mm-dd hh:mm');

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.map,
              color: Colors.teal,
              size: 48
            ),
            title: Text(
              '${dict.tr('history.ride_name')}: ${ride.pk}',
            ),
            subtitle: Text(
              '${dateTimeFormat.format(ride.startedDate)} - ${dateTimeFormat.format(ride.finishedDate)}',
            ),
          ),
        ],
      ),
    );
  }

  Widget createHistoryLoadingIndicator(HistoryState state) {
    if (state is HistoryFetchingState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    super.dispose();
    historyBloc.close();
    scrollController.dispose();
  }
}