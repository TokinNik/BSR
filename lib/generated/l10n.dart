// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get _locale {
    return Intl.message(
      'en',
      name: '_locale',
      desc: '',
      args: [],
    );
  }

  /// `LogOut`
  String get log_out {
    return Intl.message(
      'LogOut',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `LogIn`
  String get log_in {
    return Intl.message(
      'LogIn',
      name: 'log_in',
      desc: '',
      args: [],
    );
  }

  /// `NextPage`
  String get next_page {
    return Intl.message(
      'NextPage',
      name: 'next_page',
      desc: '',
      args: [],
    );
  }

  /// `Temp Next Rout Page {num}`
  String temp_next_rout_page(Object num) {
    return Intl.message(
      'Temp Next Rout Page $num',
      name: 'temp_next_rout_page',
      desc: '',
      args: [num],
    );
  }

  /// `{count, plural, one{one} two{two} few{{count} page} many{{count}mm} other{{count} ???}}`
  String number(num count) {
    return Intl.plural(
      count,
      one: 'one',
      two: 'two',
      few: '$count page',
      many: '${count}mm',
      other: '$count ???',
      name: 'number',
      desc: '',
      args: [count],
    );
  }

  /// `Change locale`
  String get change_locale {
    return Intl.message(
      'Change locale',
      name: 'change_locale',
      desc: '',
      args: [],
    );
  }

  /// `New Gam`
  String get new_game {
    return Intl.message(
      'New Gam',
      name: 'new_game',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}