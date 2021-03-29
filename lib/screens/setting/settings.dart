import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _passwordStart = true;
  bool _biometric = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Setting'),
        centerTitle: true,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: 'Keselamatan',
            tiles: [
              SettingsTile.switchTile(
                title: 'Password dulu bey',
                subtitle: 'Masukkan password apabila aplikasi di mula',
                leading: Icon(
                  Icons.lock,
                ),
                onToggle: (bool value) {
                  setState(() {
                    _passwordStart = value;
                  });
                },
                switchValue: _passwordStart,
              ),
              SettingsTile.switchTile(
                title: 'Gunakan Biometrik',
                subtitle: 'Guna biometrik berbanding PIN biasa',
                leading: Icon(
                  Icons.fingerprint,
                ),
                onToggle: (bool value) {
                  setState(() {
                    _biometric = value;
                  });
                },
                switchValue: _biometric,
              ),
            ],
          ),
          SettingsSection(
            title: 'Local Database (SQlite)',
            tiles: [
              SettingsTile(
                title: 'Simpan ke storan awan',
                subtitle: 'Simpan segala Local DB ke storan awan',
                leading: Icon(
                  Icons.backup,
                ),
                onPressed: (value) {},
              ),
              SettingsTile(
                title: 'Muat turun dari storan awan',
                subtitle: 'Muat turun segala Local DB dari storan awan',
                leading: Icon(
                  Icons.cloud_download,
                ),
                onPressed: (value) {},
              ),
              SettingsTile(
                title: 'Export ke peranti',
                subtitle: 'Simpan segala Local DB ke  peranti ini',
                leading: Icon(
                  Icons.save_alt,
                ),
                onPressed: (value) {},
              ),
              SettingsTile(
                title: 'Import dari peranti',
                subtitle: 'Import segala Local DB dari peranti ini',
                leading: Icon(
                  Icons.drive_folder_upload,
                ),
                onPressed: (value) {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
