// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:adaptive_app/src/state/app_state.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

typedef _AdaptiveLoginButtonWidget = Widget Function({
  required VoidCallback? onPressed,
});

class AdaptiveLogin extends StatelessWidget {
  const AdaptiveLogin({
    super.key,
    required this.clientId,
    required this.scopes,
    required this.loginButtonChild,
  });

  final ClientId clientId;
  final List<String> scopes;
  final Widget loginButtonChild;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      return _GoogleSignInLogin(
        button: _loginButton,
        scopes: scopes,
      );
    } else {
      return _GoogleApisAuthLogin(
        button: _loginButton,
        scopes: scopes,
        clientId: clientId,
      );
    }
  }

  Widget _loginButton({required VoidCallback? onPressed}) =>
      FilledButton(onPressed: onPressed, child: loginButtonChild);
}

class _GoogleSignInLogin extends StatefulWidget {
  const _GoogleSignInLogin({
    required this.button,
    required this.scopes,
  });

  final _AdaptiveLoginButtonWidget button;
  final List<String> scopes;

  @override
  State<_GoogleSignInLogin> createState() => __GoogleSignInLoginState();
}

class __GoogleSignInLoginState extends State<_GoogleSignInLogin> {
  @override
  void initState() {
    super.initState();

    _googleSignIn = GoogleSignIn(
      scopes: widget.scopes,
    );

    _googleSignIn.onCurrentUserChanged.listen((event) {
      if (event != null) {
        _googleSignIn.authenticatedClient().then((authClient) {
          if (authClient != null) {
            context.read<AuthedUserPlaylists>().authClient = authClient;
            context.go('/');
          }
        });
      }
    });
  }

  late final GoogleSignIn _googleSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.button(onPressed: () {
          _googleSignIn.signIn();
        }),
      ),
    );
  }
}

class _GoogleApisAuthLogin extends StatefulWidget {
  const _GoogleApisAuthLogin({
    required this.button,
    required this.scopes,
    required this.clientId,
  });

  final _AdaptiveLoginButtonWidget button;
  final List<String> scopes;
  final ClientId clientId;

  @override
  State<_GoogleApisAuthLogin> createState() => __GoogleApisAuthLoginState();
}

class __GoogleApisAuthLoginState extends State<_GoogleApisAuthLogin> {
  @override
  void initState() {
    super.initState();
    clientViaUserConsent(widget.clientId, widget.scopes, (uri) {
      setState(() {
        _authUrl = Uri.parse(uri);
      });
    }).then((authClient) {
      context.read<AuthedUserPlaylists>().authClient = authClient;
      context.go('/');
    });
  }

  Uri? _authUrl;

  @override
  Widget build(BuildContext context) {
    final authUrl = _authUrl;

    if (authUrl != null) {
      return Scaffold(
        body: Center(
          child: Link(
            uri: authUrl,
            builder: (context, followLink) =>
                widget.button(onPressed: followLink),
          ),
        ),
      );
    }

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
