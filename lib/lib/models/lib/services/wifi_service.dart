import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/wifi_network.dart';

class WiFiService extends ChangeNotifier {
  final NetworkInfo _networkInfo = NetworkInfo();
  
  List<WiFiNetwork> _networks = [];
  List<ConnectedDevice> _devices = [];
  WiFiNetwork? _currentNetwork;
  bool _isScanning = false;
  bool _isMonitoring = false;
  Timer? _monitorTimer;
  
  List<WiFiNetwork> get networks => _networks;
  List<ConnectedDevice> get devices => _devices;
  WiFiNetwork? get currentNetwork => _currentNetwork;
  bool get isScanning => _isScanning;
  bool get isMonitoring => _isMonitoring;

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationWhenInUse,
    ].request();
    
    return statuses.values.every((status) => status.isGranted);
  }

  Future<void> startScan() async {
    if (_isScanning) return;
    
    _isScanning = true;
    notifyListeners();

    try {
      final ssid = await _networkInfo.getWifiName();
      final bssid = await _networkInfo.getWifiBSSID();
      final ip = await _networkInfo.getWifiIP();
      
      _networks = _generateMockNetworks();
      _devices = _generateMockDevices();
      
      if (ssid != null) {
        _currentNetwork = WiFiNetwork(
          ssid: ssid.replaceAll('"', ''),
          bssid: bssid ?? 'Unknown',
          rssi: -45,
          frequency: 5180,
          security: 'WPA3',
          channel: 36,
          isConnected: true,
          ipAddress: ip ?? 'Unknown',
          gateway: '192.168.1.1',
          subnetMask: '255.255.255.0',
          dns: '8.8.8.8',
          connectedDevices: _devices,
        );
      }
      
    } catch (e) {
      debugPrint('Error scanning networks: $e');
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<void> blockDevice(String macAddress) async {
    final index = _devices.indexWhere((d) => d.mac == macAddress);
    if (index != -1) {
      _devices[index] = ConnectedDevice(
        ip: _devices[index].ip,
        mac: _devices[index].mac,
        hostname: _devices[index].hostname,
        vendor: _devices[index].vendor,
        isBlocked: true,
        isOnline: _devices[index].isOnline,
        bandwidthUsage: _devices[index].bandwidthUsage,
        deviceType: _devices[index].deviceType,
      );
      notifyListeners();
    }
  }

  Future<void> unblockDevice(String macAddress) async {
    final index = _devices.indexWhere((d) => d.mac == macAddress);
    if (index != -1) {
      _devices[index] = ConnectedDevice(
        ip: _devices[index].ip,
        mac: _devices[index].mac,
        hostname: _devices[index].hostname,
        vendor: _devices[index].vendor,
        isBlocked: false,
        isOnline: _devices[index].isOnline,
        bandwidthUsage: _devices[index].bandwidthUsage,
        deviceType: _devices[index].deviceType,
      );
      notifyListeners();
    }
  }

  void startMonitoring() {
    _isMonitoring = true;
    _monitorTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      notifyListeners();
    });
    notifyListeners();
  }

  void stopMonitoring() {
    _isMonitoring = false;
    _monitorTimer?.cancel();
    notifyListeners();
  }

  List<WiFiNetwork> _generateMockNetworks() {
    return [
      WiFiNetwork(
        ssid: 'Home_Network_5G',
        bssid: 'AA:BB:CC:DD:EE:01',
        rssi: -45,
        frequency: 5180,
        security: 'WPA3',
        channel: 36,
        isConnected: true,
      ),
      WiFiNetwork(
        ssid: 'Neighbor_WiFi',
        bssid: 'AA:BB:CC:DD:EE:02',
        rssi: -67,
        frequency: 2412,
        security: 'WPA2',
        channel: 1,
      ),
      WiFiNetwork(
        ssid: 'Coffee_Shop_Free',
        bssid: 'AA:BB:CC:DD:EE:03',
        rssi: -72,
        frequency: 2437,
        security: 'Open',
        channel: 6,
      ),
      WiFiNetwork(
        ssid: 'Office_Network',
        bssid: 'AA:BB:CC:DD:EE:04',
        rssi: -55,
        frequency: 2462,
        security: 'WPA2',
        channel: 11,
      ),
      WiFiNetwork(
        ssid: 'IoT_Devices',
        bssid: 'AA:BB:CC:DD:EE:05',
        rssi: -78,
        frequency: 2412,
        security: 'WPA2',
        channel: 1,
      ),
      WiFiNetwork(
        ssid: 'Guest_WiFi',
        bssid: 'AA:BB:CC:DD:EE:06',
        rssi: -60,
        frequency: 2437,
        security: 'WPA',
        channel: 6,
      ),
    ];
  }

  List<ConnectedDevice> _generateMockDevices() {
    return [
      ConnectedDevice(
        ip: '192.168.1.100',
        mac: 'AA:BB:CC:DD:EE:F1',
        hostname: 'iPhone-User',
        vendor: 'Apple Inc.',
        isOnline: true,
        bandwidthUsage: 25.5,
        deviceType: 'phone',
      ),
      ConnectedDevice(
        ip: '192.168.1.101',
        mac: 'AA:BB:CC:DD:EE:F2',
        hostname: 'MacBook-Pro',
        vendor: 'Apple Inc.',
        isOnline: true,
        bandwidthUsage: 45.2,
        deviceType: 'laptop',
      ),
      ConnectedDevice(
        ip: '192.168.1.102',
        mac: 'AA:BB:CC:DD:EE:F3',
        hostname: 'Android-Phone',
        vendor: 'Samsung',
        isOnline: true,
        bandwidthUsage: 15.8,
        deviceType: 'phone',
      ),
      ConnectedDevice(
        ip: '192.168.1.103',
        mac: 'AA:BB:CC:DD:EE:F4',
        hostname: 'Smart-TV',
        vendor: 'LG Electronics',
        isOnline: true,
        bandwidthUsage: 30.1,
        deviceType: 'tv',
      ),
      ConnectedDevice(
        ip: '192.168.1.104',
        mac: 'AA:BB:CC:DD:EE:F5',
        hostname: 'Unknown-Device',
        vendor: 'Unknown',
        isOnline: true,
        bandwidthUsage: 5.3,
        deviceType: 'unknown',
      ),
    ];
  }

  @override
  void dispose() {
    _monitorTimer?.cancel();
    super.dispose();
  }
}
