# Fspotify

Fspotify is a mobile music application built with Flutter that leverages Firebase for its backend infrastructure. It offers a seamless music listening experience with features like song loading from Firebase, a liked songs collection, and search functionality.

## Features

- Stream music directly from Firebase storage
- Create and manage playlists
- Like and save favorite songs
- Search functionality to find songs quickly
- Responsive design for various mobile devices

## Screenshots

Here are some screenshots showcasing the UI of Fspotify:

### Authentication & Home Screen
<p float="left">
  <img src="https://github.com/user-attachments/assets/92062c23-79dc-40df-b2a2-57306c8cf8c8" alt="Authentication Screen" width="300" height="600" style="margin-right: 20px;"/>
  <img src="https://github.com/user-attachments/assets/060c3b14-2c66-4692-ac0c-526ab1fd599c" alt="Home Screen" width="300" height="600"/>
</p>

*Description: The authentication screen allows users to sign in or create a new account. It features a clean design with options for email/password login and social media authentication.*

*The home screen is the main interface of Fspotify. It displays featured playlists, recently played songs, and personalized recommendations. Users can quickly access their favorite content from this central hub.*

### Player & Search Screens
<p float="left">
  <img src="https://github.com/user-attachments/assets/b9068b8a-ee19-4a78-9f4e-aad58a398ea0" alt="Player Screen" width="300" height="600" style="margin-right: 20px;"/>
  <img src="https://github.com/user-attachments/assets/de5b5ce9-9411-403c-8d51-e3429bbe9d3c" alt="Search Screen" width="300" height="600"/>
</p>

*Description: The player screen shows the currently playing song with a prominent album cover. It includes playback controls (play/pause, skip, shuffle, repeat), a progress bar, and options to like the song or add it to a playlist.*

*The search interface allows users to find songs, artists, and playlists. It features a search bar at the top and displays results in a scrollable list, making it easy to discover new music or find favorite tracks.*

### Liked Songs & User Profile Screens
<p float="left">
  <img src="https://github.com/user-attachments/assets/b6864b10-9879-4caf-9e8b-64b3ee79482e" alt="Liked Songs Screen" width="300" height="600" style="margin-right: 20px;"/>
  <img src="https://github.com/user-attachments/assets/38e74cef-1b48-4f1c-8b92-b5434b1cabe2" alt="User Profile Screen" width="300" height="600"/>
</p>

*Description: The liked songs screen displays a collection of the user's favorite tracks. Users can easily access and play their liked songs from this dedicated page, which shows song titles, artists, and album covers in a list format.*

*The user profile screen shows the user's personal information, profile picture, and statistics such as the number of playlists and liked songs. It also provides options to edit the profile or log out.*

## Technology Stack

- Frontend: Flutter
- Backend: Firebase
  - Firebase Authentication for user management
  - Cloud Firestore for storing user data, playlists, and song metadata
  - Firebase Storage for storing audio files

## Getting Started

To get started with Fspotify, follow these steps:

1. Clone the repository
2. Install dependencies 
3. Set up Firebase
- Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com/)
- Add an Android app to your Firebase project and download the `google-services.json` file
- Place the `google-services.json` file in the `android/app` directory of your Flutter project
- Enable Authentication, Cloud Firestore, and Storage in your Firebase project

4. Configure Firebase in your Flutter app
- Update the `android/app/build.gradle` file with your Firebase configuration

5. Run the app

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
- [Flutter Sound](https://pub.dev/packages/flutter_sound) for audio playback



