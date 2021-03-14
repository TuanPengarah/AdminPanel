class RepairLogSuggestion {
  static final List<String> log = [
    'Pesanan diterima',
    'Menunggu giliran',
    'Memulakan proses diagnosis',
    'Proses diagnosis selesai',
    'Memulakan proses membaiki',
    'Menyelaraskan sparepart baru kepada peranti anda',
    'Semua alat sparepart baru berfungsi dengan baik',
    'Memasang semula peranti anda',
    'Melakukan proses diagnosis buat kali terakhir',
    'Proses membaiki selesai',
    'Pihak kami cuba untuk menghubungi anda',
    'Maklumat telah diberitahu kepada anda',
    'Selesai'
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(log);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
