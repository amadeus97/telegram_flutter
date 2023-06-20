import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:telegram_flutter/main.dart';
import 'package:telegram_flutter/logic/app_manager.dart';
import 'package:telegram_flutter/logic/settings_manager.dart';
import 'package:telegram_flutter/ui/modals/settings_drawer.dart';
import 'package:telegram_flutter/ui/pages/authentication_page.dart';
import 'package:telegram_flutter/ui/pages/country_selection_page.dart';
import 'package:telegram_flutter/ui/pages/list_devices_page.dart';
import 'package:telegram_flutter/ui/pages/maps_page.dart';
import 'package:telegram_flutter/ui/pages/splash_page.dart';

class MainApp extends StatefulWidget with GetItStatefulWidgetMixin {
  MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with GetItStateMixin {
  @override
  void initState() {
    /// Bootstrap the app.
    /// The ui is bound to AppManager.isBootstrapComplete and will rebuild when it changes.
    scheduleMicrotask(() => app.bootstrap());
    super.initState();
  }

  /// Tear down the app, we can rely on GetIt.reset() action, and add [Disposable] interfaces to any
  /// logic classes that need it.
  @override
  void dispose() {
    GetIt.I.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool bootstrapComplete = watchX((AppManager m) => m.isBootstrapComplete);
    bool useDarkMode = watchX((SettingsManager m) => m.darkMode);
    bool authenticated = watchX((SettingsManager m) => m.authenticated);
    return bootstrapComplete == false
        ? const SplashPage()
        : MaterialApp(
            theme: useDarkMode ? ThemeData.dark() : ThemeData.light(),
            initialRoute: authenticated ? '/' : 'authentication',
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case '/':
                      return const _MainAppScaffold();
                    case 'authentication':
                      return const AuthenticationPage();
                    case 'country_selection':
                      return const CountrySelectionPage();
                    default:
                      return const _MainAppScaffold();
                  }
                },
              );
            },
          );
  }
}

/// Holds a Scaffold, AppBar, TabBarView, and TabBar
class _MainAppScaffold extends StatefulWidget {
  const _MainAppScaffold({Key? key}) : super(key: key);

  @override
  State<_MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<_MainAppScaffold>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      /// Settings drawer
      drawer: SizedBox(width: 300, child: SettingsDrawer()),

      /// App Bar
      appBar: AppBar(
        title: const Text('APP TITLE'),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
      ),

      /// Main content
      body: TabBarView(
        controller: _tabController,
        children: [
          ListDevicesPage(),
          MapPage(),
        ],
      ),

      /// Bottom tabs
      bottomNavigationBar: TabBar(
        controller: _tabController,
        labelPadding: const EdgeInsets.all(16),
        labelColor: Theme.of(context).textTheme.bodyLarge!.color,
        tabs: const [
          Text('All Devices'),
          Text('Maps'),
        ],
      ),
    );
  }
}
