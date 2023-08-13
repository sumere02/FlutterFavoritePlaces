import 'package:favorite_places/providers/place_list_provider.dart';
import 'package:favorite_places/screens/place_detail_screen.dart';
import "package:flutter/material.dart";
import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceListWidget extends ConsumerStatefulWidget {
  const PlaceListWidget({required this.placeList, super.key});
  final List<Place> placeList;

  @override
  ConsumerState<PlaceListWidget> createState() {
    return _PlaceListState();
  }
}

class _PlaceListState extends ConsumerState<PlaceListWidget> {
  @override
  Widget build(BuildContext context) {
    final placeList = widget.placeList;
    return SafeArea(
      child: placeList.isEmpty
          ? Center(
              child: Text(
                "Zero place exists\n\nTry adding some",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: placeList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: const ValueKey(1),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    ref.read(placeListProvider.notifier).removeItem(index);
                    setState(() {
                      placeList.removeAt(index);
                    });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: FileImage(
                        placeList[index].image,
                      ),
                    ),
                    title: Text(
                      placeList[index].title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    subtitle: Text(
                      placeList[index].location.address,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlaceDetailScreen(
                            place: placeList[index],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
