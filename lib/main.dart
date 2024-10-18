import 'package:flutter/cupertino.dart';
import 'package:github_client/src/azure.dart';
import 'src/github.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'OAuth2 Client',
      home: MyHomePage(title: 'GitHub Client'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cloud),
            label: 'Github',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cloud_bolt),
            label: 'Azure',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            if (index == 0) {
              return const GithubPage();
            }
            return const AzurePage();
          },
        );
      },
    );
  }
}
