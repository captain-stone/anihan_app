import 'package:flutter_bloc/flutter_bloc.dart';

class FarmersCubit extends Cubit<String> {
  FarmersCubit() : super("");

  void updateIsFarmers(String isFarmers) {
    emit(isFarmers);
  }
}
