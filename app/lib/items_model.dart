import 'package:flutter/material.dart';

class ItemsModel extends ChangeNotifier {
  List<String> items = [];

  ItemsModel() {
    items = List<String>.generate(64, (int index) => index.toString(),
        growable: true);
  }

  reorderSongs({required List<String> reorderedItems}) {
    items = reorderedItems;
    notifyListeners();
  }

  void onReorder({required int oldIndex, required int newIndex}) {
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
  }
}
