import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modal/choose_address_modal.dart';

class AddressWidget extends StatelessWidget {
  final String selectedAddress;
  final void Function() onPressedSelectAddress;
  const AddressWidget({
    super.key,
    required this.selectedAddress,
    required this.onPressedSelectAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(Icons.location_pin,
              color: Theme.of(context).colorScheme.primary),
        ),
        title:
            // final address = state.selectedAddress;
            const Text(
          "Select Address",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(selectedAddress),
        trailing: IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onPressedSelectAddress),
        // trailing: IconButton(
        //   icon: const Icon(Icons.chevron_right),
        //   onPressed: () {
        //     // Pass the SavedAddressesBloc using BlocProvider.value
        //     final savedAddressesBloc = BlocProvider.of<SaveAddressBloc>(context);

        //     showModalBottomSheet(
        //       context: context,
        //       isScrollControlled: true,
        //       shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        //       ),
        //       builder: (_) {
        //         return BlocProvider.value(
        //           value: savedAddressesBloc,
        //           child: ChooseAddressModal(),
        //         );
        //       },
        //     );
        //   },
      ),
    );
  }
}
