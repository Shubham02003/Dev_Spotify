import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_clone/models/song_model.dart';
class SongRepository {
  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Function to fetch all songs from the all_songs collection
  Future<List<SongModel>> fetchAllSongs() async {
    List<SongModel> songs = [];
    try {

      CollectionReference allSongsCollection = _firestore.collection('all_songs');
      QuerySnapshot querySnapshot = await allSongsCollection.get();
      for (var doc in querySnapshot.docs) {
        SongModel song = SongModel.fromFirestore(doc);
        songs.add(song);
      }
    } catch (e) {
      print('Failed to fetch songs: $e');
    }
    return songs;
  }

  Future<List<SongModel>> fetchTopPlayedSongs(int limit) async {
    List<SongModel> topSongs = [];
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('all_songs')
          .orderBy('numberOfTimesPlayed', descending: true)
          .limit(limit)
          .get();
      for (var doc in querySnapshot.docs) {
        SongModel song = SongModel.fromFirestore(doc);
        topSongs.add(song);
      }
    } catch (e) {
      print('Failed to fetch top played songs: $e');
    }
    return topSongs;
  }

  Future<void> increaseNumberOfTimesPlayed(String songId) async {
    try {
      final songDocRef = _firestore.collection('all_songs').doc(songId);
      await songDocRef.update({'numberOfTimesPlayed': FieldValue.increment(1)});
    } catch (e) {
      print('Error increasing number of times played: $e');
    }
  }
}