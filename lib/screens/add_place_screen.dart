import 'package:favorite_places/models/place_location.dart';
import 'package:favorite_places/providers/place_list_provider.dart';
import 'package:favorite_places/widgets/image_input_widget.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceState();
  }
}

class _AddPlaceState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredTitle = "";
  File? _enteredImage;
  PlaceLocation? _selectedLocation;

  void _setLocation(PlaceLocation location){
    _selectedLocation = location;
  }

  void _setImage(File image) {
    _enteredImage = image;
  }

  void _savePlace() {
    if (_formKey.currentState!.validate()) {
      final placeList = ref.read(placeListProvider.notifier);
      _formKey.currentState!.save();
      placeList.addItem(_enteredTitle,_enteredImage!,_selectedLocation!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Place",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text(
                    "Title",
                  ),
                ),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.length > 50) {
                    return "Must be between 1 and 50 characters.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredTitle = value!;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              //Image Input
              FormField(
                builder: (ctx) {
                  return ImageInputWidget(setImage: _setImage);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              FormField(
                builder: (ctx) {
                  return LocationInputWidget(onSelectLocation:_setLocation);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _savePlace();
                  },
                  label: const Text("Add Place"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
