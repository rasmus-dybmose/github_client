import 'package:flutter/cupertino.dart';
import 'package:github_client/src/azure_login.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import '../azure_oauth_credentials.dart';
import 'azure_sign_out.dart';

class AzurePage extends StatefulWidget {
  const AzurePage({super.key});

  @override
  State<AzurePage> createState() => _AzurePageState();
}

class _AzurePageState extends State<AzurePage> {
  oauth2.Client? _client;

  @override
  Widget build(BuildContext context) {
    if (_client != null) {
      return AzureSignOut(
        client: _client!,
        azureSignOutEndpoint: AzureOauthCredentials.azureSignOutEndpoint,
        setClientCallback: (client) => setState(() {
          _client?.close();
          _client = client;
        }),
      );
    }
    return AzureLoginWidget(
      setClientCallback: (client) => setState(() {
        _client = client;
      }),
      azureAuthorizationEndpoint:
          AzureOauthCredentials.azureAuthorizationEndpoint,
      azureTokenEndpoint: AzureOauthCredentials.azureTokenEndpoint,
      azureClientId: AzureOauthCredentials.azureClientId,
      azureScopes: AzureOauthCredentials.azureScopes,
    );
  }
}
