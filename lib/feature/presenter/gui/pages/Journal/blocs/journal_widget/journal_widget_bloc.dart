import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/api/journal_api.dart';
import 'package:anihan_app/feature/data/models/dto/journal_entry_dto.dart';
import 'package:anihan_app/feature/domain/parameters/journal_entry_params.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'journal_widget_event.dart';
part 'journal_widget_state.dart';

@injectable
class JournalWidgetBloc extends Bloc<JournalWidgetEvent, JournalWidgetState> {
  final JournalApi _journalApi = JournalApi();
  JournalWidgetBloc() : super(JournalWidgetInitial()) {
    on<JournalOnLoadEvent>((event, emit) async {
      emit(const JournalWidgetLoadingState());
      var result = await _journalApi.getAllJournalApi();

      Status status = result.status;
      if (status != Status.error) {
        var data = result.data;
        if (data != null) {
          emit(JournalWidgetSuccessState(data));
        } else {
          emit(JournalWidgetErrorState(result.message!));
        }
      } else {
        emit(JournalWidgetErrorState(result.message!));
      }
    });

    on<AddJournalEvent>((event, emit) async {
      emit(const JournalWidgetLoadingState());
      var result = await _journalApi.addJournalApi(event.params);

      Status status = result.status;
      if (status != Status.error) {
        var data = result.data;
        if (data != null) {
          emit(JournalWidgetSuccessState(data));
        } else {
          emit(JournalWidgetErrorState(result.message!));
        }
      } else {
        emit(JournalWidgetErrorState(result.message!));
      }
      // final currentState = state as JournalLoaded;
      // final updatedEntries = List<JournalEntryParams>.from(currentState.entries)
      //   ..add(event.params);
      // emit(JournalWidgetOnLoadState(updatedEntries));
    });

    // on<DeleteJournalEvent>((event, emit) {
    //   if (state is JournalWidgetOnLoadState) {
    //     final currentState = state as JournalLoaded;
    //     final updatedEntries = currentState.entries
    //         .where((entry) => entry != event.params)
    //         .toList();
    //     emit(JournalWidgetOnLoadState([]));
    //   }
    // });
  }
}
