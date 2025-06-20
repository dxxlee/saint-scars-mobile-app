// lib/frontend/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final ColorSelection colorSelected;
  final Locale currentLocale;

  /// true = light theme
  final ValueChanged<bool> onThemeChanged;

  /// index of ColorSelection
  final ValueChanged<int> onColorChanged;

  /// new callback: when user picks a different locale
  final ValueChanged<Locale> onLocaleChanged;

  const SettingsScreen({
    Key? key,
    required this.themeMode,
    required this.colorSelected,
    required this.currentLocale,
    required this.onThemeChanged,
    required this.onColorChanged,
    required this.onLocaleChanged,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isLight;
  late ColorSelection _accent;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _isLight = widget.themeMode == ThemeMode.light;
    _accent  = widget.colorSelected;
    _locale  = widget.currentLocale;
  }

  Future<void> _persistTheme(bool isLight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lightTheme', isLight);
  }

  Future<void> _persistAccent(int idx) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accentColor', idx);
  }

  Future<void> _persistLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // наши поддерживаемые языки
    final locales = <Locale>[
      const Locale('en'),
      const Locale('ru'),
      const Locale('kk'),
    ];
    // читаемые имена
    final localeNames = {
      'en': l10n.languageEnglish,
      'ru': l10n.languageRussian,
      'kk': l10n.languageKazakh,
    };

    return Scaffold(

      body: ListView(
        padding: const EdgeInsets.all(defaultPadding),
        children: [
          // — переключатель light/dark —
          SwitchListTile(
            title: Text(l10n.lightTheme),
            subtitle: Text(_isLight ? l10n.enabled : l10n.disabled),
            secondary: const Icon(Icons.brightness_6_outlined),
            value: _isLight,
            onChanged: (val) {
              setState(() => _isLight = val);
              widget.onThemeChanged(val);
              _persistTheme(val);
            },
          ),
          const Divider(),

          // — выбор акцентного цвета —
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l10n.accentColor,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          Wrap(
            spacing: 8,
            children: ColorSelection.values.map((c) {
              final idx = c.index;
              final sel = c == _accent;
              return ChoiceChip(
                label: Text(c.label),
                selected: sel,
                selectedColor: c.color.withOpacity(0.2),
                backgroundColor: Colors.grey.shade200,
                labelStyle: TextStyle(color: sel ? c.color : null),
                onSelected: (_) {
                  setState(() => _accent = c);
                  widget.onColorChanged(idx);
                  _persistAccent(idx);
                },
              );
            }).toList(),
          ),
          const Divider(),

          // — выбор языка приложения —
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
          ),
          DropdownButton<Locale>(
            isExpanded: true,
            value: _locale,
            items: locales.map((loc) {
              return DropdownMenuItem(
                value: loc,
                child: Text(localeNames[loc.languageCode] ?? loc.languageCode),
              );
            }).toList(),
            onChanged: (newLoc) {
              if (newLoc == null) return;
              setState(() => _locale = newLoc);
              widget.onLocaleChanged(newLoc);
              _persistLocale(newLoc.languageCode);
            },
          ),
        ],
      ),
    );
  }
}
