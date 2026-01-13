import 'package:aura/features/company/data/model/company_settings_model.dart';
import 'package:aura/features/company/data/repository/company_settings_repository.dart';
import 'package:flutter/material.dart';

class CompanySettingsController extends ChangeNotifier {
  final CompanySettingsRepository _repository;

  CompanySettingsController(this._repository);

  CompanySettingsModel? settings;
  bool isLoading = false;
  String? errorMessage;

  Future<bool> saveSettings(CompanySettingsModel newSettings) async {
    _setLoading(true);
    try {
      settings = await _repository.saveMyCompanySettings(newSettings);
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = "Error saving settings: ${e.toString()}";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
