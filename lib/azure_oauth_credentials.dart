class AzureOauthCredentials {
  static const String azureClientId = String.fromEnvironment('AZURE_CLIENT_ID');
  static const String azureAuthorizationEndpoint =
      String.fromEnvironment('AZURE_AUTHORIZATION_ENDPOINT');
  static const String azureSignOutEndpoint =
      String.fromEnvironment('AZURE_SIGNOUT_ENDPOINT');
  static const String azureTokenEndpoint =
      String.fromEnvironment('AZURE_TOKEN_ENDPOINT');
  static final azureScopes =
      const String.fromEnvironment('AZURE_SCOPES').split(' ');
}
