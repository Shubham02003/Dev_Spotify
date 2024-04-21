import 'package:cloud_firestore/cloud_firestore.dart';
class SongModel {
  final String coverImage;
  final String name;
  final String songPath;
  final String artist;
  final String id;
  final int numberOfTimesPlayed; // New parameter

  SongModel({
    required this.coverImage,
    required this.name,
    required this.songPath,
    required this.artist,
    required this.id,
    required this.numberOfTimesPlayed, // Default value
  });

  // A factory method to create a Song object from a Firestore document snapshot
  factory SongModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SongModel(
      coverImage: data['cover_img'] ?? '',
      name: data['name'] ?? '',
      songPath: data['song'] ?? '',
      artist: data["artist"] ?? '',
      id: data["id"] ?? '',
      numberOfTimesPlayed: data["numberOfTimesPlayed"] ?? 0, // Default value
    );
  }
}
