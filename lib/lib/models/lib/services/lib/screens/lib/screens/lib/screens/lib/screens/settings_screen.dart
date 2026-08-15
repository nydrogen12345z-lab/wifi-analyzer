import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wifi_service.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wifiService = Provider.of<WiFiService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Мониторинг сети'),
            subtitle: Text('Автоматическое обновление статистики'),
            value: wifiService.isMonitoring,
            onChanged: (value) {
              if (value) {
                wifiService.startMonitoring();
              } else {
                wifiService.stopMonitoring();
              }
            },
          ),
          SwitchListTile(
            title: Text('Уведомления'),
            subtitle: Text('Уведомлять о новых устройствах'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: Text('Автосканирование'),
            subtitle: Text('Сканировать при запуске'),
            value: true,
            onChanged: (value) {},
          ),
          ListTile(
            title: Text('Частота обновления'),
            subtitle: Text('5 секунд'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: Text('Экспорт данных'),
            trailing: Icon(Icons.download),
          ),
          ListTile(
            title: Text('О приложении'),
            subtitle: Text('Версия 1.0.0'),
            trailing: Icon(Icons.info),
          ),
        ],
      ),
    );
  }
}
