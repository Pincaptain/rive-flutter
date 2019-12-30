import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void initState() {
    super.initState();

    historyBloc = HistoryBloc();
    historyBloc.add(HistoryListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryBloc>(
      create: (context) => historyBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'History'
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<HistoryBloc, HistoryState>(
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
    }

    return AnimationLimiter(
      child: ListView.builder(
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
              'Ride: ${ride.pk}',
            ),
            subtitle: Text(
              '${dateTimeFormat.format(ride.startedDate)} - ${dateTimeFormat.format(ride.finishedDate)}',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    historyBloc.close();
  }
}