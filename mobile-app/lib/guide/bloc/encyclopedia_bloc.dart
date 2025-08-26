import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:mushroom_master/guide/widgets/mushroom.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:mushroom_master/utils/database_helper.dart'; // Import DatabaseHelper

part 'encyclopedia_event.dart';
part 'encyclopedia_state.dart';

const _entryLimit = 50;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class EncyclopediaBloc extends Bloc<EncyclopediaEvent, EncyclopediaState> {
  final http.Client httpClient;
  Database? _db;

  EncyclopediaBloc({required this.httpClient})
      : super(const EncyclopediaState()) {
    on<EntryFetched>(_onEntryFetched,
        transformer: throttleDroppable(throttleDuration));
    _openDatabaseOnce();
  }

  Future<void> _openDatabaseOnce() async {
    // Use DatabaseHelper to initialize the database
    final dbPath = await DatabaseHelper.initializeDatabase(
      'fungi_species.db', 
      'assets/databases/fungi_species.db'
    );
    _db = await openDatabase(dbPath);
  }

  Future<void> _onEntryFetched(
      EntryFetched event, Emitter<EncyclopediaState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (_db == null) { // Ensure database is open if _openDatabaseOnce hasn't completed yet
        await _openDatabaseOnce();
      }
      if (state.status == EntryStatus.initial) {
        final entries = await _fetchEntries(startIndex: state.offset);
        final reachedMax = entries.length < _entryLimit;
        return emit(state.copyWith(
          status: EntryStatus.success,
          entries: entries,
          offset: entries.length,
          hasReachedMax: reachedMax,
        ));
      }
      final entries = await _fetchEntries(startIndex: state.offset);
      final reachedMax = entries.length < _entryLimit;
      emit(entries.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: EntryStatus.success,
              entries: List.of(state.entries)..addAll(entries),
              offset: state.offset + entries.length,
              hasReachedMax: reachedMax,
            ));
    } catch (e) {
      print('Error fetching entries: $e');
      emit(state.copyWith(status: EntryStatus.failure));
    }
  }

  Future<List<Mushroom>> _fetchEntries({required int startIndex}) async {
    if (_db == null) {
      // Use DatabaseHelper to initialize the database if needed
      final dbPath = await DatabaseHelper.initializeDatabase(
        'fungi_species.db', 
        'assets/databases/fungi_species.db'
      );
      _db = await openDatabase(dbPath);
    }
    
    // First, create a case expression to determine sorting priority
    final orderByClause = "CASE WHEN edibility IS NULL OR edibility = '' OR " +
                          "LOWER(edibility) = 'unknown' OR " +
                          "LOWER(edibility) = 'null' OR " + 
                          "LOWER(edibility) = 'undefined' " +
                          "THEN 1 ELSE 0 END, id ASC";
    
    final data = await _db!.query(
      'fungi_species',
      columns: [
        'id', 
        'label', 
        'description', 
        'edibility', 
        'image', 
        'species_name',
        'class', 
        'phylum', 
        'order', 
        'family', 
        'genus'
      ],
      limit: _entryLimit,
      offset: startIndex,
      orderBy: orderByClause, 
    );

    return data.map((row) {
      return Mushroom(
        id: row['id'] as String,
        name: row['label'] as String,
        description: (row['description'] ?? '') as String,
        imageUrl: (row['image'] ?? '') as String,
        edibility: row['edibility'] as String?,
        mushroomClass: row['class'] as String?,
        phylum: row['phylum'] as String?,
        order: row['order'] as String?,
        family: row['family'] as String?,
        genus: row['genus'] as String?,
      );
    }).toList();
  }
}
