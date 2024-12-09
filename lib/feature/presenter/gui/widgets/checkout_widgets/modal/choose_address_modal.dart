import 'package:anihan_app/feature/presenter/gui/widgets/addons/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class ChooseAddressModal extends StatelessWidget {
  final TextEditingController nameController;
  final List<String> listOfAddress;
  final String selectedAddress;
  final Function(String? value) onSelectedValue;
  final void Function() onAddAddressFunction;

  ChooseAddressModal({
    super.key,
    required this.nameController,
    required this.listOfAddress,
    required this.selectedAddress,
    required this.onSelectedValue,
    required this.onAddAddressFunction,
  });

  final TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Choose Address",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Divider(),

          // const SizedBox(height: 16),

          Container(
            height: _height * 0.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.greenAccent),
            child: ListView.builder(
              itemCount: listOfAddress.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(listOfAddress[index]),
                  leading: Radio<String>(
                      value: listOfAddress[index],
                      groupValue: selectedAddress,
                      onChanged: (String? value) {
                        onSelectedValue(value);
                        print("dasda");
                      }),
                );
              },
            ),
          ),

          const Divider(
            color: Colors.green,
          ),
          Container(
            width: _width,
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(fixedSize: const Size(250, 60)),
              icon: const Icon(Icons.add),
              label: const Text("Add New Address"),
              onPressed: () {
                Navigator.of(context).pop();
                nameController.clear();
                // detailsController.clear();
                _showEditDialog(context, null);
              },
            ),
          ),
          const SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, int? index) {
    showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
              colorMessage: Colors.green,
              title: "Add Address",
              onPressedCloseBtn: () {
                Navigator.of(context).pop();
              },
              actionLabel: "Add",
              actionOkayVisibility: true,
              actionColor: Colors.green.shade700,
              onPressOkay: onAddAddressFunction,
              child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name")),
            ));
  }
}
