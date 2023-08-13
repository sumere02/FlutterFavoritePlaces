import 'package:favorite_places/models/place_location.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

const uuid = Uuid();

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;

  Place({
    required this.title,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();
}
