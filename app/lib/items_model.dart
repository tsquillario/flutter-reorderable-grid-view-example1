import 'package:flutter/material.dart';

class ItemsModel extends ChangeNotifier {
  List<String> items = [];

  ItemsModel() {
    items = List<String>.generate(
      64, (int index) => index.toString(),
      growable: false);
  }

  reorderSongs({required List<String> reorderedItems}) {
    items = reorderedItems;
    notifyListeners();
  }

}
