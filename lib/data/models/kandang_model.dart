class Kandang {
  int? id;
  String namaKandang;
  String lokasiLat;
  String lokasiLng;
  int kapasitas;

  Kandang({
    this.id,
    required this.namaKandang,
    required this.lokasiLat,
    required this.lokasiLng,
    required this.kapasitas,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nama_kandang': namaKandang,
      'lokasi_lat': lokasiLat,
      'lokasi_lng': lokasiLng,
      'kapasitas': kapasitas,
    };
  }

  factory Kandang.fromMap(Map<String, dynamic> map) {
    return Kandang(
      id: map['id'],
      namaKandang: map['nama_kandang'],
      lokasiLat: map['lokasi_lat'],
      lokasiLng: map['lokasi_lng'],
      kapasitas: map['kapasitas'],
    );
  }
}
