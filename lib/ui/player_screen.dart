import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/Player/custom_player.dart';
import 'package:spotify_clone/models/song_model.dart';
import 'package:spotify_clone/repo/user_auth.dart';
import 'package:spotify_clone/repo/user_info.dart';

class PlayerScreen extends StatefulWidget {
  final SongModel songModel;
  const PlayerScreen({Key? key, required this.songModel}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late CustomPlayerProvider _customPlayerProvider;
  final AuthService _authService = AuthService();
  @override
  void initState() {
    super.initState();
    _customPlayerProvider =
        Provider.of<CustomPlayerProvider>(context, listen: false);
    _customPlayerProvider.currentPositionChanged();
    _customPlayerProvider.totalSongDuration();
    UserInformationProvider _userInformationProvider =
        Provider.of<UserInformationProvider>(context, listen: false);
    _userInformationProvider.getIsSongLiked(
        songId: widget.songModel.id, userId: _authService.getCurrentUserId());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<CustomPlayerProvider>(
        builder: (context, customPlayerProvider, child) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.songModel.coverImage,
                    height: size.height * 0.5,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.songModel.name,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.songModel.artist,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    Consumer<UserInformationProvider>(
                      builder: (context, userProvider, child) => IconButton(
                        onPressed: () async {
                          if (userProvider.isSongLiked) {
                            await userProvider.removeLikedSong(
                                songId: widget.songModel.id,
                                userId: _authService.getCurrentUserId());
                          } else {
                            await userProvider.updateLikedSong(
                              songId: widget.songModel.id,
                              userId: _authService.getCurrentUserId(),
                            );
                          }
                        },
                        icon: userProvider.isSongLiked
                            ? const Icon(Icons.favorite, color: Colors.red)
                            : const Icon(
                                Icons.favorite_outline,
                              ),
                      ),
                    )
                  ],
                ),
                Slider(
                  value: _customPlayerProvider.sliderValue,
                  max: _customPlayerProvider.maxSliderValue,
                  min: 0,
                  onChanged: (val) {
                    final duration = Duration(seconds: val.toInt());
                    _customPlayerProvider.seekToPosition(duration);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(customPlayerProvider.currentDuration),
                      Text(customPlayerProvider.songDuration)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {},
                          style: IconButton.styleFrom(
                              backgroundColor: Colors.black),
                          icon: Icon(
                            Icons.fast_rewind,
                            color: Colors.white,
                            size: size.width * 0.1,
                          )),
                      IconButton(
                        onPressed: () {
                          customPlayerProvider
                              .playerBottomBar(widget.songModel);
                        },
                        style:
                            IconButton.styleFrom(backgroundColor: Colors.black),
                        icon: customPlayerProvider.isPlaying
                            ? Icon(
                                Icons.pause,
                                color: Colors.white,
                                size: size.width * 0.1,
                              )
                            : Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: size.width * 0.1,
                              ),
                      ),
                      IconButton(
                          onPressed: () {},
                          style: IconButton.styleFrom(
                              backgroundColor: Colors.black),
                          icon: Icon(
                            Icons.fast_forward,
                            color: Colors.white,
                            size: size.width * 0.1,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
