import 'package:favorite_places/models/place_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {this.location = const PlaceLocation(
        latitude: 37.422,
        longitude: -122.084,
        address: "",
      ),
      this.isSelecting = true,
      super.key});

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() {
    return _MapScreen();
  }
}

class _MapScreen extends State<MapScreen> {
  LatLng? _pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isSelecting
            ? Text(
                "Pick Location",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              )
            : Text(
                "Location",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(
                Icons.save,
              ),
            )
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null
            : (position) {
                setState(() {
                  _pickedLocation = position;
                });
              },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          zoom: 16,
        ),
        markers: (widget.isSelecting && _pickedLocation == null)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId(
                    "M1",
                  ),
                  position: _pickedLocation ??
                      LatLng(
                        widget.location.latitude,
                        widget.location.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
