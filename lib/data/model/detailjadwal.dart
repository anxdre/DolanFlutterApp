class DetailJadwal {
  int id;
  String foto;
  String informasiDolanan;
  String alamat;
  String namaTempat;
  String tanggal;
  String jam;
  int jumlahPemain;
  List pemain;


DetailJadwal({
    required this.id,
    required this.foto,
    required this.informasiDolanan,
    required this.alamat,
    required this.namaTempat,
    required this.tanggal,
    required this.jam,
    required this.jumlahPemain,
    required this.pemain
  });

 factory DetailJadwal.fromJSON(Map<String, dynamic> json) {
  return DetailJadwal(
    id: json["id"] as int,
    foto: json["foto"] as String,
    informasiDolanan: json["informasiDolanan"] as String,
    alamat: json["alamat"] as String,
    namaTempat: json["namaTempat"] as String,
    tanggal: json["tanggal"] as String,
    jam: json["jam"] as String,
    jumlahPemain: json["jumlahPemain"] as int,
    pemain: json["pemain"]
 
  );
 }
}

List<DetailJadwal> DJs=[];