import 'package:flutter/material.dart';
import 'package:yuppi_app/features/auth/dominio/entities/parent.dart';

class ParentProvider with ChangeNotifier {
  Parent? _parent;

  Parent? get parent => _parent;

  void setParent(Parent parent) {
    _parent = parent;
    notifyListeners();
  }

  void updateParent(Parent updated) {
    _parent = updated;
    notifyListeners();
  }

  void clear() {
    _parent = null;
    notifyListeners();
  }
}
