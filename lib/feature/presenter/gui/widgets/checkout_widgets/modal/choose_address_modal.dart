import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/saved_address_bloc.dart';

class ChooseAddressModal extends StatelessWidget {
  ChooseAddressModal({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          BlocBuilder<SavedAddressesBloc, SavedAddressesState>(
            builder: (context, state) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.addresses.length,
                itemBuilder: (context, index) {
                  final address = state.addresses[index];
                  return ListTile(
                    title: Text(address.name),
                    subtitle: Text(address.details),
                    leading: Radio<Address>(
                      value: address,
                      groupValue: state.selectedAddress,
                      onChanged: (value) {
                        context
                            .read<SavedAddressesBloc>()
                            .add(SelectAddressEvent(value!));
                        Navigator.pop(context);
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        nameController.text = address.name;
                        detailsController.text = address.details;
                        _showEditDialog(context, index);
                      },
                    ),
                  );
                },
              );
            },
          ),
          const Divider(),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add New Address"),
            onPressed: () {
              nameController.clear();
              detailsController.clear();
              _showEditDialog(context, null);
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, int? index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? "Add Address" : "Edit Address"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name")),
            TextField(
                controller: detailsController,
                decoration: const InputDecoration(labelText: "Details")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final address = Address(
                  name: nameController.text, details: detailsController.text);
              if (index == null) {
                context
                    .read<SavedAddressesBloc>()
                    .add(AddAddressEvent(address));
              } else {
                context
                    .read<SavedAddressesBloc>()
                    .add(EditAddressEvent(address, index));
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
