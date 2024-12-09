part of 'add_update_user_address_cubit.dart';

sealed class AddUpdateUserAddressState extends Equatable {
  const AddUpdateUserAddressState();
}

class AddUpdateUserAddressInitial extends AddUpdateUserAddressState {
  @override
  List<Object> get props => [];
}

class AddUpdateUserAddressLaodingState extends AddUpdateUserAddressState {
  @override
  List<Object> get props => [];
}

class AddUpdateUserAddressSuccessState extends AddUpdateUserAddressState {
  final Map<String, dynamic> data;
  const AddUpdateUserAddressSuccessState(this.data);
  @override
  List<Object> get props => [];
}

class AllSaveAddressSuccessState extends AddUpdateUserAddressState {
  final List<String> data;

  const AllSaveAddressSuccessState(this.data);

  @override
  List<Object?> get props => [];
}

class AllSaveAndSelectedAddressSuccessState extends AddUpdateUserAddressState {
  final Map<String, dynamic> data;

  const AllSaveAndSelectedAddressSuccessState(this.data);

  @override
  List<Object?> get props => [];
}

class AddUpdateUserAddressErrorState extends AddUpdateUserAddressState {
  @override
  List<Object> get props => [];
}
