import 'package:flutter/material.dart';

import 'package:aura/features/telemetry/data/models/device_telemetry_model.dart';
import 'package:aura/features/telemetry/data/repositories/telemetry_repository.dart';

class TelemetryHistoryController extends ChangeNotifier {
  final TelemetryRepository _repository;

  TelemetryHistoryController(this._repository);
  List<DeviceTelemetryModel> telemetries = [];
  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;

  int _currentPage = 0;
  final int _pageSize = 15;
  bool _isLastPage = false;

  Future<void> refresh(int deviceId) async {
    _currentPage = 0;
    _isLastPage = false;
    telemetries.clear();
    notifyListeners();
    await loadTelemetries(deviceId);
  }

  Future<void> loadTelemetries(int deviceId) async {
    if (isLoading || _isLastPage) return;

    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final response = await _repository.getTelemetriesByDeviceId(
        deviceId: deviceId,
        page: _currentPage,
        size: _pageSize,
      );

      if (response.content.isEmpty) {
        _isLastPage = true;
      } else {
        telemetries.addAll(response.content);
        _currentPage++;

        if (response.content.length < _pageSize) {
          _isLastPage = true;
        }
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
