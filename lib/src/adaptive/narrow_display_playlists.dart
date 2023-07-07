import 'package:adaptive_app/src/pages/playlists.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NarrowDisplayPlaylists extends StatelessWidget {
  const NarrowDisplayPlaylists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterDev Playlists'),
      ),
      body: Playlists(
        playlistSelected: (playlist) {
          context.go(
            Uri(
              path: '/playlist/${playlist.id}',
              queryParameters: <String, String>{
                'title': playlist.snippet!.title!,
              },
            ).toString(),
          );
        },
      ),
    );
  }
}
