part of 'journal_widget_bloc.dart';

abstract class JournalWidgetEvent extends Equatable {
  const JournalWidgetEvent();
}

class AddJournalEvent extends JournalWidgetEvent {
  final JournalEntryParams params;

  const AddJournalEvent(this.params);
  @override
  List<Object> get props => [params];
}

class DeleteJournalEvent extends JournalWidgetEvent {
  final JournalEntryParams params;

  const DeleteJournalEvent(this.params);
  @override
  List<Object> get props => [params];
}

class JournalOnLoadEvent extends JournalWidgetEvent {
  // final JournalEntryParams params;

  const JournalOnLoadEvent();
  @override
  List<Object> get props => [];
}
