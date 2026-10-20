import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:estate_app/features/inspections/inspections_providers.dart';
import 'package:estate_app/features/inspections/models/inspection_template.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AppPreferences> _prefs([Map<String, Object> initial = const {}]) async {
  SharedPreferences.setMockInitialValues(initial);
  return AppPreferences.create();
}

InspectionTemplate _template(String name) =>
    InspectionTemplate.create(name: name, items: const ['Door']);

void main() {
  group('inspection templates are kept per account', () {
    test('one account never reads the templates of another', () async {
      final prefs = await _prefs();
      final first = InspectionTemplatesNotifier(prefs, 7);
      await first.addTemplate(_template('Move-in'));

      expect(first.state.map((t) => t.name), ['Move-in']);
      expect(InspectionTemplatesNotifier(prefs, 8).state, isEmpty);
      expect(InspectionTemplatesNotifier(prefs, 7).state.map((t) => t.name), [
        'Move-in',
      ]);
      expect(prefs.getString(inspectionTemplatesKey(7)), isNotNull);
      expect(prefs.getString(inspectionTemplatesKey(8)), isNull);
    });

    test('nobody signed in reads and writes nothing', () async {
      final prefs = await _prefs();
      final signedOut = InspectionTemplatesNotifier(prefs, null);
      await signedOut.addTemplate(_template('Ghost'));

      expect(
        SharedPreferences.getInstance().then((p) => p.getKeys()),
        completion(isEmpty),
      );
    });

    test(
      'the old global list moves to the first account and is removed',
      () async {
        final legacy = InspectionTemplate.encodeList([_template('Old')]);
        final prefs = await _prefs({'inspection_templates': legacy});

        final first = InspectionTemplatesNotifier(prefs, 7);
        expect(first.state.map((t) => t.name), ['Old']);
        // The move is written in the background: let it finish.
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(prefs.getString('inspection_templates'), isNull);
        expect(prefs.getString(inspectionTemplatesKey(7)), isNotNull);
        expect(InspectionTemplatesNotifier(prefs, 8).state, isEmpty);
      },
    );
  });
}
