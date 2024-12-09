import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddUpdateAddress extends StatelessWidget {
  final TextEditingController controller;
  final List<String> listOfAddress;
  final String selectedAddress;
  final void Function() onPressedAddAddress;
  final Function(String? value) onSelectedValue;

  const AddUpdateAddress(
      {super.key,
      required this.controller,
      required this.listOfAddress,
      required this.selectedAddress,
      required this.onPressedAddAddress,
      required this.onSelectedValue});

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12))),
      child: SingleChildScrollView(
        child: SizedBox(
          height: _height * 0.5,
          width: _width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 12,
                ),

                Text(
                  'Please provide additional Address Information',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      labelText: 'Add Address',
                      prefixIcon: Icon(Icons.map),
                      suffixIcon: IconButton(
                          onPressed: onPressedAddAddress,
                          icon: Icon(Icons.arrow_forward))),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                const Spacer(),
                Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("List of Saved Address")),
                const SizedBox(
                  height: 8,
                ),
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

                //THIS IS WHERE YOU SIGNIN *******************
              ],
            ),
          ),
        ),
      ),
    );
  }
}
