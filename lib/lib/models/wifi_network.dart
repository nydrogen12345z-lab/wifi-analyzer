class WiFiNetwork {
  final String ssid;
  final String bssid;
  final int rssi;
  final int frequency;
  final String security;
  final int channel;
  final bool isConnected;
  final List<ConnectedDevice> connectedDevices;
  final String ipAddress;
  final String gateway;
  final String subnetMask;
  final String dns;

  WiFiNetwork({
    required this.ssid,
    required this.bssid,
    required this.rssi,
    required this.frequency,
    required this.security,
    required this.channel,
    this.isConnected = false,
    this.connectedDevices = const [],
    this.ipAddress = '',
    this.gateway = '',
    this.subnetMask = '',
    this.dns = '',
  });

  int get signalQuality {
    if (rssi >= -50) return 100;
    if (rssi <= -100) return 0;
    return ((rssi + 100) * 2).clamp(0, 100);
  }

  String get signalCategory {
    if (signalQuality >= 80) return 'Отличный';
    if (signalQuality >= 60) return 'Хороший';
    if (signalQuality >= 40) return 'Средний';
    if (signalQuality >= 20) return 'Слабый';
    return 'Очень слабый';
  }

  String get frequencyBand {
    return frequency >= 5000 ? '5 GHz' : '2.4 GHz';
  }
}

class ConnectedDevice {
  final String ip;
  final String mac;
  final String hostname;
  final String vendor;
  final bool isBlocked;
  final bool isOnline;
  final double bandwidthUsage;
  final String deviceType;

  ConnectedDevice({
    required this.ip,
    required this.mac,
    required this.hostname,
    required this.vendor,
    this.isBlocked = false,
    this.isOnline = true,
    this.bandwidthUsage = 0,
    this.deviceType = 'unknown',
  });
}
