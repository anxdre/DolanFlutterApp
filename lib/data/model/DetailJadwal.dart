// To parse this JSON data, do
//
//     final detailJadwal = detailJadwalFromJson(jsonString);

import 'dart:convert';

import 'package:dolan/data/model/Dolanan.dart';

DetailJadwal detailJadwalFromJson(String str) =>
    DetailJadwal.fromJson(json.decode(str));

String detailJadwalToJson(DetailJadwal data) => json.encode(data.toJson());

class DetailJadwal {
  int? id;
  DateTime? tanggal;
  String? jam;
  String? lokasi;
  String? alamat;
  int? dolananId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Dolanan? dolanan;

  DetailJadwal({
    this.id,
    this.tanggal,
    this.jam,
    this.lokasi,
    this.alamat,
    this.dolananId,
    this.createdAt,
    this.updatedAt,
    this.dolanan,
  });

  factory DetailJadwal.fromJson(Map<String, dynamic> json) => DetailJadwal(
        id: json["id"],
        tanggal:
            json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
        jam: json["jam"],
        lokasi: json["lokasi"],
        alamat: json["alamat"],
        dolananId: json["dolanan_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        dolanan:
            json["dolanan"] == null ? null : Dolanan.fromJson(json["dolanan"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tanggal": tanggal?.toIso8601String(),
        "jam": jam,
        "lokasi": lokasi,
        "alamat": alamat,
        "dolanan_id": dolananId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "dolanan": dolanan?.toJson(),
      };
}
