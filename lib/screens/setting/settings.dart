import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:services_form/brain/auth_services.dart';
import 'package:services_form/brain/constant.dart';
import 'package:services_form/screens/setting/savecloud_confirmation.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share/share.dart';
import 'downloadcloud_confirmation.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:services_form/brain/setting_provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _result = '...';

  filePicker(String location) async {
    _result = await FilePicker.getFilePath(
      type: FileType.ANY,
      fileExtension: ('db'),
    );

    if (_result != null) {
      File file = File(_result);
      showToast('Berjaya!', position: ToastPosition.bottom);
      return await file.copy(location);
    } else {
      print('Tak jadi nak pilih');
    }
  }

  @override
  void initState() {
    // checkSave();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
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
                    // _passwordStart = value;
                    Provider.of<SettingsProvider>(context, listen: false)
                        .passwordStart = value;
                    // _saveBoolPass(_passwordStart);
                    Provider.of<SettingsProvider>(context, listen: false)
                        .saveBoolPass(value);
                  });
                },
                switchValue: Provider.of<SettingsProvider>(
                  context,
                ).passwordStart,
              ),
              SettingsTile.switchTile(
                title: 'Gunakan Biometrik',
                subtitle: 'Guna biometrik berbanding PIN biasa',
                leading: Icon(
                  Icons.fingerprint,
                ),
                onToggle: (bool value) {
                  setState(() {
                    Provider.of<SettingsProvider>(context, listen: false)
                        .biometric = value;
                    Provider.of<SettingsProvider>(context, listen: false)
                        .saveBoolBio(value);
                    // _biometric = value;
                    // _saveBoolBio(_biometric);
                  });
                },
                switchValue: Provider.of<SettingsProvider>(context).biometric,
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
            title: 'Akaun',
            tiles: [
              SettingsTile(
                title: 'Email pengurus',
                subtitle: 'akidfikriazhar@gmail.com',
                leading: Icon(Icons.email),
                onPressed: (value) {},
              ),
              SettingsTile(
                title: 'Log keluar',
                subtitle: 'Kembali ke halaman log masuk',
                leading: Icon(Icons.logout),
                onPressed: (value) async {
                  await context.read<AuthenticationService>().signOut();
                  Navigator.pop(context);
                  SystemChrome.setSystemUIOverlayStyle(
                    SystemUiOverlayStyle(
                        systemNavigationBarColor:
                            isDarkMode ? Color(0xff212121) : Colors.white,
                        systemNavigationBarIconBrightness: isDarkMode == true
                            ? Brightness.light
                            : Brightness.dark,
                        statusBarIconBrightness: isDarkMode == true
                            ? Brightness.light
                            : Brightness.dark),
                  );
                  Navigator.pushReplacementNamed(context, 'authwrapper');
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
