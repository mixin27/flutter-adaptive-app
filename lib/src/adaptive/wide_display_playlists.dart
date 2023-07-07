import 'package:adaptive_app/src/pages/playlist_details.dart';
import 'package:adaptive_app/src/pages/playlists.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:split_view/split_view.dart';

class WideDisplayPlaylists extends StatefulWidget {
  const WideDisplayPlaylists({super.key});

  @override
  State<WideDisplayPlaylists> createState() => _WideDisplayPlaylistsState();
}

class _WideDisplayPlaylistsState extends State<WideDisplayPlaylists> {
  Playlist? selectedPlaylist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: switch (selectedPlaylist?.snippet?.title) {
          String title => Text('FlutterDev Playlist: $title'),
          _ => const Text('FlutterDev Playlists'),
        },
      ),
      body: SplitView(
        viewMode: SplitViewMode.Horizontal,
        children: [
          Playlists(
            playlistSelected: (playlist) {
              setState(() {
                selectedPlaylist = playlist;
              });
            },
          ),
          switch ((selectedPlaylist?.id, selectedPlaylist?.snippet?.title)) {
            (String id, String title) =>
              PlaylistDetails(playlistId: id, playlistName: title),
            _ => const Center(
                child: Text('Select a playlist'),
              ),
          }
        ],
      ),
    );
  }
}
