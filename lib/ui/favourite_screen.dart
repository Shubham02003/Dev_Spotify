import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/Player/custom_player.dart';
import 'package:spotify_clone/models/song_model.dart';
import 'package:spotify_clone/repo/user_auth.dart';
import 'package:spotify_clone/repo/user_info.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liked Songs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<UserInformationProvider>(
        builder: (context, userProvider, child) =>
            StreamBuilder<List<SongModel>>(
          stream: userProvider
              .getLikedSongsForUser(_authService.getCurrentUserId()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No liked songs found'),
              );
            } else {
              final List<SongModel> likedSongs = snapshot.data!;
              return Consumer<CustomPlayerProvider>(
                builder: (context, customPlayerProvider, child) =>
                    ListView.builder(
                  itemCount: likedSongs.length,
                  itemBuilder: (context, index) {
                    final song = likedSongs[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(song.coverImage),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          userProvider.removeLikedSong(
                            songId: song.id,
                            userId: _authService.getCurrentUserId(),
                          );
                        },
                        child: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                      ),
                      title: Text(song.name),
                      subtitle: Text(song.artist),
                      onTap: () {
                        customPlayerProvider.onSongSelected(song);
                      },
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
