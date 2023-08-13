import 'package:favorite_places/providers/place_list_provider.dart';
import 'package:favorite_places/widgets/place_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/screens/add_place_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceListScreen extends ConsumerStatefulWidget {
  const PlaceListScreen({super.key});

  @override
  ConsumerState<PlaceListScreen> createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends ConsumerState<PlaceListScreen> {
  late Future _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(placeListProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final placeList = ref.watch(placeListProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Places",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                //_addItem(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const AddPlaceScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: FutureBuilder(
            future: _placesFuture,
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : PlaceListWidget(
                      placeList: placeList,
                    );
            }));
  }
}
