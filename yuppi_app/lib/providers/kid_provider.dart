import 'package:flutter/material.dart';
import 'package:yuppi_app/features/auth/dominio/entities/kid.dart';

class KidProvider with ChangeNotifier {
  Kid? _selectedKid;
  int correctFigures = 0;
  int correctColors = 0;

  Kid? get selectedKid => _selectedKid;

  void setKid(Kid kid) {
    _selectedKid = kid;
    notifyListeners();
  }

  void updateKid(Kid updated) {
    _selectedKid = updated;
    notifyListeners();
  }

  void clear() {
    _selectedKid = null;
    notifyListeners();
  }

  void updateCorrectExercises({int? figures, int? colors}) {
    if (figures != null) correctFigures = figures;
    if (colors != null) correctColors = colors;
    notifyListeners();
  }

  void updatecountfigure(int? figures) {
    if (figures != null) correctFigures = figures;
    notifyListeners();
  }

  void updatecountcolor(int? colors) {
    if (colors != null) correctColors = colors;
    notifyListeners();
  }
}
