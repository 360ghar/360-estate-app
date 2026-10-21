import 'dart:async';

import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/services/google_places_service.dart';
import 'package:estate_app/features/properties/data/models/location_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

final _placeSuggestionsProvider = FutureProvider.autoDispose
    .family<List<PlaceSuggestion>, String>((ref, query) async {
      if (query.trim().length < 2) return const [];
      return ref.read(googlePlacesServiceProvider).getPlaceSuggestions(query);
    });

/// Finds a place by name, or takes the phone's position, and returns it to
/// the screen that opened this one.
class LocationSearchPage extends ConsumerStatefulWidget {
  const LocationSearchPage({super.key});

  @override
  ConsumerState<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends ConsumerState<LocationSearchPage> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _locating = false;
  bool _selectingPlace = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    setState(() {}); // The clear button follows the text.
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted && _query != text) setState(() => _query = text);
    });
  }

  void _clear() {
    _debounce?.cancel();
    _searchController.clear();
    setState(() => _query = '');
  }

  Future<void> _useCurrentLocation() async {
    final l10n = context.l10n;
    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (mounted) {
          context.showSnack(
            l10n.locationServicesOff,
            actionLabel: l10n.locationSettings,
            onAction: Geolocator.openLocationSettings,
          );
        }
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        if (mounted) context.showSnack(l10n.locationPermissionNeeded);
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          context.showSnack(
            l10n.locationPermissionBlocked,
            actionLabel: l10n.locationSettings,
            onAction: Geolocator.openAppSettings,
          );
        }
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );
      if (!mounted) return;
      context.pop<LocationResult>(
        LocationResult(
          lat: position.latitude,
          lng: position.longitude,
          name: l10n.locationCurrentName,
        ),
      );
    } catch (_) {
      if (mounted) context.showSnack(l10n.locationFailed);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _selectPlace(PlaceSuggestion suggestion) async {
    setState(() => _selectingPlace = true);
    try {
      final details = await ref
          .read(googlePlacesServiceProvider)
          .getPlaceDetails(suggestion.placeId);
      if (!mounted) return;
      if (details == null) {
        context.showSnack(context.l10n.locationDetailsFailed);
        return;
      }
      context.pop<LocationResult>(
        LocationResult(lat: details.lat, lng: details.lng, name: details.name),
      );
    } catch (_) {
      if (mounted) context.showSnack(context.l10n.locationDetailsFailed);
    } finally {
      if (mounted) setState(() => _selectingPlace = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final searching = _query.trim().length >= 2;
    final suggestions = searching
        ? ref.watch(_placeSuggestionsProvider(_query))
        : null;

    final Widget results;
    if (_selectingPlace) {
      results = const Center(child: CircularProgressIndicator());
    } else if (suggestions == null) {
      results = AppEmptyView(
        icon: Icons.travel_explore_rounded,
        title: l10n.locationIdleTitle,
        message: l10n.locationIdleBody,
      );
    } else {
      results = suggestions.when(
        loading: () => const Align(
          alignment: Alignment.topCenter,
          child: LinearProgressIndicator(),
        ),
        error: (_, _) => AppErrorView(
          title: l10n.locationSearchFailed,
          message: l10n.commonLoadFailedBody,
          onRetry: () => ref.invalidate(_placeSuggestionsProvider(_query)),
        ),
        data: (items) => items.isEmpty
            ? AppEmptyView(
                icon: Icons.location_off_outlined,
                title: l10n.locationNoResultsTitle,
                message: l10n.locationNoResultsBody,
              )
            : ListView.separated(
                padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const Divider(indent: 56, endIndent: AppSpacing.lg),
                itemBuilder: (context, i) {
                  final s = items[i];
                  return ListTile(
                    leading: const Icon(Icons.place_outlined),
                    title: Text(s.mainText),
                    subtitle: s.secondaryText.isEmpty
                        ? null
                        : Text(s.secondaryText),
                    onTap: () => _selectPlace(s),
                  );
                },
              ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.locationSearchTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: l10n.locationSearchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l10n.commonClearSearch,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: _clear,
                      ),
              ),
            ),
          ),
          ListTile(
            enabled: !_locating,
            leading: Icon(Icons.my_location_rounded, color: colors.primary),
            title: Text(
              _locating ? l10n.locationDetecting : l10n.locationUseCurrent,
              style: context.text.titleSmall?.copyWith(color: colors.primary),
            ),
            trailing: _locating
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            onTap: _useCurrentLocation,
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(child: results),
        ],
      ),
    );
  }
}
