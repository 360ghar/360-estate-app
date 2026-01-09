/// Standard image sizes for optimized loading and memory usage.
///
/// Using these constants ensures consistent image display across the app
/// and helps optimize memory usage by pre-defining cache dimensions.
abstract final class AppImageSizes {
  /// Thumbnail size for list items and cards (400px width)
  static const int thumbnail = 400;

  /// Detail view size for full-width images (800px width)
  static const int detail = 800;

  /// Full quality size for gallery/zoom views (1200px width)
  static const int full = 1200;

  /// Avatar/profile picture size (150px width)
  static const int avatar = 150;

  /// Maximum disk cache size for images
  static const int maxDiskCache = 1500;

  /// Memory cache height for thumbnails (16:9 aspect ratio)
  static const int thumbnailHeight = 225;

  /// Memory cache height for detail view (16:9 aspect ratio)
  static const int detailHeight = 450;
}
