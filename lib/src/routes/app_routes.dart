import 'package:adaptive_app/src/adaptive/adaptive_login.dart';
import 'package:adaptive_app/src/adaptive/adaptive_playlists.dart';
import 'package:adaptive_app/src/pages/playlist_details.dart';
import 'package:adaptive_app/src/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:provider/provider.dart';

// From https://developers.google.com/youtube/v3/guides/auth/installed-apps#identify-access-scopes
final scopes = [
  'https://www.googleapis.com/auth/youtube.readonly',
];

/// Android: 186773914564-febtibm14d5mhvo7u8i1njlva48b9ulb.apps.googleusercontent.com
/// iOS: 186773914564-cc89hmd2ccku8i1gavgrvqt779s993qi.apps.googleusercontent.com
final clientId = ClientId(
  '186773914564-u3p13mhc8lhv6kq0t36oneo00obikrco.apps.googleusercontent.com',
  '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',
);

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AdaptivePlaylists(),
      redirect: (context, state) {
        if (!context.read<AuthedUserPlaylists>().isLoggedIn) {
          return '/login';
        } else {
          return null;
        }
      },
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) {
            return AdaptiveLogin(
              clientId: clientId,
              scopes: scopes,
              loginButtonChild: const Text('Login to YouTube'),
            );
          },
        ),
        GoRoute(
          path: 'playlist/:id',
          builder: (context, state) {
            final title = state.queryParameters['title']!;
            final id = state.pathParameters['id']!;

            return Scaffold(
              appBar: AppBar(title: Text(title)),
              body: PlaylistDetails(
                playlistId: id,
                playlistName: title,
              ),
            );
          },
        ),
      ],
    ),
  ],
);
