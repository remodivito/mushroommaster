part of 'encyclopedia_bloc.dart';

sealed class EncyclopediaEvent extends Equatable {
  const EncyclopediaEvent();

  @override
  List<Object> get props => [];
}

final class EntryFetched extends EncyclopediaEvent {}
