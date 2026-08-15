import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wifi_service.dart';
import '../models/wifi_network.dart';

class AnalyzerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wifiService = Provider.of<WiFiService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Анализатор WiFi'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: wifiService.networks.length,
        itemBuilder: (context, index) {
          final network = wifiService.networks[index];
          return _buildNetworkCard(context, network);
        },
      ),
    );
  }

  Widget _buildNetworkCard(BuildContext context, WiFiNetwork network) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          network.isConnected ? Icons.wifi : Icons.wifi_outlined,
          color: _getSignalColor(network.rssi),
          size: 30,
        ),
        title: Text(
          network.ssid,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Канал: ${network.channel} • ${network.frequencyBand}'),
            Text('Безопасность: ${network.security}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${network.rssi} dBm',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getSignalColor(network.rssi),
              ),
            ),
            Text(
              network.signalCategory,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSignalColor(int rssi) {
    if (rssi >= -50) return Colors.green;
    if (rssi >= -70) return Colors.orange;
    return Colors.red;
  }
}
