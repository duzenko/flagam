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
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `The old emperor is dead and the civil war has already started. It's time for the old necromancer to once again roll the dice of fate!`
  String get prologue {
    return Intl.message(
      'The old emperor is dead and the civil war has already started. It\'s time for the old necromancer to once again roll the dice of fate!',
      name: 'prologue',
      desc: '',
      args: [],
    );
  }

  /// `War requires resources. It is logical to start with something simpler - for example, the nearest sawmill.`
  String get chapter1 {
    return Intl.message(
      'War requires resources. It is logical to start with something simpler - for example, the nearest sawmill.',
      name: 'chapter1',
      desc: '',
      args: [],
    );
  }

  /// `All enemies are defeated! All you can do is reap the fruits of a glorious victory and write your memoirs.`
  String get epilogue {
    return Intl.message(
      'All enemies are defeated! All you can do is reap the fruits of a glorious victory and write your memoirs.',
      name: 'epilogue',
      desc: '',
      args: [],
    );
  }

  /// `Sawmill`
  String get sawmill {
    return Intl.message(
      'Sawmill',
      name: 'sawmill',
      desc: '',
      args: [],
    );
  }

  /// `The workers are hard at work, bringing your triumph closer.`
  String get sawmillDesc {
    return Intl.message(
      'The workers are hard at work, bringing your triumph closer.',
      name: 'sawmillDesc',
      desc: '',
      args: [],
    );
  }

  /// `Ancient Ruins`
  String get ruins {
    return Intl.message(
      'Ancient Ruins',
      name: 'ruins',
      desc: '',
      args: [],
    );
  }

  /// `In these ruins you hid from the cruel world, and now they will become the new capital of the world.`
  String get ruinsDesc {
    return Intl.message(
      'In these ruins you hid from the cruel world, and now they will become the new capital of the world.',
      name: 'ruinsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Peasant`
  String get peasant {
    return Intl.message(
      'Peasant',
      name: 'peasant',
      desc: '',
      args: [],
    );
  }

  /// `Skeleton`
  String get skeleton {
    return Intl.message(
      'Skeleton',
      name: 'skeleton',
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
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
