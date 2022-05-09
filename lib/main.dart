import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init('settingsContainer');
  runApp(const StorageApp());
}

class StorageApp extends StatefulWidget {
  const StorageApp({Key? key}) : super(key: key);

  @override
  State<StorageApp> createState() => _StorageAppState();
}

class _StorageAppState extends State<StorageApp> {
  final data = GetStorage('settingsContainer');
  Map<String, dynamic> settings = {};

  Map<String, bool> defaultSettings = {
    "sound enabled": false,
    "music enabled": false,
    "show notifications": false,
  };

  @override
  void initState() {
    settings = data.read('settings') ?? defaultSettings;
    super.initState();

    data.listen(() {
      print("data saved.");
    });

    data.listenKey('settings', (value) {
      print("settings saved.");
     });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('Get storage Example: ' + (data.read('example') ?? 'n/a')),
      ),
      body: Center(
          child: Column(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: settings.length,
            itemBuilder: (BuildContext context, int index) {
              String key = settings.keys.elementAt(index);
              return CheckboxListTile(
                title: Text(key),
                value: settings[key],
                onChanged: (value) {
                  setState(() {
                    settings[key] = value;
                  });
                },
              );
            }
          ),
          ElevatedButton(
              child: Text('Save Settings'),
              onPressed: () async {
                await data.write('settings', settings);
                setState(() {
                  print('saved.');
                });
              }),
          ElevatedButton(
              child: Text('Clear me'),
              onPressed: () async {
                await data.erase();
                setState(() {
                  print('cleared.');
                });
              }),
        ],
      )),
    ));
  }
}
