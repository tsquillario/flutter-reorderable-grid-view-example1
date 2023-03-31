import 'package:flutter/material.dart';

class ItemsModel extends ChangeNotifier {
  List<String> items = [];
  double defaultSize = 600;

  ItemsModel() {
    items = List<String>.generate(64, (int index) => index.toString(),
        growable: false);
  }

  reorderSongs({required List<String> reorderedItems}) {
    items = reorderedItems;
    notifyListeners();
  }

  zoomIn() {
    defaultSize = defaultSize + 200;
    notifyListeners();
  }

  zoomOut() {
    defaultSize = defaultSize - 200;
    notifyListeners();
  }
}
