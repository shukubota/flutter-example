import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(ProviderScope(child: FlutterTips()));
}

final GlobalKey<NavigatorState> rootNavigationkey =
    new GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> homeNavigationkey =
    new GlobalKey<NavigatorState>();

class FlutterTips extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final String value = useProvider(helloWorldProvider);
    useEffect(() {
      print('useEffect');
      return null;
    });
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: router,
      initialRoute: '/',
      navigatorKey: rootNavigationkey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('progress'),
          ),
        ],
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Offstage(
            offstage: _tabIndex != 0,
            child: HomeNavigator(),
          ),
          Offstage(
            offstage: _tabIndex != 1,
            child: ProgressMenu(),
          ),
        ],
      ),
    );
  }
}

class HomeNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'homeTab-menu',
      onGenerateRoute: (RouteSettings settings) {
        print(settings);
        print('setting');
        print(settings.name);
        WidgetBuilder builder;
        builder = (BuildContext _) => HomeMenu();
        switch (settings.name) {
          case 'homeTab-submenu':
            builder = (BuildContext _) => HomeSubMenu();
            return MaterialPageRoute(builder: builder, settings: settings);
          case 'homeTab-menu':
            builder = (BuildContext _) => HomeMenu();
            return MaterialPageRoute(builder: builder, settings: settings);
          // break;
          default:
            throw Exception();
        }
      },
      key: homeNavigationkey,
    );
  }
}

class HomeMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('homemenu')),
      body: Column(
        children: [
          RaisedButton(
            onPressed: () => rootNavigationkey.currentState.pushNamed('/login'),
            child: Text('to login'),
          ),
          RaisedButton(
            onPressed: () =>
                homeNavigationkey.currentState.pushNamed('homeTab-submenu'),
            child: Text('to submenu'),
          ),
        ],
      ),
    );
  }
}

class HomeSubMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('homesubmenu')),
      body: Center(
        child: Text('homeSubmenu'),
      ),
    );
  }
}

class ProgressMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('ProgressMenu'),
    );
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Text('Login'),
      ),
    );
  }
}

// routing
Map<String, WidgetBuilder> router = {
  '/': (BuildContext context) => MyHomePage(title: '/'),
  '/login': (BuildContext context) => Login(),
};

Map<String, WidgetBuilder> homeRouter = {
  'homeTab-menu': (BuildContext context) => HomeMenu(),
  'homeTab-submenu': (BuildContext context) => HomeSubMenu(),
};
