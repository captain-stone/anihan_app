import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/saved_address_bloc.dart';
import 'modal/choose_address_modal.dart';

class AddressWidget extends StatelessWidget {
  const AddressWidget({Key? key}) : super(key: key);

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
        title: BlocBuilder<SavedAddressesBloc, SavedAddressesState>(
          builder: (context, state) {
            final address = state.selectedAddress;
            return Text(
              address?.name ?? "Select Address",
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          },
        ),
        subtitle: BlocBuilder<SavedAddressesBloc, SavedAddressesState>(
          builder: (context, state) {
            final address = state.selectedAddress;
            return Text(address?.details ?? "No address selected");
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            // Pass the SavedAddressesBloc using BlocProvider.value
            final savedAddressesBloc =
                BlocProvider.of<SavedAddressesBloc>(context);

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (_) {
                return BlocProvider.value(
                  value: savedAddressesBloc,
                  child: ChooseAddressModal(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
