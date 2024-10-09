import 'package:flutter/material.dart';

class PanelContainerWidget extends StatelessWidget {
  final String notification;
  final Map<String, dynamic> data;
  const PanelContainerWidget(
      {required this.notification, required this.data, super.key});

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
            notification == "message"
                ? Container()
                : notification == "approval"
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
                Text(data["date_created"], style: TextStyle(fontSize: 10))
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
