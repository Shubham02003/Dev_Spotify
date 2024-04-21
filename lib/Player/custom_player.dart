import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:spotify_clone/models/song_model.dart';
import 'package:spotify_clone/repo/all_song_repo.dart';
import 'package:spotify_clone/repo/user_auth.dart';
import 'package:spotify_clone/repo/user_info.dart';

class CustomPlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final UserInformationProvider _userInformation = UserInformationProvider();
  final AuthService _authService = AuthService();
  final SongRepository _songRepository = SongRepository();
  bool isPlaying = false;
  String currentDuration = "00.00";
  String songDuration = "00.00";
  double sliderValue = 0.0;
  double maxSliderValue =1.0;


  void onSongSelected(SongModel songModel) async {
    if (isPlaying) {
      await _audioPlayer.stop();
      isPlaying = false;
      notifyListeners();
    }
    try {
      await _audioPlayer.play(UrlSource(songModel.songPath));
      isPlaying = true;
      await _songRepository.increaseNumberOfTimesPlayed(songModel.id);
      notifyListeners();
      addToLastPlaySong(songModel);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  void currentPositionChanged() {
      _audioPlayer.onPositionChanged.listen((newDuration) {
        try{
          sliderValue = newDuration.inSeconds.toDouble();
          currentDuration = _formatDuration(newDuration);
          notifyListeners();
        }catch(e){
          print(e);
        }
    });
  }

  void totalSongDuration()async{
    Duration? duration = await _audioPlayer.getDuration();
    if(duration==null)return ;
    maxSliderValue = duration.inSeconds.toDouble();
    songDuration = _formatDuration(duration);
    notifyListeners();
  }

  void seekToPosition(Duration duration)async{
     await _audioPlayer.seek(duration);
     try{
      Duration? position =  await _audioPlayer.getCurrentPosition();
      if(position==null)return;
      sliderValue = position.inSeconds.toDouble();
      currentDuration = _formatDuration(position);
      print(sliderValue);
      notifyListeners();
     }catch(e){
       print(e);
     }
  }


  String _formatDuration(Duration duration) {
    // Calculate hours, minutes, and seconds
    String twoDigits(int n )=> n.toString().padLeft(2,'0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secs = twoDigits(duration.inSeconds.remainder(60));

    return [
      if(duration.inHours>0)hours,
      minutes,secs,
    ].join(':');


  }

  void playerBottomBar(SongModel songModel) async {
    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.pause();
      isPlaying = false;
    } else if (_audioPlayer.state == PlayerState.paused) {
      await _audioPlayer.resume();
      isPlaying = true;
    } else {
      await _audioPlayer.play(UrlSource(songModel.songPath));
      isPlaying = true;
    }
    notifyListeners();
  }

  void stopPlayer() async {
    await _audioPlayer.stop();
    print("Player is Stop successfully");
  }

  void addToLastPlaySong(SongModel songModel) {
    String? uid = _authService.getCurrentUserId();
    if (uid != null) {
      _userInformation.updateLastPlayedSong(userId: uid, id: songModel.id);
    }
  }
}
