import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart';

class DatabaseHelper {
  static Future<String> initializeDatabase(String dbName, String assetPath) async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, dbName);

    // Load the asset database for comparison
    final byteData = await rootBundle.load(assetPath);
    final assetBytes = byteData.buffer.asUint8List();
    final assetHash = sha256.convert(assetBytes).toString();

    print('DatabaseHelper - Asset database hash ($dbName): $assetHash');

    // Check if the database already exists
    if (await File(path).exists()) {
      try {
        // Calculate hash of existing database
        final existingBytes = await File(path).readAsBytes();
        final existingHash = sha256.convert(existingBytes).toString();

        print('DatabaseHelper - Existing database hash ($dbName): $existingHash');

        // Compare hashes
        if (assetHash != existingHash) {
          print('DatabaseHelper - Database hash mismatch ($dbName) - updating database from assets');
          // If hashes are different, copy the new database
          await File(path).writeAsBytes(assetBytes, flush: true);
        } else {
          print('DatabaseHelper - Database hashes match ($dbName) - using existing database');
        }
      } catch (e) {
        print('DatabaseHelper - Error comparing database hashes ($dbName): $e');
        // If there's an error, copy the database anyway to be safe
        await File(path).writeAsBytes(assetBytes, flush: true);
      }
    } else {
      // If database doesn't exist, copy it from assets
      print('DatabaseHelper - Database does not exist ($dbName) - copying from assets');
      await File(path).writeAsBytes(assetBytes, flush: true);
    }

    return path;
  }
}
