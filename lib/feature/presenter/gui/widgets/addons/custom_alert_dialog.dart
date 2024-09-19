import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Color colorMessage;
  final String title;
  final double height;
  final bool actionCloseVisibility;
  final bool actionOkayVisibility;
  final String actionLabel;
  Function()? onPressedCloseBtn;
  Function()? onPressOkay;
  final Widget child;

  CustomAlertDialog({
    Key? key,
    required this.colorMessage,
    required this.title,
    this.height = 58,
    this.actionCloseVisibility = true,
    this.actionOkayVisibility = false,
    this.actionLabel = "Reset",
    this.onPressOkay,
    this.onPressedCloseBtn,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.centerLeft,
      title: Row(
        children: [
          Icon(
            Icons.warning_rounded,
            color: colorMessage,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(title)
        ],
      ),
      titleTextStyle: TextStyle(fontSize: 18.0, color: colorMessage),
      titlePadding: const EdgeInsets.all(18.0),
      content: Container(
        // color: Colors.red,
        // width: width * 0.3,
        height: height,
        alignment: Alignment.centerLeft,
        child: child,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      actionsPadding: const EdgeInsets.all(18.0),
      actions: [
        Row(
          mainAxisAlignment: actionCloseVisibility && actionOkayVisibility
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
          children: [
            Visibility(
              // visible: true,
              visible: actionCloseVisibility,
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)))),
                      onPressed: onPressedCloseBtn,
                      child: const Text("Close"))),
            ),
            Visibility(
              visible: actionOkayVisibility,
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // primary: Colors.redAccent,
                        // onPrimary: Colors.black54,
                        shadowColor: Colors.redAccent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: onPressOkay,
                      child: Text(actionLabel))),
            ),
          ],
        )
      ],
    );
  }
}
