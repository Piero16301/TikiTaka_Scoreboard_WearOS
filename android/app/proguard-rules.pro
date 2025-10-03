# Configuración personalizada de ProGuard para TikiTaka Scoreboard
# Reemplaza las reglas por defecto de Android para evitar advertencias innecesarias

# Configuraciones básicas de optimización
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose
-dontoptimize
-dontpreverify

# Keep crash reporting y debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod

# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Play Core - Flutter deferred components (opcional)
# Si no usas componentes diferidos, estas clases pueden no estar presentes
-dontwarn com.google.android.play.core.**
-keep,allowobfuscation,allowshrinking class com.google.android.play.core.** { *; }
-keep,allowobfuscation,allowshrinking interface com.google.android.play.core.** { *; }

# Ignorar referencias faltantes de Flutter Play Store Split
-dontwarn io.flutter.embedding.android.FlutterPlayStoreSplitApplication
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Firebase rules
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Wear OS rules
-keep class androidx.wear.** { *; }

# Kotlin rules
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# Only keep necessary concurrent classes if they actually exist
-keep,allowobfuscation,allowshrinking class j$.util.concurrent.** {
    <fields>;
    <methods>;
}

# Keep enum methods only if enums are actually used
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Suprimir advertencias específicas de las reglas por defecto que no aplican
# Estas reglas vienen del archivo proguard-android-optimize.txt por defecto
-dontwarn j$.util.IntSummaryStatistics
-dontwarn j$.util.LongSummaryStatistics  
-dontwarn j$.util.DoubleSummaryStatistics
-dontwarn j$.util.concurrent.ConcurrentHashMap$TreeBin
-dontwarn j$.util.concurrent.ConcurrentHashMap$CounterCell
-dontwarn j$.util.concurrent.ConcurrentHashMap

# En lugar de usar reglas específicas que pueden no aplicar,
# simplemente ignoramos estas clases si no existen
# Las reglas -dontwarn ya están definidas arriba para suprimir advertencias

# General Android rules
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

# Reglas básicas de Android
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference
-keep public class * extends android.view.View

# Keep native method names
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep view constructors
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

# Keep activity lifecycle methods
-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}

# Keep enum values() y valueOf() solo para enums que realmente existen
# Evitamos la advertencia usando una regla más específica
-keepclassmembers,allowobfuscation enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable implementation
-keepclassmembers class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator CREATOR;
}

# Remove debugging information in release builds
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}