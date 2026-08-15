import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wifi_service.dart';
import '../models/wifi_network.dart';

class DeviceManagerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wifiService = Provider.of<WiFiService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Управление устройствами'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: wifiService.devices.length,
        itemBuilder: (context, index) {
          final device = wifiService.devices[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                _getDeviceIcon(device.deviceType),
                color: device.isBlocked ? Colors.red : Colors.green,
              ),
              title: Text(
                device.hostname,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${device.ip} • ${device.vendor}'),
              trailing: device.isBlocked
                  ? IconButton(
                      icon: Icon(Icons.check_circle, color: Colors.green),
                      onPressed: () {
                        wifiService.unblockDevice(device.mac);
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.block, color: Colors.red),
                      onPressed: () {
                        wifiService.blockDevice(device.mac);
                      },
                    ),
            ),
          );
        },
      ),
    );
  }

  IconData _getDeviceIcon(String type) {
    switch (type) {
      case 'phone':
        return Icons.smartphone;
      case 'laptop':
        return Icons.laptop;
      case 'tv':
        return Icons.tv;
      default:
        return Icons.devices_other;
    }
  }
}
