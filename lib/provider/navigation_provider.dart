import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  bool _isCollapsed = false;
  String _currentPage = 'Home';

  bool get isCollapsed => _isCollapsed;
  String get currentPage => _currentPage;

  void toggleIsCollapsed() {
    _isCollapsed = !isCollapsed;

    notifyListeners();
  }

  void setNewPage(page) {
    _currentPage = page;

    notifyListeners();
  }
}
