part of 'encyclopedia_bloc.dart';

enum EntryStatus { initial, success, failure }

class EncyclopediaState extends Equatable {
  final EntryStatus status;
  final List<Mushroom> entries;
  final bool hasReachedMax;
  final int offset;

  const EncyclopediaState({
    this.status = EntryStatus.initial,
    this.entries = const <Mushroom>[],
    this.hasReachedMax = false,
    this.offset = 0,
  });

  EncyclopediaState copyWith({
    EntryStatus? status,
    List<Mushroom>? entries,
    bool? hasReachedMax,
    int? offset,
  }) {
    return EncyclopediaState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      offset: offset ?? this.offset,
    );
  }

  @override
  String toString() {
    return '''EncyclopediaState { status: $status, hasReachedMax: $hasReachedMax, entries: ${entries.length} }''';
  }

  @override
  List<Object> get props => [status, entries, hasReachedMax, offset];
}

final class EncyclopediaInitial extends EncyclopediaState {}
