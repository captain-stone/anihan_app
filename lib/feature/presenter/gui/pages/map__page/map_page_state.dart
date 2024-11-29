part of 'map_page_cubit.dart';

abstract class MapPageState extends Equatable {
  const MapPageState();
}

class MapPageInitial extends MapPageState {
  @override
  List<Object> get props => [];
}

class MapPageLoadingState extends MapPageState {
  @override
  List<Object> get props => [];
}

class MapPageSuccessState extends MapPageState {
  final List<LatLng> locations;

  const MapPageSuccessState(this.locations);
  @override
  List<Object> get props => [locations];
}

class MapPageErrorState extends MapPageState {
  final String message;
  const MapPageErrorState(this.message);
  @override
  List<Object> get props => [message];
}
