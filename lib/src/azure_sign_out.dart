import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';

class AzureSignOut extends StatelessWidget {
  const AzureSignOut({
    super.key,
    required this.client,
    required this.azureSignOutEndpoint,
    required this.setClientCallback,
  });

  final oauth2.Client client;
  final String azureSignOutEndpoint;
  final void Function(oauth2.Client?) setClientCallback;

  @override
  Widget build(BuildContext context) {
    HttpServer? _redirectServer;

    Future<Map<String, String>> _listen() async {
      var request = await _redirectServer!.first;
      var params = request.uri.queryParameters;
      request.response.statusCode = 200;
      request.response.headers
          .set(HttpHeaders.contentTypeHeader, ContentType.text.mimeType);
      request.response.writeln('Signed out! You can close this tab.');
      await request.response.close();
      await _redirectServer!.close();
      _redirectServer = null;
      return params;
    }

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Sign Out of Azure"),
      ),
      child: Center(
        child: CupertinoButton(
          onPressed: () async {
            await _redirectServer?.close();
            // Bind to an ephemeral port on localhost
            _redirectServer =
                await HttpServer.bind(InternetAddress.loopbackIPv4.address, 0);

            final redirectUrl = Uri.parse(
                'http://${InternetAddress.loopbackIPv4.address}:${_redirectServer!.port}/signout');

            if (!await launchUrl(Uri.parse(
                '$azureSignOutEndpoint?post_logout_redirect_uri=$redirectUrl'))) {
              throw Exception('Could not launch $azureSignOutEndpoint');
            }

            await _listen();

            setClientCallback(null);
          },
          child: const Text("Sign Out"),
        ),
      ),
    );
  }
}
