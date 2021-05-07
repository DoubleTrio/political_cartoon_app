import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:history_app/auth/auth.dart';
import 'package:history_app/blocs/blocs.dart';
import 'package:history_app/l10n/l10n.dart';
import 'package:political_cartoon_repository/political_cartoon_repository.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _firebaseUserRepo = FirebaseUserRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<AuthenticationBloc>(
            create: (_) =>
                AuthenticationBloc(userRepository: _firebaseUserRepo)),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select((ThemeCubit cubit) => cubit.state);

    var lightPrimary = const Color(4284612846);
    var lightColorScheme = ColorScheme(
        primary: lightPrimary,
        primaryVariant: lightPrimary.withOpacity(0.8),
        secondary: Colors.yellow,
        secondaryVariant: Colors.yellow.withOpacity(0.8),
        surface: Colors.white,
        background: Colors.white,
        error: const Color(4289724448),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onBackground: Colors.black38,
        onError: Colors.white,
        brightness: Brightness.light);

    var darkPrimary = const Color(0xFFDEA7FF);
    var darkColorScheme = const ColorScheme.dark().copyWith(
      primary: darkPrimary,
      primaryVariant: darkPrimary.withOpacity(0.8),
      secondary: Colors.yellow,
      secondaryVariant: Colors.yellow.withOpacity(0.8),
      onBackground: Colors.white60,
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: ThemeData(
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: lightColorScheme.background,
                selectedItemColor: lightColorScheme.secondary,
                selectedLabelStyle:
                    TextStyle(color: lightColorScheme.onSurface),
                unselectedLabelStyle:
                    TextStyle(color: lightColorScheme.onSurface),
                unselectedItemColor: lightColorScheme.onSecondary),
            brightness: Brightness.light,
            fontFamily: 'SanFrancisco',
            appBarTheme: AppBarTheme(
              backgroundColor: lightPrimary,
            ),
            // scaffoldBackgroundColor: Colors.white,
            textTheme: const TextTheme(
              subtitle1: TextStyle(
                fontSize: 16,
              ),
            ),
            colorScheme: lightColorScheme,
            highlightColor: lightPrimary,
            floatingActionButtonTheme:
                FloatingActionButtonThemeData(backgroundColor: lightPrimary)),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'SanFrancisco',
            primaryColor: lightPrimary,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF3C3C3C),
            ),
            accentColor: lightPrimary,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: const Color(0xFF3C3C3C),
                selectedItemColor: darkColorScheme.secondary,
                selectedLabelStyle: TextStyle(color: darkColorScheme.onSurface),
                unselectedLabelStyle:
                    TextStyle(color: darkColorScheme.onSurface),
                unselectedItemColor: darkColorScheme.onSecondary),
            // scaffoldBackgroundColor: const Color(4279374354),
            textTheme: const TextTheme(
              subtitle1: TextStyle(
                fontSize: 16,
              ),
            ),
            colorScheme: darkColorScheme,
            highlightColor: darkPrimary,
            floatingActionButtonTheme:
                FloatingActionButtonThemeData(backgroundColor: darkPrimary)),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: themeMode == ThemeMode.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: AuthFlow(),
        ));
  }
}
