import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          body: ChangeNotifierProvider<_NavigatorHistoryStore>(
              create: (_) => _NavigatorHistoryStore(),
              child: const MainPage())),
    );
  }
}

const int talentTabIndex = 0;
const int requestTabIndex = 1;
const int settingTabIndex = 2;

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<_NavigatorHistoryStore>(
      builder: (BuildContext context, _NavigatorHistoryStore navi, _) =>
          CupertinoTabScaffold(
              controller: navi.controller,
              tabBar: CupertinoTabBar(items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.face), title: Text('タレント')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.mail), title: Text('リクエスト')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), title: Text('設定')),
              ]),
              tabBuilder: (BuildContext context, int index) => Navigator(
                  initialRoute: 'main/tabs',
                  onGenerateRoute: (RouteSettings settings) =>
                      MaterialPageRoute<PageRoute<Widget>>(
                          settings: settings,
                          builder: (_) => const <Widget>[
                                _TalentTabPage(),
                                _RequestTabPage(),
                                _SettingTabPage(),
                              ][index]))));
}

class _TalentTabPage extends StatelessWidget {
  const _TalentTabPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<_NavigatorHistoryStore>(
      builder: (BuildContext context, _NavigatorHistoryStore navi, _) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('タレントのタブです'),
                RaisedButton(
                    child: const Text('リクエストを表示'),
                    onPressed: () => navi.moveTo(requestTabIndex)),
                RaisedButton(
                    child: const Text('設定を表示'),
                    onPressed: () => navi.moveTo(settingTabIndex)),
                RaisedButton(
                    child: const Text('もどる'),
                    onPressed: navi.hasHistory ? navi.pop : null),
              ]));
}

class _RequestTabPage extends StatelessWidget {
  const _RequestTabPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<_NavigatorHistoryStore>(
      builder: (BuildContext context, _NavigatorHistoryStore navi, _) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('リクエストのタブです'),
                RaisedButton(
                    child: const Text('タレントを表示'),
                    onPressed: () => navi.moveTo(talentTabIndex)),
                RaisedButton(
                    child: const Text('設定を表示'),
                    onPressed: () => navi.moveTo(settingTabIndex)),
                RaisedButton(
                    child: const Text('もどる'),
                    onPressed: navi.hasHistory ? navi.pop : null),
              ]));
}

class _SettingTabPage extends StatelessWidget {
  const _SettingTabPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<_NavigatorHistoryStore>(
      builder: (BuildContext context, _NavigatorHistoryStore navi, _) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('設定のタブです'),
                RaisedButton(
                    child: const Text('別のページを開く'),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<PageRoute<Widget>>(
                            builder: (_) => _OtherPage()))),
                RaisedButton(
                    child: const Text('もどる'),
                    onPressed: navi.hasHistory ? navi.pop : null),
              ]));
}

class _NavigatorHistoryStore extends ChangeNotifier {
  _NavigatorHistoryStore() {
    controller.addListener(push);
  }
  final CupertinoTabController controller = CupertinoTabController();

  int _prevIndex = 0;
  bool _onPop = false;
  List<int> histories = <int>[];
  bool get hasHistory => histories.isNotEmpty;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void moveTo(int index) {
    if (controller.index == index) {
      return;
    }
    controller.index = index;
  }

  void push() {
    if (_prevIndex == controller.index) {
      return;
    }
    if (_onPop) {
      _onPop = false;
    } else {
      histories.add(_prevIndex);
    }
    _prevIndex = controller.index;
    notifyListeners();
  }

  void pop() {
    _onPop = true;
    if (histories.isNotEmpty) {
      controller.index = histories.removeLast();
    }
  }
}

class _OtherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
            const Text('これば別のページ'),
            RaisedButton(
                child: const Text('もとのページに戻る'),
                onPressed: () => Navigator.of(context).pop()),
          ])));
}
