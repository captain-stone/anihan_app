import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Notification"),
      ),
      body: Center(
        child: const Text("Notification Page"),
      ),
    );
  }
}
