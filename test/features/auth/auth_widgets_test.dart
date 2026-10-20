import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:estate_app/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the Google mark parses inside its 48 x 48 box', () {
    final path = svgPath(
      'M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 '
      '14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z',
    );
    final b = path.getBounds();
    expect(b.left, closeTo(2.56, 0.01));
    expect(b.top, closeTo(0, 0.01));
    expect(b.right, closeTo(40.06, 0.01));
    expect(b.bottom, closeTo(19.41, 0.01));
    // Relative commands, H/V and S, and a stray number after Z ends parsing.
    expect(svgPath('M0 0h10v10s-5 5-10 0z 4').getBounds().right, 10);
  });

  test('an Indian mobile number reads in two groups of five', () {
    expect(displayIdentifier('+919876543210'), '+91\u00A098765\u00A043210');
    expect(displayIdentifier('a@b.co'), 'a@b.co');
  });
}
