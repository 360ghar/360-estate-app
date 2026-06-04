import 'dart:async';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_durations.dart';
import 'package:flutter/material.dart';

/// Splash screen with navy/indigo theme matching the app design.
/// Content has staggered entrance animations for a premium feel.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _titleController;
  late final AnimationController _loaderController;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _loaderFade;

  @override
  void initState() {
    super.initState();

    // Logo: fade in + scale 0-300ms
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: AppDurations.entranceCurve,
    );
    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: AppDurations.entranceCurve),
    );

    // Title: slide up + fade 200-500ms
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _titleFade = CurvedAnimation(
      parent: _titleController,
      curve: AppDurations.entranceCurve,
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: AppDurations.entranceCurve,
    ));

    // Loader: fade in 400-700ms
    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loaderFade = CurvedAnimation(
      parent: _loaderController,
      curve: AppDurations.entranceCurve,
    );

    // Stagger the animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _titleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _loaderController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient with navy theme
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1E3A5F), // Navy primary
                  Color(0xFF152E4D), // Darker navy
                  Color(0xFF0F2338), // Even darker
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Decorative circles (subtle)
          Positioned(
            top: -100,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ),

          // Main content - centered and non-scrollable
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  // Top space (flex instead of fixed for adaptability)
                  const Expanded(flex: 3, child: SizedBox()),

                  // Logo container — stagger phase 1
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title + tagline — stagger phase 2
                  FadeTransition(
                    opacity: _titleFade,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Column(
                        children: [
                          Text(
                            '360 Estate',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Property Management Made Simple',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Middle space
                  const Expanded(flex: 4, child: SizedBox()),

                  // Loading indicator — stagger phase 3
                  FadeTransition(
                    opacity: _loaderFade,
                    child: Column(
                      children: [
                        Text(
                          'INITIALIZING',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 11,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 200,
                          height: 3,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: 0.35,
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom branding
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _loaderFade,
                    child: Text(
                      "INDIA'S TRUSTED PROPERTY HUB",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
