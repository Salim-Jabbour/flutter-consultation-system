import 'dart:convert';

import 'package:akemha/core/utils/services/api_service.dart';
import 'package:akemha/features/device/models/device_log_model.dart';
import 'package:dio/dio.dart';

import '../../../models/device_model.dart';

abstract class DeviceRemoteDataSource {
  Future<List<DeviceModel>> fetchDevicesPage({int pageNumber = 0});

  Future<List<DeviceLogModel>> fetchReservedDevicesPage();

  Future<String> reserveDevice({required int id, required int count});
}

class DeviceRemoteDataSourceImpl extends DeviceRemoteDataSource {
  final Dio dioClient;

  DeviceRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<DeviceModel>> fetchDevicesPage({int pageNumber = 0}) async {
    dioClient.options.headers
        .addAll({'authorization': 'Bearer ${ApiService.token}'});
    final Response response = await dioClient.get('/api/medical-device');
    List<DeviceModel> devices = getDevicesList(response.data);
    return devices;
  }

  @override
  Future<List<DeviceLogModel>> fetchReservedDevicesPage() async {
    dioClient.options.headers
        .addAll({'authorization': 'Bearer ${ApiService.token}'});
    final Response response = await dioClient.get('/api/medical-device/user');
    List<DeviceLogModel> devices = getDevicesLogList(response.data);
    return devices;
  }

  @override
  Future<String> reserveDevice({required int id, required int count}) async {
    dioClient.options.headers
        .addAll({'authorization': 'Bearer ${ApiService.token}'});
    final formData = jsonEncode({
      'quantity': count,
      "medicalDeviceId": id,
    });
    final Response response =
        await dioClient.post('/api/medical-device/reserve', data: formData);
    return response.data['msg'];
  }
}

List<DeviceModel> getDevicesList(Map<String, dynamic> data) {
  List<DeviceModel> devices = [];
  for (var deviceMap in data['data'] ?? []) {
    devices.add(DeviceModel.fromJson(deviceMap));
  }
  return devices;
}

List<DeviceLogModel> getDevicesLogList(Map<String, dynamic> data) {
  List<DeviceLogModel> devices = [];
  for (var deviceLogMap in data['data'] ?? []) {
    devices.add(DeviceLogModel.fromJson(deviceLogMap));
  }
  return devices;
}
