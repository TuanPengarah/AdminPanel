import 'package:flutter/material.dart';
import 'package:services_form/brain/constant.dart';
import 'package:services_form/screens/setting/savecloud_confirmation.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'downloadcloud_confirmation.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _passwordStart = true;
  bool _biometric = false;
  String _result = '...';

  _saveBoolPass(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _passwordStart = prefs.getBool('passwordStart' ?? true);
    _passwordStart = value;
    await prefs.setBool('passwordStart', _passwordStart);
  }

  _saveBoolBio(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _biometric = prefs.getBool('biometric' ?? false);
    _biometric = value;
    await prefs.setBool('biometric', _biometric);
  }

  filePicker(String location) async {
    _result = await FilePicker.getFilePath(
      type: FileType.ANY,
      fileExtension: ('db'),
    );

    if (_result != null) {
      File file = File(_result);
      print('$_result');
      return await file.copy(location);
    } else {
      print('Tak jadi nak pilih');
    }
  }

  checkSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _passwordStart != null
          ? _passwordStart = prefs.getBool('passwordStart')
          : _passwordStart = true;
      _biometric != null
          ? _biometric = prefs.getBool('biometric')
          : _biometric = false;
    });

    return _passwordStart;
  }

  @override
  void initState() {
    checkSave();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Ejah bui sedak'),
        centerTitle: true,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: 'Keselamatan',
            tiles: [
              SettingsTile.switchTile(
                title: 'Password dulu bey',
                subtitle: 'Mula aplikasi dengan password',
                leading: Icon(
                  Icons.lock,
                ),
                onToggle: (bool value) {
                  setState(() {
                    _passwordStart = value;
                    print('password start $_passwordStart');
                    _saveBoolPass(_passwordStart);
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
                    _saveBoolBio(_biometric);
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
                subtitle: 'Simpan segala SQLite DB ke storan awan',
                leading: Icon(
                  Icons.backup,
                ),
                onPressed: (value) {
                  saveDBToCloud(context);
                },
              ),
              SettingsTile(
                title: 'Muat turun dari storan awan',
                subtitle: 'Muat turun segala SQLite DB dari storan awan',
                leading: Icon(
                  Icons.cloud_download,
                ),
                onPressed: (value) {
                  downloadDBInCloud(context);
                },
              ),
              SettingsTile(
                title: 'Export ke peranti',
                subtitle: 'Simpan segala SQLite DB ke peranti ini',
                leading: Icon(
                  Icons.save_alt,
                ),
                onPressed: (value) {
                  Share.shareFiles([kcfLocation]);
                },
              ),
              SettingsTile(
                title: 'Import dari peranti',
                subtitle: 'Import segala SQLite DB dari peranti ini',
                leading: Icon(
                  Icons.drive_folder_upload,
                ),
                onPressed: (value) {
                  filePicker(kcfLocation);
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Maklumat',
            tiles: [
              SettingsTile(
                onPressed: (value) {},
                leading: Icon(Icons.android),
                title: 'Maklumat Aplikasi',
                subtitle: 'Versi 0.15.2',
              ),
              SettingsTile(
                onPressed: (value) {},
                leading: Icon(Icons.notes),
                title: 'Dibangunkan oleh: ',
                subtitle: 'Akid Fikri Azhar',
              ),
            ],
          )
        ],
      ),
    );
  }
}
