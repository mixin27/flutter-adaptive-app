import 'package:adaptive_app/src/adaptive/adaptive_image.dart';
import 'package:adaptive_app/src/adaptive/adaptive_text.dart';
import 'package:adaptive_app/src/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

class PlaylistDetails extends StatelessWidget {
  const PlaylistDetails({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  final String playlistId;
  final String playlistName;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthedUserPlaylists>(
      builder: (ctx, playlists, _) {
        final playlistItems = playlists.playlistItems(playlistId: playlistId);
        if (playlistItems.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return _PLaylistDetailsListView(playlistItems: playlistItems);
      },
    );
  }
}

class _PLaylistDetailsListView extends StatefulWidget {
  const _PLaylistDetailsListView({
    required this.playlistItems,
  });

  final List<PlaylistItem> playlistItems;

  @override
  State<_PLaylistDetailsListView> createState() =>
      _PLaylistDetailsListViewState();
}

class _PLaylistDetailsListViewState extends State<_PLaylistDetailsListView> {
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
      itemCount: widget.playlistItems.length,
      itemBuilder: (ctx, idx) {
        final playlistItem = widget.playlistItems[idx];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (playlistItem.snippet!.thumbnails!.high != null)
                  AdaptiveImage.network(
                      playlistItem.snippet!.thumbnails!.high!.url!),

                // build gradient
                _buildGradient(context),

                // build title and subtitle
                _buildTitleAndSubtitle(context, playlistItem),

                // build play button
                _buildPlayButton(context, playlistItem),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradient(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Theme.of(context).colorScheme.background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.5, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle(
    BuildContext context,
    PlaylistItem playlistItem,
  ) {
    return Positioned(
      left: 20,
      right: 0,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdaptiveText(
            playlistItem.snippet!.title!,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 18,
                ),
          ),
          if (playlistItem.snippet!.videoOwnerChannelTitle != null)
            AdaptiveText(
              playlistItem.snippet!.videoOwnerChannelTitle!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 12,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayButton(
    BuildContext context,
    PlaylistItem playlistItem,
  ) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(21)),
          ),
        ),
        Link(
          uri: Uri.parse(
            'https://www.youtube.com/watch?v=${playlistItem.snippet!.resourceId!.videoId}',
          ),
          builder: (ctx, followLink) => IconButton(
            onPressed: followLink,
            color: Colors.red,
            iconSize: 45,
            icon: const Icon(Icons.play_circle_fill),
          ),
        ),
      ],
    );
  }
}
