import 'package:quick_actions/quick_actions.dart';

class ShortcutItems {
  static final items = <ShortcutItem>[
    actionJobsheet,
    actionAllSpareparts,
    actionPOS,
    actionBackup,
  ];

  static final actionJobsheet = const ShortcutItem(
    type: 'action_jobsheet',
    localizedTitle: 'Buat Jobsheet Baru',
    icon: 'icon_create',
  );
  static final actionAllSpareparts = const ShortcutItem(
    type: 'action_allspareparts',
    localizedTitle: 'Semua Spareparts',
    icon: 'icon_inventory',
  );
  static final actionPOS = const ShortcutItem(
    type: 'action_pos',
    localizedTitle: 'Point Of Sales',
    icon: 'icon_pos',
  );
  static final actionBackup = const ShortcutItem(
    type: 'action_backup',
    localizedTitle: 'Backup SQLite',
    icon: 'icon_backup',
  );
}
