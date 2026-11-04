import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rock_paper_scissors/core/audio/sound_service.dart';
import 'package:rock_paper_scissors/core/settings/app_settings.dart';
import 'package:rock_paper_scissors/core/settings/settings_cubit.dart';
import 'package:rock_paper_scissors/core/settings/settings_repository.dart';
import 'package:rock_paper_scissors/core/theme/app_theme.dart';
import 'package:rock_paper_scissors/l10n/app_localizations.dart';

class RockPaperScissorsApp extends StatelessWidget {
  const RockPaperScissorsApp({
    super.key,
    required this.home,
    this.settingsRepository,
    this.soundService = const SilentSoundService(),
  });

  final Widget home;
  final SettingsRepository? settingsRepository;
  final SoundService soundService;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<SoundService>.value(
      value: soundService,
      child: BlocProvider(
        create: (_) => SettingsCubit(
          settingsRepository ?? InMemorySettingsRepository(),
        ),
        child: BlocBuilder<SettingsCubit, AppSettings>(
          buildWhen: (previous, current) => previous.locale != current.locale,
          builder: (context, settings) {
            return MaterialApp(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context).appTitle,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: ThemeMode.light,
              debugShowCheckedModeBanner: false,
              locale: settings.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: home,
            );
          },
        ),
      ),
    );
  }
}
