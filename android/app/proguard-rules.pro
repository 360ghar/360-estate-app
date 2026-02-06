# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.google.firebase.** { *; }
-dontwarn io.flutter.embedding.**

# Gson
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class * implements com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Supabase
-keep class io.supabase.** { *; }
-keep class supabase.** { *; }
-dontwarn io.supabase.**
-dontwarn supabase.**

# Dio
-keep class com.squareup.okhttp.** { *; }
-keep interface com.squareup.okhttp.** { *; }
-dontwarn com.squareup.okhttp.**
-dontwarn okio.**

# Riverpod
-keep class dev.fluttercommunity.** { *; }
-keep,allowobfuscation,allowshrinking class dev.fluttercommunity.plus.connectivity.** { *; }

# App links
-keep class io.app_links.** { *; }
-keep class com.android.installreferrer.** { *; }

# Go Router
-keep,allowobfuscation,allowshrinking class io.flutter.plugins.go_router.** { *; }
-keep,allowobfuscation,allowshrinking class io.flutter.embedding.android.** { *; }

# Image picker
-keep class io.flutter.plugins.imagepicker.** { *; }

# Secure storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Connectivity
-keep class dev.fluttercommunity.plus.connectivity.** { *; }
