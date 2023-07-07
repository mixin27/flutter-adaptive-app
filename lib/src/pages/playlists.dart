import 'package:adaptive_app/src/adaptive/adaptive_image.dart';
import 'package:adaptive_app/src/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:provider/provider.dart';

typedef PlaylistsListSelected = void Function(Playlist playlist);

class Playlists extends StatelessWidget {
  const Playlists({super.key, required this.playlistSelected});

  final PlaylistsListSelected playlistSelected;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthedUserPlaylists>(
      builder: (ctx, flutterDev, child) {
        final playlists = flutterDev.playlists;

        if (playlists.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return _PlaylistsListView(
          items: playlists,
          playlistsListSelected: playlistSelected,
        );
      },
    );
  }
}

class _PlaylistsListView extends StatefulWidget {
  const _PlaylistsListView({
    required this.items,
    required this.playlistsListSelected,
  });

  final List<Playlist> items;
  final PlaylistsListSelected playlistsListSelected;

  @override
  State<_PlaylistsListView> createState() => _PlaylistsListViewState();
}

class _PlaylistsListViewState extends State<_PlaylistsListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.items.length,
      itemBuilder: (ctx, idx) {
        final playlist = widget.items[idx];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: AdaptiveImage.network(
              playlist.snippet!.thumbnails!.default_!.url!,
            ),
            title: Text(playlist.snippet!.title!),
            subtitle: Text(playlist.snippet!.description!),
            onTap: () {
              widget.playlistsListSelected(playlist);
            },
          ),
        );
      },
    );
  }
}
