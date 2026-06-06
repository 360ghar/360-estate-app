import 'package:estate_app/core/services/deep_link_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeepLinkService.mapUriToPath', () {
    test('maps public rental application slug to /public/applications/{slug}',
        () {
      expect(
        DeepLinkService.mapUriToPath(
          Uri.parse('https://the360ghar.com/estate/apply/sunrise-tower'),
        ),
        '/public/applications/sunrise-tower',
      );
    });

    test('maps property deep link to /properties/{id}', () {
      expect(
        DeepLinkService.mapUriToPath(
          Uri.parse('https://the360ghar.com/estate/property/42'),
        ),
        '/properties/42',
      );
    });

    test('maps task deep link to /tasks/{id}', () {
      expect(
        DeepLinkService.mapUriToPath(
          Uri.parse('https://the360ghar.com/estate/task/77'),
        ),
        '/tasks/77',
      );
    });

    test('maps tenant deep link to /more/tenants/{id}', () {
      expect(
        DeepLinkService.mapUriToPath(
          Uri.parse('https://the360ghar.com/estate/tenant/123'),
        ),
        '/more/tenants/123',
      );
    });

    test('maps lease deep link to /more/leases/{id}', () {
      expect(
        DeepLinkService.mapUriToPath(
          Uri.parse('https://the360ghar.com/estate/lease/99'),
        ),
        '/more/leases/99',
      );
    });

    test('honors www. and app. subdomains', () {
      expect(
        DeepLinkService.mapUriToPath(
          Uri.parse('https://www.the360ghar.com/estate/property/1'),
        ),
        '/properties/1',
      );
      expect(
        DeepLinkService.mapUriToPath(
          Uri.parse('https://app.the360ghar.com/estate/lease/2'),
        ),
        '/more/leases/2',
      );
    });

    test('maps custom-scheme deep link with property host', () {
      expect(
        DeepLinkService.mapUriToPath(
          Uri.parse('estate360://property/abc-123'),
        ),
        '/properties/abc-123',
      );
    });

    test('maps custom-scheme apply host to public application page', () {
      expect(
        DeepLinkService.mapUriToPath(
          Uri.parse('estate360://apply/sunrise-tower'),
        ),
        '/public/applications/sunrise-tower',
      );
    });

    test('returns null for unknown entity types', () {
      expect(
        DeepLinkService.mapUriToPath(
          Uri.parse('https://the360ghar.com/estate/invoice/1'),
        ),
        isNull,
      );
    });

    test('returns null for paths missing the id segment', () {
      expect(
        DeepLinkService.mapUriToPath(
          Uri.parse('https://the360ghar.com/estate/property'),
        ),
        isNull,
      );
    });

    test('returns null for paths not under /estate', () {
      expect(
        DeepLinkService.mapUriToPath(
          Uri.parse('https://the360ghar.com/flatmates/listing/1'),
        ),
        isNull,
      );
    });
  });

  group('DeepLinkService share URL builders', () {
    test('propertyUrl uses canonical the360ghar.com path', () {
      expect(
        DeepLinkService.propertyUrl('42'),
        'https://the360ghar.com/estate/property/42',
      );
    });

    test('applicationUrl uses canonical the360ghar.com path', () {
      expect(
        DeepLinkService.applicationUrl('sunrise-tower'),
        'https://the360ghar.com/estate/apply/sunrise-tower',
      );
    });
  });
}
