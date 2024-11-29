import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class Address {
  String name;
  String details;

  Address({required this.name, required this.details});
}

class SavedAddressesState extends Equatable {
  final List<Address> addresses;
  final Address? selectedAddress;

  const SavedAddressesState({required this.addresses, this.selectedAddress});

  @override
  List<Object?> get props => [addresses, selectedAddress];
}

class SavedAddressesEvent {}

class AddAddressEvent extends SavedAddressesEvent {
  final Address address;

  AddAddressEvent(this.address);
}

class EditAddressEvent extends SavedAddressesEvent {
  final Address address;
  final int index;

  EditAddressEvent(this.address, this.index);
}

class SelectAddressEvent extends SavedAddressesEvent {
  final Address address;

  SelectAddressEvent(this.address);
}

class SavedAddressesBloc
    extends Bloc<SavedAddressesEvent, SavedAddressesState> {
  SavedAddressesBloc()
      : super(const SavedAddressesState(addresses: [], selectedAddress: null)) {
    on<AddAddressEvent>((event, emit) {
      final updatedAddresses = List<Address>.from(state.addresses)
        ..add(event.address);
      emit(SavedAddressesState(
          addresses: updatedAddresses, selectedAddress: event.address));
    });

    on<EditAddressEvent>((event, emit) {
      final updatedAddresses = List<Address>.from(state.addresses);
      updatedAddresses[event.index] = event.address;
      emit(SavedAddressesState(
          addresses: updatedAddresses, selectedAddress: event.address));
    });

    on<SelectAddressEvent>((event, emit) {
      emit(SavedAddressesState(
          addresses: state.addresses, selectedAddress: event.address));
    });
  }
}
