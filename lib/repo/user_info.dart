import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:spotify_clone/models/song_model.dart';

class UserInformationProvider extends ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  bool isSongLiked = false;

  //update last play song on firebase
  Future<void> updateLastPlayedSong(
      {required String id,required String userId}) async {
    try {
      // Reference to the user's document in the Firestore
      final userDocRef = _fireStore.collection('users').doc(userId);
      await userDocRef.set({
        'lastPlayedSong': {
          'song_id':id,
        },
      }, SetOptions(merge: true));
      if (kDebugMode) {
        print("Last played song updated successfully");
      }
    } catch (e) {
      print('Error updating last played song: $e');
    }
  }

  // Check if the user document exists and create it if not
  Future<bool> isUserDocumentExists(String userId) async {
    final userDocRef = _fireStore.collection('users').doc(userId);
    final userDocSnapshot = await userDocRef.get();

    if (!userDocSnapshot.exists) {
      return true;
    }
    return false;
  }

  // Method to fetch last played song for a specific user
  Stream<SongModel?> getLastPlayedSong(String userId) {
    return _fireStore.collection('users').doc(userId).snapshots().asyncMap((userDocSnapshot) async {
      if (userDocSnapshot.exists) {
        // Get the last played song data from the user's document
        final lastPlayedSongData = userDocSnapshot.data()?['lastPlayedSong'] as Map<String, dynamic>?;

        // Check if lastPlayedSongData is not null and contains a songId
        if (lastPlayedSongData != null && lastPlayedSongData.containsKey('song_id')) {
          final songId = lastPlayedSongData['song_id'];
          final songDocSnapshot = await _fireStore.collection('all_songs').doc(songId).get();
          if (songDocSnapshot.exists) {
            final song = SongModel.fromFirestore(songDocSnapshot);
            return song;
          } else {
            return null;
          }
        }
      }
      // If there's no last played song data or the user document doesn't exist, return null
      return null;
    });
  }

  //update like list on firebase
  Future<void> updateLikedSong({required String songId, required String? userId}) async {
    if(userId == null) return;

    try {
      final userDocRef = _fireStore.collection('users').doc(userId);
      final userDocSnapshot = await userDocRef.get();
      if (!userDocSnapshot.exists) {
        // If the user document doesn't exist, create it with the likedSongs field
        await userDocRef.set({'likedSongs': [songId]});
      } else if(userDocSnapshot.exists){
        // If the user document exists, check if likedSongs field exists
        if (userDocSnapshot.data()?.containsKey('likedSongs') == true) {
          final List<dynamic>? likedSongs = userDocSnapshot.data()?['likedSongs'];
          if (likedSongs != null && !likedSongs.contains(songId)) {
            likedSongs.add(songId);
            await userDocRef.update({'likedSongs': likedSongs});
          }
        } else {
          // If the likedSongs field doesn't exist, create it
          await userDocRef.set({'likedSongs': [songId]}, SetOptions(merge: true));
        }
      }
      await getIsSongLiked(songId: songId,userId: userId);
      print("Song added to liked songs successfully");
    } catch (e) {
      print('Error updating liked songs: $e');
    }
  }

  //get song is present in liked list or not
  Future<void> getIsSongLiked({required String songId, required String? userId}) async {
    try {
      final userDocRef = _fireStore.collection('users').doc(userId);
      final userDocSnapshot = await userDocRef.get();
      if (userDocSnapshot.exists) {
        final List<dynamic>? likedSongs = userDocSnapshot.data()?['likedSongs'];
        if (likedSongs != null && likedSongs.contains(songId)) {
           isSongLiked = true;
        }else{
          isSongLiked = false;
        }
      }else{
        isSongLiked =false;
      }

      notifyListeners();
    } catch (e) {
      print('Error checking if song is liked: $e');
      return;
    }
  }


  //remove song Id from liked songs
  Future<void> removeLikedSong({required String songId, required String? userId}) async {
    try {
      final userDocRef = _fireStore.collection('users').doc(userId);
      final userDocSnapshot = await userDocRef.get();
      if (userDocSnapshot.exists) {
        final List<dynamic>? likedSongs = userDocSnapshot.data()?['likedSongs'];
        if (likedSongs != null && likedSongs.contains(songId)) {
          likedSongs.remove(songId);
          await userDocRef.update({'likedSongs': likedSongs});
        }
      }
      await getIsSongLiked(songId: songId,userId: userId);
      if (kDebugMode) {
        print("Song removed from liked songs successfully");
      }
    } catch (e) {
      print('Error removing liked song: $e');
    }
  }

  // Get the list of liked songs for a particular user and map to SongModel
  Stream<List<SongModel>> getLikedSongsForUser(String? userId) {
    if(userId==null)return [] as Stream<List<SongModel>> ;
    return _fireStore.collection('users').doc(userId).snapshots().asyncMap((userDocSnapshot) async {
      final likedSongs = userDocSnapshot.data()?['likedSongs'] as List<dynamic>?;
      if (likedSongs != null) {
        final List<SongModel> songs = [];
        for (final songId in likedSongs) {
          final songDocSnapshot = await _fireStore.collection('all_songs').doc(songId).get();
          if (songDocSnapshot.exists) {
            final song = SongModel.fromFirestore(songDocSnapshot);
            songs.add(song);
          }
        }
        return songs;
      } else {
        return [];
      }
    });
  }
}
