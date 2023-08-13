import 'dart:io';
import 'package:favorite_places/models/place_location.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:favorite_places/models/place.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "places.db"),
    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE places (id TEXT PRIMARY KEY,title TEXT,image TEXT,lat REAL,lng REAL,address TEXT)");
    },
    version: 1,
  );
  return db;
}

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);

  Future loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query("places");
    final places = data.map((row) {
      return Place(
        id: row["id"] as String,
        title: row["title"] as String,
        image: File(row["image"] as String),
        location: PlaceLocation(
          latitude: row["lat"] as double,
          longitude: row["lng"] as double,
          address: row["address"] as String,
        ),
      );
    }).toList();
    state = places;
  }

  void addItem(String title, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy("${appDir.path}/$filename");
    final newPlace =
        Place(title: title, image: copiedImage, location: location);
    final db = await _getDatabase();
    db.insert("places", {
      "id": newPlace.id,
      "title": newPlace.title,
      "image": newPlace.image.path,
      "lat": newPlace.location.latitude,
      "lng": newPlace.location.longitude,
      "address": newPlace.location.address,
    });

    List<Place> oldState = state;
    state = [...oldState, newPlace];
  }

  void removeItem(int index) async{
    final db = await _getDatabase();
    await db.delete("places",where: "id = ?",whereArgs: [state[index].id]);
    final oldState = state;
    oldState.removeAt(index);
    state = [...oldState];
  }
}

final placeListProvider =
    StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});
