import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rock_paper_scissors/l10n/app_localizations.dart';

export 'package:rock_paper_scissors/l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Formats [value] with the active locale's digits (e.g. ۳ in Persian).
  String number(num value) {
    final locale = Localizations.localeOf(this).toLanguageTag();
    return NumberFormat.decimalPattern(locale).format(value);
  }
}
