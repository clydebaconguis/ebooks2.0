import 'package:flutter/material.dart';

import '../models/pdf_tile.dart';

class NavigationProvider2 extends ChangeNotifier {
  String _selectedPdf = '';
  bool _isCollapsed = false;
  List<PdfTile> _files = [];

  String get selectedpdf => _selectedPdf;
  bool get isCollapsed => _isCollapsed;
  List<PdfTile> get files => _files;

  void toggleIsCollapsed2() {
    _isCollapsed = !isCollapsed;
    notifyListeners();
  }

  void selectPdf(String title) {
    _selectedPdf = title;
    notifyListeners();
  }

  void saveBooksList(List<PdfTile> files, String book) {
    _files = files;
    notifyListeners();
  }
}
