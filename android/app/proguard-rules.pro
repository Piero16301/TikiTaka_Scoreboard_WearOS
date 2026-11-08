# Flutter wrapper proguard rules
# You can add custom keep rules here if needed

# shared_preferences: Prevent R8 from stripping or obfuscating classes and methods
# accessed via JNI from Dart (fixes NoSuchMethodError on SharedPreferencesApiRegistrar in release builds)
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keepclassmembers class io.flutter.plugins.sharedpreferences.** { *; }
