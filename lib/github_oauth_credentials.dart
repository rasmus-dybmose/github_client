class GithubOauthCredentials {
  static const githubClientId = String.fromEnvironment('GITHUB_CLIENT_ID');
  static const githubClientSecret =
      String.fromEnvironment('GITHUB_CLIENT_SECRET');
  static final githubScopes =
      const String.fromEnvironment('GITHUB_SCOPES').split(' ');
}
