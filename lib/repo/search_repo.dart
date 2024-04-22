
import 'package:spotify_clone/models/song_model.dart';

class SearchRepo{
  static List<SongModel> searchByName(List<SongModel> songs, String query) {
    List<SongModel> results = [];
    for (var song in songs) {
      if (song.name.toLowerCase().contains(query.toLowerCase())) {
        results.add(song);
      }
    }
    return results;
  }
}