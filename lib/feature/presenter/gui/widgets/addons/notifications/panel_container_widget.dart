// ignore_for_file: unused_element

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/common/enum_files.dart';
import 'package:anihan_app/feature/presenter/gui/pages/notification_bloc/notification_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class PanelContainerWidget extends StatelessWidget {
  final String notification;
  final NotificationPageBloc notifBloc;
  final Map<String, dynamic> data;
  const PanelContainerWidget(
      {required this.notification,
      required this.data,
      required this.notifBloc,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        // margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.notifications,
              size: 32,
            ),
            const SizedBox(
              width: 8,
            ),
            notification == "community"
                ? CommunityNotificationWidgets(
                    "Community",
                    data,
                    bloc: notifBloc,
                  )
                : notification == "notifications"
                    ? TitleContentWidgetPanelContainer(
                        "Approval",
                        data,
                      )
                    : notification == "merchant"
                        ? Container()
                        : Container(),
          ],
        ),
      ),
    );
  }
}

class CommunityNotificationWidgets extends StatelessWidget {
  final String title;
  final NotificationPageBloc bloc;
  final Map<String, dynamic> data;
  // late final bool isAccepted;
  final logger = Logger();

  CommunityNotificationWidgets(this.title, this.data,
      {required this.bloc, super.key});

  void _acceptFunction(Map<String, dynamic> data) =>
      bloc.add(AcceptCommunityRequestEvent(data));
  void _denyFunction(Map<String, dynamic> data) =>
      bloc.add(DenyCommunityRequestEvent(data));

  @override
  Widget build(BuildContext context) {
    // TextAlign alingment = TextAlign.left;
    String formattedDate =
        DateFormat('MM-dd-yyyy h:mma').format(data["createdAt"]).toLowerCase();
    logger.d(data);
    return Expanded(
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(formattedDate, style: const TextStyle(fontSize: 10))
              ],
            ),
            Text(
              data['membersName'],
            ),
            Text(
              "Request to join your community: ${data['name']}",
              softWrap: true,
              overflow: TextOverflow.clip,
            ),
            BlocBuilder<NotificationPageBloc, NotificationPageState>(
              bloc: bloc,
              builder: (context, state) {
                logger.d(state);

                bool isShit = false;
                if (state is NotificationCommunitiesSuccessState) {
                  for (var stateData in state.communities) {
                    var userId = stateData.members!['userId'];
                    if (data['memberId'] == userId) {
                      isShit = true;
                    } else {
                      isShit = false;
                    }
                  }
                } else {
                  isShit = false;
                }

                if (isShit) {
                  return Row(
                    children: [
                      ElevatedButton(
                          onPressed: () => _acceptFunction(data),
                          child: const Text('Accept')),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: () => _denyFunction(data), //denyFunction,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent),
                        child: const Text(
                          'Deny',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const ElevatedButton(
                      onPressed: null, child: Text('Accepted'));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class TitleContentWidgetPanelContainer extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;

  const TitleContentWidgetPanelContainer(this.title, this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    // TextAlign alingment = TextAlign.left;
    return Expanded(
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(data["date_created"], style: const TextStyle(fontSize: 10))
              ],
            ),
            Text(
              "Your store online time is ${data['onlineTime']}",
            ),
            data['isApproved'] == 'pendingApproval'
                ? const Text(
                    "Your store is pending approval. An admin will review and approve your request shortly.",
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  )
                : data['isApproved'] == 'notApproved'
                    ? const Text("Sorry your request is not approved.")
                    : const Text(
                        "Congrats! Your request has been approved by the admin."),
          ],
        ),
      ),
    );
  }
}
