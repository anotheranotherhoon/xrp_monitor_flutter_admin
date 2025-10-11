import 'package:flutter/material.dart';
import 'package:xrp_monitor_flutter_admin/service/storage/local_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xrp_monitor_flutter_admin/ui/themes/default_theme.dart';
import 'core/route/app_router.dart';



void main() async{
  await LocalStorageService.instance.init();
  runApp(ProviderScope(child: MyApp()));
}


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {



  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'XRP Monitor Admin',
      routerConfig: router.config(),
      theme: defaultTheme,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
