import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/Player/custom_player.dart';
import 'package:spotify_clone/models/song_model.dart';
import 'package:spotify_clone/repo/all_song_repo.dart';
import 'package:spotify_clone/repo/search_repo.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SongRepository _songRepository = SongRepository();
  List<SongModel> allSongs = []; // Your collection of SongModel objects
  List<SongModel> searchResults = [];

  @override
  void initState() {
    super.initState();
    loadAllSongs();
  }

  Future<void> loadAllSongs() async {
    try {
      List<SongModel> fetchedSongs = await _songRepository.fetchAllSongs();
      setState(() {
        allSongs = fetchedSongs;
        searchResults = allSongs;
      });
    } catch (e) {
      print('Failed to load songs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.white,
                width: 1.0,
              )),
          child: TextField(
              controller: _searchController,
              onChanged: onSearchTextChanged,
              decoration: const InputDecoration(
                hintText: 'Search songs...',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onTapOutside: (v) =>
                  FocusScope.of(context).requestFocus(FocusNode())),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Consumer<CustomPlayerProvider>(
          builder: (context, customPlayerProvider, child) => ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final song = searchResults[index];
              return ListTile(
                leading: Image.network(song.coverImage),
                title: Text(song.name),
                subtitle: Text(song.artist),
                onTap: () {
                  customPlayerProvider.onSongSelected(song);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void onSearchTextChanged(String query) {
    setState(() {
      searchResults = SearchRepo.searchByName(allSongs, query);
    });
  }
}
