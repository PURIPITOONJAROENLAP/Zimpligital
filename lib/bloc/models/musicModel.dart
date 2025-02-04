import 'dart:convert';

MusicModel musicModelFromJson(String str) => MusicModel.fromJson(json.decode(str));
String musicModelToJson(MusicModel data) => json.encode(data.toJson());

class MusicModel {
  MusicModel({
    this.title,
    this.artist,
    this.src,
    this.imageCover,
    this.album,
    this.time,
  });

  String? title;
  String? artist;
  String? src;
  String? imageCover;
  String? album;
  Duration? time;

  factory MusicModel.fromJson(Map<String, dynamic> json) => MusicModel(
    title: json["title"],
    artist: json["artist"],
    src: json["src"],
    imageCover: json["imageCover"],
    album: json["album"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "artist": artist,
    "src": src,
    "imageCover": imageCover,
    "album": album,
    "time": time,
  };
}