import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/Player/custom_player.dart';
import 'package:spotify_clone/models/song_model.dart';
import 'package:spotify_clone/repo/user_auth.dart';
import 'package:spotify_clone/repo/user_info.dart';
import 'package:spotify_clone/ui/favourite_screen.dart';
import 'package:spotify_clone/ui/home_screen.dart';
import 'package:spotify_clone/ui/player_screen.dart';
import 'package:spotify_clone/ui/profile_screen.dart';
import 'package:spotify_clone/ui/search_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _index = 0;
  List navPages = [
    const HomePage(),
    const SearchScreen(),
    const FavouriteScreen(),
    const ProfileScreen()
  ];
  final UserInformationProvider _userInformation = UserInformationProvider();
  final AuthService _authService = AuthService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? userId = _authService.getCurrentUserId();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          navPages.elementAt(_index),
          Positioned(
            bottom: 2,
            left: 0,
            right: 0,
            child: StreamBuilder<SongModel?>(
              stream: _userInformation.getLastPlayedSong(userId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data != null) {
                  SongModel? songModel = snapshot.data;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerScreen(
                            songModel: songModel,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.brown.shade800,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: size.height * 0.07,
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              songModel!.coverImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                songModel.name ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                songModel.artist ?? '',
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          Consumer<CustomPlayerProvider>(
                            builder: (context, customPlayerProvider, child) =>
                                IconButton(
                              onPressed: () {
                                customPlayerProvider.playerBottomBar(songModel);
                              },
                              icon: customPlayerProvider.isPlaying
                                  ? Icon(
                                      Icons.pause,
                                      color: Colors.white,
                                      size: size.height * 0.043,
                                    )
                                  : Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: size.height * 0.043,
                                    ),
                            ),
                          )
                          // Add buttons for play, pause, etc. if desired
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "search",
            icon: Icon(Icons.search_rounded),
          ),
          BottomNavigationBarItem(
            label: "favourite",
            icon: Icon(Icons.favorite_outline),
          ),
          BottomNavigationBarItem(
            label: "profile",
            icon: Icon(Icons.account_circle),
          )
        ],
      ),
    );
  }
}
