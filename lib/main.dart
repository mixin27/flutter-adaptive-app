import 'package:adaptive_app/src/state/app_state.dart';
import 'package:adaptive_app/src/youtube_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// const youTubeApiKey = 'AIzaSyAlyZv2S0cq7rzHHo3SEjMDMqIoTgPpbX0';

void main() {
  runApp(
    ChangeNotifierProvider<AuthedUserPlaylists>(
      create: (context) => AuthedUserPlaylists(),
      child: const YouTubePlaylistsApp(),
    ),
  );
}
