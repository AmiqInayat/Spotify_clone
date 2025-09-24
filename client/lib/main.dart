import 'package:client/feature/auth/view/page/signup_page.dart';
import 'package:client/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/feature/core/providers/current_user_notifier.dart';
import 'package:client/feature/core/theme/theme.dart';
import 'package:client/feature/home/view/pages/home_page.dart';
// import 'package:client/feature/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();

  Hive.init(dir.path);
  await Hive.openBox("hi");
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  //   final container = ProviderContainer();
  // final notifier = container.read(authViewModelProvider.notifier);
  // await notifier.initSharedPerferences();

  // final usermodel = await notifier.getData();
  // print(usermodel);
  // above is another method to keep the instance alive

  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPreferences();
  await container.read(authViewModelProvider.notifier).getData();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    // print(currentUser);
    return MaterialApp(
      title: 'Music App',
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? const SignupPage() : const HomePage(),
    );
  }
}
