import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GoogleSignInOutcome { success, error }

/// "Continue with Google", drawn to Google's sign-in branding: the official
/// four-colour G on Google's neutral button colours (these hex values are
/// Google's, not the app palette).
///
/// Always visible: Google is enabled in Supabase. The controller picks the
/// native ID-token flow when `GOOGLE_WEB_CLIENT_ID` is configured, otherwise
/// the Supabase OAuth redirect flow (which needs no client id). With the
/// redirect flow the session arrives asynchronously, so a success result here
/// only means the redirect launched; routing is driven by the auth controller.
class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key, required this.enabled, this.onResult});

  final bool enabled;
  final ValueChanged<GoogleSignInOutcome>? onResult;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBusy = ref.watch(authControllerProvider.select((s) => s.isBusy));
    final canPress = enabled && !isBusy;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final (fill, edge, ink) = dark
        ? (
            const Color(0xFF131314),
            const Color(0xFF8E918F),
            const Color(0xFFE3E3E3),
          )
        : (Colors.white, const Color(0xFF747775), const Color(0xFF1F1F1F));

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: canPress ? () => _signIn(ref) : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: fill,
          foregroundColor: ink,
          disabledBackgroundColor: fill,
          side: BorderSide(color: edge),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.md),
        ),
        icon: const SizedBox.square(
          dimension: 20,
          child: CustomPaint(painter: _GoogleGPainter()),
        ),
        label: Text(context.l10n.authContinueWithGoogle),
      ),
    );
  }

  Future<void> _signIn(WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).signInWithGoogle();
    final error = ref.read(authControllerProvider).errorMessage;
    onResult?.call(
      error == null ? GoogleSignInOutcome.success : GoogleSignInOutcome.error,
    );
  }
}

/// The Google "G" from Google's published 48 x 48 sign-in mark.
class _GoogleGPainter extends CustomPainter {
  const _GoogleGPainter();

  static const _parts = <(int, String)>[
    (
      0xFFEA4335,
      'M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 '
          '14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z',
    ),
    (
      0xFF4285F4,
      'M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 '
          '5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z',
    ),
    (
      0xFFFBBC05,
      'M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 '
          '16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z',
    ),
    (
      0xFF34A853,
      'M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 '
          '2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z',
    ),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 48, size.height / 48);
    for (final (color, d) in _parts) {
      canvas.drawPath(svgPath(d), Paint()..color = Color(color));
    }
  }

  @override
  bool shouldRepaint(_GoogleGPainter old) => false;
}

/// Parses the SVG path commands the G uses: M L H V C S Z, absolute and
/// relative, with implicit repeats.
Path svgPath(String d) {
  final tokens = RegExp(
    r'[MmLlHhVvCcSsZz]|-?(?:\d+\.?\d*|\.\d+)',
  ).allMatches(d).map((m) => m.group(0)!).toList();
  final path = Path();
  var i = 0;
  var cmd = '';
  var x = 0.0, y = 0.0, cx = 0.0, cy = 0.0;
  var lastWasCurve = false;
  double n() => double.parse(tokens[i++]);
  while (i < tokens.length) {
    if (RegExp('[A-Za-z]').hasMatch(tokens[i])) cmd = tokens[i++];
    final rel = cmd == cmd.toLowerCase();
    final curve = cmd.toUpperCase() == 'C' || cmd.toUpperCase() == 'S';
    final ox = rel ? x : 0.0, oy = rel ? y : 0.0;
    switch (cmd.toUpperCase()) {
      case 'M':
        x = ox + n();
        y = oy + n();
        path.moveTo(x, y);
        cmd = rel ? 'l' : 'L';
      case 'L':
        x = ox + n();
        y = oy + n();
        path.lineTo(x, y);
      case 'H':
        x = ox + n();
        path.lineTo(x, y);
      case 'V':
        y = oy + n();
        path.lineTo(x, y);
      case 'C':
        final x1 = ox + n(), y1 = oy + n();
        cx = ox + n();
        cy = oy + n();
        x = ox + n();
        y = oy + n();
        path.cubicTo(x1, y1, cx, cy, x, y);
      case 'S':
        // Reflect the last control point; with no curve before, use the
        // current point (SVG rule).
        final x1 = lastWasCurve ? 2 * x - cx : x;
        final y1 = lastWasCurve ? 2 * y - cy : y;
        cx = ox + n();
        cy = oy + n();
        x = ox + n();
        y = oy + n();
        path.cubicTo(x1, y1, cx, cy, x, y);
      case 'Z':
        path.close();
        cmd = '';
      default:
        return path;
    }
    lastWasCurve = curve;
  }
  return path;
}
