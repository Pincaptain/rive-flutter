import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:rive_flutter/blocs/history_context.dart';
import 'package:rive_flutter/blocs/core/ride_bloc.dart';
import 'package:rive_flutter/models/core.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  HistoryContext historyContext;

  HistoryPageState() {
    historyContext = HistoryContext();

    historyContext.historyBloc.dispatch(HistoryEvent.list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: Text(
          'History'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Ride>>(
          stream: historyContext.historyBloc.state,
          builder: (context, snapshot) {
            return AnimationLimiter(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Container(
                          child: createHistoryCard(snapshot.data[index])
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        ),
      ),
    );
  }

  Card createHistoryCard(Ride ride) {
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
}