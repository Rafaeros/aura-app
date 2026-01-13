import 'package:flutter/material.dart';

import 'package:aura/features/devices/data/models/device_model.dart';
import 'package:aura/features/devices/data/repository/device_respository.dart';

class DeviceController extends ChangeNotifier {
  DeviceRepository _repository;

  DeviceController(this._repository);

  List<DeviceModel> devices = [];
  bool isLoading = false;
  String? errorMessage;

  void updateRepo(DeviceRepository newRepo) {
    _repository = newRepo;
  }

  Future<void> loadDevices() async {
    _setLoading(true);
    try {
      devices = await _repository.getDevices();
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

  Future<bool> registerDevice(String name, String devEui) async {
    _setLoading(true);
    try {
      final newDevicePartial = DeviceModel(name: name, devEui: devEui);
      await _repository.createDevice(newDevicePartial);
      await loadDevices();

      return true;
    } catch (e) {
      errorMessage = "Erro ao adicionar: ${e.toString()}";
      notifyListeners();
      return false;
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
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
