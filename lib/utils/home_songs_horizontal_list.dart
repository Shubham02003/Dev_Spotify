import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/Player/custom_player.dart';
import 'package:spotify_clone/models/song_model.dart';

class SongHorizontalList extends StatelessWidget {
  const SongHorizontalList({
    super.key,
    required this.songs,
    required this.size,
  });

  final List<SongModel> songs;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomPlayerProvider>(
      builder: (context, customPlayerProvider, child) => ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: songs.length,
        itemBuilder: (context, index) {
          SongModel song = songs[index];
          return GestureDetector(
            onTap: () {
              customPlayerProvider.onSongSelected(song);
            },
            child: Container(
              margin: const EdgeInsetsDirectional.symmetric(
                horizontal: 10,
              ),
              child: SizedBox(
                width: size.width * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(song.coverImage,
                          height: size.height * 0.25,
                          width: size.width * 0.4,
                          fit: BoxFit.cover),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          song.artist,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}