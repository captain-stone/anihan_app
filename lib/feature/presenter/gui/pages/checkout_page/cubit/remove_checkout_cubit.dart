import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'remove_checkout_state.dart';

@injectable
class RemoveCheckoutCubit extends Cubit<RemoveCheckoutState> {
  RemoveCheckoutCubit() : super(RemoveCheckoutInitial());
  final logger = Logger();
  Future<void> removeCheckout(
      {required String userId,
      required String storeId,
      required String cartId}) async {
    final DatabaseReference ref =
        FirebaseDatabase.instance.ref("cart/$userId/$storeId/$cartId");
    await ref.remove().then((_) {
      emit(const RemoveCheckoutSuccessState(
          "Successfully Remove Checkout data"));
    }).catchError((error) {
      logger.d(error);
      emit(RemoveCheckoutErrorState(
          "There's an error removing checkout: (error) $error"));
    });
  }
}
