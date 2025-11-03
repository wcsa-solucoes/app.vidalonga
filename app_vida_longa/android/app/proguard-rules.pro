-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }
-dontwarn com.google.android.gms.**
-dontwarn com.google.firebase.**

# Google Play Billing
-keep class com.android.billingclient.** { *; }
-dontwarn com.android.billingclient.**

# In-app purchase plugin
-keep class io.flutter.plugins.inapppurchase.** { *; }
-dontwarn io.flutter.plugins.inapppurchase.**