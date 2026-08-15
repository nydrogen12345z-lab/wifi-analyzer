import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'analyzer_screen.dart';
import 'device_manager_screen.dart';
import 'settings_screen.dart';
import '../services/wifi_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wifiService = Provider.of<WiFiService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('WiFi Analyzer Pro'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (wifiService.currentNetwork != null)
              _buildCurrentNetworkCard(context, wifiService.currentNetwork!),
            
            SizedBox(height: 20),
            
            _buildQuickActions(context),
            
            SizedBox(height: 20),
            
            _buildConnectedDevices(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => wifiService.startScan(),
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildCurrentNetworkCard(BuildContext context, dynamic network) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.wifi, color: Colors.green, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        network.ssid,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Подключено • ${network.frequencyBand}',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${network.rssi} dBm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNetworkInfo('IP', network.ipAddress),
                _buildNetworkInfo('Шлюз', network.gateway),
                _buildNetworkInfo('DNS', network.dns),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            'Анализатор',
            Icons.network_check,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnalyzerScreen()),
              );
            },
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            context,
            'Устройства',
            Icons.devices_other,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeviceManagerScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.blue[700],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildConnectedDevices(BuildContext context) {
    final wifiService = Provider.of<WiFiService>(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Подключенные устройства',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeviceManagerScreen()),
                );
              },
              child: Text('Все'),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...wifiService.devices.take(3).map((device) {
          return ListTile(
            leading: Icon(
              device.isBlocked ? Icons.block : Icons.devices,
              color: device.isBlocked ? Colors.red : Colors.green,
            ),
            title: Text(device.hostname),
            subtitle: Text('${device.ip} • ${device.vendor}'),
            trailing: Text(
              '${device.bandwidthUsage} MB/s',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ],
    );
  }
}
