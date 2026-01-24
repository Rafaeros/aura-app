import 'package:flutter/material.dart';
import 'package:aura/features/devices/data/models/device_model.dart';
import 'package:aura/features/devices/data/repository/device_repository.dart';

class DeviceController extends ChangeNotifier {
  DeviceRepository _repository;

  DeviceController(this._repository);

  List<DeviceModel> devices = [];

  int _currentPage = 0;
  final int _pageSize = 10;
  bool isLastPage = false;
  bool isLoading = false;
  String? errorMessage;

  void updateRepo(DeviceRepository newRepo) {
    _repository = newRepo;
  }

  Future<void> loadDevices({bool refresh = false}) async {
    if (isLoading) return;
    if (!refresh && isLastPage) return;

    _setLoading(true);

    if (refresh) {
      _currentPage = 0;
      isLastPage = false;
    }

    try {
      final response = await _repository.getDevices(
        page: _currentPage,
        size: _pageSize,
      );

      if (refresh) {
        devices = response.content;
      } else {
        devices.addAll(response.content);
      }

      isLastPage = response.last;
      _currentPage++;
      errorMessage = null;
    } catch (e) {
      errorMessage = "Erro ao carregar dispositivos: ${e.toString()}";
    } finally {
      _setLoading(false);
    }
  }

  Future<DeviceModel?> getDeviceById(int id) async {
    try {
      final device = await _repository.getDeviceById(id);
      final index = devices.indexWhere((d) => d.id == id);
      if (index != -1) {
        devices[index] = device;
        notifyListeners();
      }

      return device;
    } catch (e) {
      errorMessage = "Erro ao carregar detalhes: ${e.toString()}";
      return null;
    }
  }

  Future<void> registerDevice(String name, String devEui) async {
    _setLoading(true);
    try {
      final newDevicePartial = DeviceModel(name: name, devEui: devEui);

      await _repository.createDevice(newDevicePartial);
      await loadDevices(refresh: true);
    } catch (e) {
      errorMessage = "Erro ao adicionar: ${e.toString()}";
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteDevice(int deviceId) async {
    try {
      await _repository.deleteDevice(deviceId);
      devices.removeWhere((d) => d.id == deviceId);
      notifyListeners();
    } catch (e) {
      errorMessage = "Erro ao excluir: ${e.toString()}";
      notifyListeners();
      rethrow;
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
