import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/presenter/gui/pages/notification_bloc/notification_page_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/addons/notifications/panel_container_widget.dart';
import 'package:auto_route/annotations.dart';
import 'package:collection/collection.dart';

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
  final _notificationBloc = getIt<NotificationPageBloc>();

  final logger = Logger();
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();

    _notificationBloc.add(GetFarmersNotificationsEvent(uid: widget.uid));
    _notificationBloc.add(const GetCommunityNotification());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Notification"),
      ),
      body: BlocBuilder<NotificationPageBloc, NotificationPageState>(
        bloc: _notificationBloc,
        builder: (context, state) {
          logger.d(state);

          if (state is NotificationPageSuccessState) {
            if (state.data.containsKey('isApproved')) {
              _addNotificationData('notifications', state.data);
            }
          }

          if (state is NotificationCommunitiesSuccessState) {
            for (var community in state.communities) {
              var communityData = {
                'community': {
                  'name': community.name,
                  'membersName': community.members?['usersName'] ?? "None",
                  'createdAt': community.createdAt,
                }
              };

              _addNotificationData('community', communityData['community']!);
            }
          }

          if (data.isEmpty) {
            return const Center(
                child: Text("You don't have any notifications"));
          } else {
            logger.d(data);
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return PanelContainerWidget(
                    notification: data[index]['type'] ?? "asdsad",
                    data: data[index]['data'],
                  );
                });
          }
        },
      ),
    );
  }

  /// Add notification data to the list, ensuring no duplicates
  void _addNotificationData(String type, Map<String, dynamic> content) {
    if (!data.any((item) =>
        item['type'] == type && _deepEquality(item['data'], content))) {
      data.insert(0, {'type': type, 'data': content});
    }
  }

  /// Deep equality check for nested data structures
  bool _deepEquality(Map<String, dynamic>? map1, Map<String, dynamic>? map2) {
    if (map1 == null || map2 == null) return false;
    return const DeepCollectionEquality().equals(map1, map2);
  }
}
