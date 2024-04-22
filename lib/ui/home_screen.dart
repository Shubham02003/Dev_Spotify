import 'package:flutter/material.dart';
import 'package:spotify_clone/models/song_model.dart';
import 'package:spotify_clone/repo/all_song_repo.dart';
import 'package:spotify_clone/utils/home_songs_horizontal_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final SongRepository _songRepository = SongRepository();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FSpotify',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Text(
                'Trending Songs',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            // Horizontal list of trending songs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SizedBox(
                height: size.height * 0.3,
                child: FutureBuilder<List<SongModel>>(
                  future: _songRepository
                      .fetchAllSongs(), // Fetch data from Firestore
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While data is loading, display a loading indicator
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // If there was an error, display an error message
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      // Once data is loaded, display the list
                      List<SongModel> songs = snapshot.data ?? [];
                      return SongHorizontalList(songs: songs, size: size);
                    } else {
                      // If no data is available, display a message
                      return const Center(
                        child: Text(
                          'No data available.',
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Text(
                'Most Played',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SizedBox(
                height: size.height * 0.3,
                child: FutureBuilder<List<SongModel>>(
                  future: _songRepository
                      .fetchTopPlayedSongs(3), // Fetch top 2 played songs
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No top played songs found'));
                    } else {
                      final List<SongModel> topSongs = snapshot.data!;
                      return SongHorizontalList(songs: topSongs, size: size);
                    }
                  },
                ),
              ),
            ),
            // Horizontal list of songs sorted by artist nam
          ],
        ),
      ),
    );
  }
}


