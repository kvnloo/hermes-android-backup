import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

Map<String, dynamic> catalogue(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  final english = catalogue('en');
  final keys = english.keys.where((k) => k.startsWith('rel_ops_')).toList();
  const locales = [
    'en',
    'ar',
    'de',
    'es',
    'fr',
    'ja',
    'ko',
    'pt',
    'pt_BR',
    'ru',
    'uk',
    'zh',
    'zh_Hans',
    'zh_Hant',
  ];

  test(
    'operations registry has descriptions and all 349 keys in source order',
    () {
      expect(keys, hasLength(349));
      for (final locale in locales) {
        final arb = catalogue(locale);
        expect(
          arb.keys.where((k) => k.startsWith('rel_ops_')).toList(),
          keys,
          reason: locale,
        );
        for (final key in keys) {
          expect(arb[key], isA<String>(), reason: '$locale:$key');
          expect(
            (arb[key] as String).trim(),
            isNotEmpty,
            reason: '$locale:$key',
          );
          expect(
            arb['@$key']['description'],
            isNotEmpty,
            reason: '$locale:$key',
          );
        }
      }
    },
  );

  for (final tag in locales) {
    test(
      '$tag generated operations copy matches explicit ARB values',
      () async {
        final parts = tag.split('_');
        final locale = parts.length == 1
            ? Locale(parts[0])
            : parts[1].length == 4
            ? Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1])
            : Locale(parts[0], parts[1]);
        final l = await AppLocalizations.delegate.load(locale);
        final arb = catalogue(tag);
        String render(String key, Map<String, Object> values) {
          var text = arb[key] as String;
          for (final entry in values.entries) {
            text = text.replaceAll('{${entry.key}}', '${entry.value}');
          }
          return text;
        }

        expect(l.rel_ops_cap_capabilities, arb['rel_ops_cap_capabilities']);
        expect(l.rel_ops_term_connecting, arb['rel_ops_term_connecting']);
        expect(l.rel_ops_ssh_pin_title, arb['rel_ops_ssh_pin_title']);
        expect(l.rel_ops_host_share_consent, arb['rel_ops_host_share_consent']);
        expect(
          l.rel_ops_cap_archive_explanation('hermes curator restore'),
          render('rel_ops_cap_archive_explanation', {
            'command': 'hermes curator restore',
          }),
        );
        expect(
          l.rel_ops_cap_error_the_gateway_refused_the_request_status(503),
          render('rel_ops_cap_error_the_gateway_refused_the_request_status', {
            'statusCode': 503,
          }),
        );
        expect(
          l.rel_ops_term_open_device_body('remote-fixture'),
          render('rel_ops_term_open_device_body', {
            'connection': 'remote-fixture',
          }),
        );
        expect(
          l.rel_ops_ssh_gateway_responding(9119),
          render('rel_ops_ssh_gateway_responding', {'port': 9119}),
        );
        expect(
          l.rel_ops_host_health_running('fixture-version', 3),
          render('rel_ops_host_health_running', {
            'version': 'fixture-version',
            'count': 3,
          }),
        );
        if (tag != 'en') {
          expect(
            l.rel_ops_term_connecting,
            isNot(english['rel_ops_term_connecting']),
          );
          expect(
            l.rel_ops_host_share_consent,
            isNot(english['rel_ops_host_share_consent']),
          );
        }
      },
    );
  }
}
