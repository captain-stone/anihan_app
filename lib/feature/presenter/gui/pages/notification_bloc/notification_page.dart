import 'package:anihan_app/feature/presenter/gui/pages/notification_bloc/notification_page_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/addons/notifications/panel_container_widget.dart';
import 'package:auto_route/annotations.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

@RoutePage()
class NotificationPage extends StatefulWidget {
  final String? uid;
  const NotificationPage({this.uid, super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final logger = Logger();
  List<Map<String, dynamic>> data = [];
  String notification = "";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationPageBloc()
        ..add(GetFarmersNotificationsEvent(uid: widget.uid)),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Notification"),
        ),
        body: BlocBuilder<NotificationPageBloc, NotificationPageState>(
          builder: (context, state) {
            logger.d(state);

            if (state is NotificationPageSuccessState) {
              if (state.data.containsKey('isApproved')) {
                notification = "approval";
              }

              if (!(data.contains(state.data))) {
                data.insert(0, state.data);
              }
            }

            if (data.isEmpty) {
              return const Center(
                  child: Text("You don't have any notifications"));
            } else {
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (contexet, index) {
                    return PanelContainerWidget(
                        notification: notification, data: data[index]);
                  });
            }
          },
        ),
      ),
    );
  }
}
