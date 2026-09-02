class ProfilModel {
  final String nama;
  final String nim;
  final String prodi;
  final String angkatan;
  final String dosenWali;

  ProfilModel({
    required this.nama,
    required this.nim,
    required this.prodi,
    required this.angkatan,
    required this.dosenWali,
  });

  factory ProfilModel.fromJson(Map<String, dynamic> json) => ProfilModel(
        nama: json['nama'] ?? '',
        nim: json['nim'] ?? '',
        prodi: json['prodi'] ?? '',
        angkatan: json['angkatan'] ?? '',
        dosenWali: json['dosen_wali'] ?? '',
      );
}

class DetailModel {
  final String nim;
  final String nik;
  final String email;
  final String agama;
  final String statusKawin;
  final String jenisKelamin;
  final String ttl;
  final String alamat;
  final String noHp;

  DetailModel({
    required this.nim,
    required this.nik,
    required this.email,
    required this.agama,
    required this.statusKawin,
    required this.jenisKelamin,
    required this.ttl,
    required this.alamat,
    required this.noHp,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) => DetailModel(
        nim: json['nim'] ?? '',
        nik: json['nik'] ?? '',
        email: json['email'] ?? '',
        agama: json['agama'] ?? '',
        statusKawin: json['status_kawin'] ?? '-',
        jenisKelamin: json['jenis_kelamin'] ?? '',
        ttl: json['ttl'] ?? '',
        alamat: json['alamat'] ?? '',
        noHp: json['no_hp'] ?? '',
      );
}

class MataKuliahNilai {
  final String no;
  final String kodeMk;
  final String namaMk;
  final int sks;
  final String nilaiAngka;
  final String nilaiHuruf;

  MataKuliahNilai({
    required this.no,
    required this.kodeMk,
    required this.namaMk,
    required this.sks,
    required this.nilaiAngka,
    required this.nilaiHuruf,
  });

  factory MataKuliahNilai.fromJson(Map<String, dynamic> json) => MataKuliahNilai(
        no: json['no']?.toString() ?? '',
        kodeMk: json['kode_mk'] ?? '',
        namaMk: json['nama_mk'] ?? '',
        sks: json['sks'] ?? 0,
        nilaiAngka: json['nilai_angka']?.toString() ?? '-',
        nilaiHuruf: json['nilai_huruf']?.toString() ?? '-',
      );
}

class SemesterRecord {
  final String semester;
  final double ips;
  final int sksSemester;
  final List<MataKuliahNilai> mataKuliah;

  SemesterRecord({
    required this.semester,
    required this.ips,
    required this.sksSemester,
    required this.mataKuliah,
  });

  factory SemesterRecord.fromJson(Map<String, dynamic> json) => SemesterRecord(
        semester: json['semester'] ?? '',
        ips: (json['ips'] ?? 0).toDouble(),
        sksSemester: json['sks_semester'] ?? 0,
        mataKuliah: (json['mata_kuliah'] as List? ?? [])
            .map((e) => MataKuliahNilai.fromJson(e))
            .toList(),
      );
}

class AkademikSummary {
  final double ipkKumulatif;
  final int totalSksKumulatif;

  AkademikSummary({required this.ipkKumulatif, required this.totalSksKumulatif});

  factory AkademikSummary.fromJson(Map<String, dynamic> json) => AkademikSummary(
        ipkKumulatif: (json['ipk_kumulatif'] ?? 0).toDouble(),
        totalSksKumulatif: json['total_sks_kumulatif'] ?? 0,
      );
}

class JadwalItem {
  final String kodeMk;
  final String namaMk;
  final String kodeJadwal;
  final int sks;
  final String keterangan;
  final String? ruangWaktu;
  final String kelas;

  JadwalItem({
    required this.kodeMk,
    required this.namaMk,
    required this.kodeJadwal,
    required this.sks,
    required this.keterangan,
    this.ruangWaktu,
    required this.kelas,
  });

  factory JadwalItem.fromJson(Map<String, dynamic> json) => JadwalItem(
        kodeMk: json['kode_mk'] ?? '',
        namaMk: json['nama_mk'] ?? '',
        kodeJadwal: json['kode_jadwal'] ?? '',
        sks: json['sks'] ?? 0,
        keterangan: json['keterangan'] ?? '',
        ruangWaktu: json['ruang_waktu'],
        kelas: json['kelas'] ?? '',
      );
}

class RegistrasiItem {
  final String semester;
  final int semesterKe;
  final String jumlah;
  final String? tanggalBayar;
  final String metodePembayaran;
  final String statusLunas;

  RegistrasiItem({
    required this.semester,
    required this.semesterKe,
    required this.jumlah,
    this.tanggalBayar,
    required this.metodePembayaran,
    required this.statusLunas,
  });

  factory RegistrasiItem.fromJson(Map<String, dynamic> json) => RegistrasiItem(
        semester: json['semester'] ?? '',
        semesterKe: json['semester_ke'] ?? 0,
        jumlah: json['jumlah'] ?? '',
        tanggalBayar: json['tanggal_bayar'],
        metodePembayaran: json['metode_pembayaran'] ?? '',
        statusLunas: json['status_lunas'] ?? '',
      );
}

class KrsMataKuliah {
  final int no;
  final String kodeMk;
  final String namaMk;
  final int sks;
  final String jenis;
  final String keterangan;
  final String? waktu;
  final String dosen;
  final String statusKrs;

  KrsMataKuliah({
    required this.no,
    required this.kodeMk,
    required this.namaMk,
    required this.sks,
    required this.jenis,
    required this.keterangan,
    this.waktu,
    required this.dosen,
    required this.statusKrs,
  });

  factory KrsMataKuliah.fromJson(Map<String, dynamic> json) => KrsMataKuliah(
        no: json['no'] ?? 0,
        kodeMk: json['kode_mk'] ?? '',
        namaMk: json['nama_mk'] ?? '',
        sks: json['sks'] ?? 0,
        jenis: json['jenis'] ?? '',
        keterangan: json['keterangan'] ?? '',
        waktu: json['waktu'],
        dosen: json['dosen'] ?? '',
        statusKrs: json['status_krs'] ?? '',
      );
}

class KrsInfo {
  final String? periode;
  final String? urlCetakKrs;
  final List<KrsMataKuliah> mataKuliah;

  KrsInfo({
    this.periode,
    this.urlCetakKrs,
    required this.mataKuliah,
  });

  factory KrsInfo.fromJson(Map<String, dynamic> json) => KrsInfo(
        periode: json['periode'],
        urlCetakKrs: json['url_cetak_krs'],
        mataKuliah: (json['mata_kuliah'] as List? ?? [])
            .map((e) => KrsMataKuliah.fromJson(e))
            .toList(),
      );
}

class PengumumanItem {
  final String judul;
  final String url;
  final String deskripsi;

  PengumumanItem({
    required this.judul,
    required this.url,
    required this.deskripsi,
  });

  factory PengumumanItem.fromJson(Map<String, dynamic> json) => PengumumanItem(
        judul: json['judul'] ?? '',
        url: json['url'] ?? '',
        deskripsi: json['deskripsi'] ?? '',
      );
}

class KurikulumMataKuliah {
  final int no;
  final String kodeMk;
  final String namaMk;
  final String statusMk;
  final String jenis;
  final int sks;
  final String sifat;

  KurikulumMataKuliah({
    required this.no,
    required this.kodeMk,
    required this.namaMk,
    required this.statusMk,
    required this.jenis,
    required this.sks,
    required this.sifat,
  });

  factory KurikulumMataKuliah.fromJson(Map<String, dynamic> json) => KurikulumMataKuliah(
        no: json['no'] ?? 0,
        kodeMk: json['kode_mk'] ?? '',
        namaMk: json['nama_mk'] ?? '',
        statusMk: json['status_mk'] ?? '',
        jenis: json['jenis'] ?? '',
        sks: json['sks'] ?? 0,
        sifat: json['sifat'] ?? '',
      );
}

class KurikulumSemester {
  final String semester;
  final int totalSks;
  final List<KurikulumMataKuliah> mataKuliah;

  KurikulumSemester({
    required this.semester,
    required this.totalSks,
    required this.mataKuliah,
  });

  factory KurikulumSemester.fromJson(Map<String, dynamic> json) => KurikulumSemester(
        semester: json['semester'] ?? '',
        totalSks: json['total_sks'] ?? 0,
        mataKuliah: (json['mata_kuliah'] as List? ?? [])
            .map((e) => KurikulumMataKuliah.fromJson(e))
            .toList(),
      );
}

class ScrapeResponse {
  final String status;
  final double elapsedSeconds;
  final String? scrapedAt;
  final ProfilModel profil;
  final DetailModel detail;
  final List<PengumumanItem> pengumuman;
  final AkademikSummary akademikSummary;
  final List<SemesterRecord> riwayatSemester;
  final String? urlTranskripSementara;
  final List<RegistrasiItem> registrasi;
  final String? urlCetakRegistrasi;
  final List<KurikulumSemester> kurikulum;
  final List<JadwalItem> jadwal;
  final KrsInfo krs;

  ScrapeResponse({
    required this.status,
    required this.elapsedSeconds,
    this.scrapedAt,
    required this.profil,
    required this.detail,
    required this.pengumuman,
    required this.akademikSummary,
    required this.riwayatSemester,
    this.urlTranskripSementara,
    required this.registrasi,
    this.urlCetakRegistrasi,
    required this.kurikulum,
    required this.jadwal,
    required this.krs,
  });

  factory ScrapeResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final user = data['user'] ?? {};
    final akademik = data['akademik'] ?? {};

    return ScrapeResponse(
      status: json['status'] ?? 'error',
      elapsedSeconds: (json['elapsed_seconds'] ?? 0).toDouble(),
      scrapedAt: json['scraped_at'],
      profil: ProfilModel.fromJson(user['profil'] ?? {}),
      detail: DetailModel.fromJson(user['detail'] ?? {}),
      pengumuman: (data['pengumuman'] as List? ?? [])
          .map((e) => PengumumanItem.fromJson(e))
          .toList(),
      akademikSummary: AkademikSummary.fromJson(akademik['summary'] ?? {}),
      riwayatSemester: (akademik['riwayat_semester'] as List? ?? [])
          .map((e) => SemesterRecord.fromJson(e))
          .toList(),
      urlTranskripSementara: akademik['url_transkrip_sementara'],
      registrasi: (data['registrasi'] as List? ?? [])
          .map((e) => RegistrasiItem.fromJson(e))
          .toList(),
      urlCetakRegistrasi: data['url_cetak_registrasi'],
      kurikulum: (data['kurikulum'] as List? ?? [])
          .map((e) => KurikulumSemester.fromJson(e))
          .toList(),
      jadwal: (data['jadwal'] as List? ?? [])
          .map((e) => JadwalItem.fromJson(e))
          .toList(),
      krs: KrsInfo.fromJson(data['krs'] ?? {}),
    );
  }
}
