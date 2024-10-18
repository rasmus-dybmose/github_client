import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';

class AzureLoginWidget extends StatefulWidget {
  const AzureLoginWidget({
    required this.setClientCallback,
    required this.azureAuthorizationEndpoint,
    required this.azureTokenEndpoint,
    required this.azureClientId,
    required this.azureScopes,
    super.key,
  });
  final String azureAuthorizationEndpoint;
  final String azureTokenEndpoint;
  final String azureClientId;
  final List<String> azureScopes;
  final void Function(oauth2.Client?) setClientCallback;

  @override
  State<AzureLoginWidget> createState() => _AzureLoginState();
}

class _AzureLoginState extends State<AzureLoginWidget> {
  HttpServer? _redirectServer;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Azure Login'),
      ),
      child: Center(
        child: CupertinoButton(
          onPressed: () async {
            try {
              await _redirectServer?.close();
              // Bind to an ephemeral port on localhost
              _redirectServer = await HttpServer.bind(
                  InternetAddress.loopbackIPv4.address, 0);
              final client = await _getOAuth2Client(Uri.parse(
                  'http://${InternetAddress.loopbackIPv4.address}:${_redirectServer!.port}/auth'));

              widget.setClientCallback(client);
            } catch (e) {
              print(e);
            }
          },
          child: const Text('Login to Azure'),
        ),
      ),
    );
  }

  Future<oauth2.Client> _getOAuth2Client(Uri redirectUrl) async {
    if (widget.azureClientId.isEmpty) {
      throw const AzureLoginException(
          'azureClientId and azureClientSecret must be not empty. '
          'See `lib/azure_oauth_credentials.dart` for more detail.');
    }
    var grant = oauth2.AuthorizationCodeGrant(
      widget.azureClientId,
      Uri.parse(widget.azureAuthorizationEndpoint),
      Uri.parse(widget.azureTokenEndpoint),
      httpClient: _JsonAcceptingHttpClient(),
    );
    var authorizationUrl =
        grant.getAuthorizationUrl(redirectUrl, scopes: widget.azureScopes);

    await _redirect(authorizationUrl);

    var responseQueryParameters = await _listen();
    var client =
        await grant.handleAuthorizationResponse(responseQueryParameters);

    return client;
  }

  Future<void> _redirect(Uri authorizationUrl) async {
    if (!await launchUrl(authorizationUrl)) {
      throw AzureLoginException('Could not launch $authorizationUrl');
    }
  }

  Future<Map<String, String>> _listen() async {
    var request = await _redirectServer!.first;
    var params = request.uri.queryParameters;
    request.response.statusCode = 200;
    request.response.headers
        .set(HttpHeaders.contentTypeHeader, ContentType.text.mimeType);
    request.response.writeln('Authenticated! You can close this tab.');
    await request.response.close();
    await _redirectServer!.close();
    _redirectServer = null;
    return params;
  }
}

class _JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = ContentType.json.mimeType;
    return _httpClient.send(request);
  }
}

class AzureLoginException implements Exception {
  const AzureLoginException(this.message);
  final String message;
  @override
  String toString() => message;
}
