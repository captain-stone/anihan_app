part of 'journal_widget_bloc.dart';

abstract class JournalWidgetState extends Equatable {
  const JournalWidgetState();
}

class JournalWidgetInitial extends JournalWidgetState {
  @override
  List<Object> get props => [];
}

class JournalWidgetLoadingState extends JournalWidgetState {
  const JournalWidgetLoadingState();
  @override
  List<Object> get props => [];
}

class JournalWidgetOnLoadState extends JournalWidgetState {
  final List<JournalEntryParams> list;

  const JournalWidgetOnLoadState(this.list);
  @override
  List<Object> get props => [list];
}

class JournalWidgetSuccessState extends JournalWidgetState {
  final List<JournalEntryDto> entry;
  const JournalWidgetSuccessState(this.entry);

  @override
  List<Object> get props => [entry];
}

class JournalWidgetErrorState extends JournalWidgetState {
  final String message;

  const JournalWidgetErrorState(this.message);
  @override
  List<Object> get props => [message];
}
