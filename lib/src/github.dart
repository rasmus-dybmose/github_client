import 'package:flutter/cupertino.dart';

import '../github_oauth_credentials.dart';
import 'github_login.dart';

class GithubPage extends StatelessWidget {
  const GithubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GithubLoginWidget(
      builder: (context, httpClient) {
        return const CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text("GitHub Client"),
          ),
          child: Center(
            child: Text(
              'You are logged in to GitHub!',
            ),
          ),
        );
      },
      githubClientId: GithubOauthCredentials.githubClientId,
      githubClientSecret: GithubOauthCredentials.githubClientSecret,
      githubScopes: GithubOauthCredentials.githubScopes,
    );
  }
}
