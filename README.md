## 🔐 Google Login aktivieren

### 1. `google_sign_in` Plugin hinzufügen

In `pubspec.yaml`:

```yaml
dependencies:
  google_sign_in: ^7.1.1
```

---

### 2. Google-Login-Code in `FirebaseAuthRepository` (siehe oben) ✅

- `signInWithGoogle()` Methode

```dart
@override
  Future<String?> signInWithGoogle() async {
    try {
      // Kann nötig sein wenn Authenticationflow nicht auftaucht, Müsst ihr mal ausprobieren
      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      return "Google-Fehler: $e";
    }
    return null;
  }
```

- `logout()` Methode ergänzt um `GoogleSignIn().signOut()`

---

### 3. Im Firebase-Console den Google Provider aktivieren

**Schritte:**
- Authentifizierung > Sign-in-Methoden
- Google aktivieren und speichern

---

### 4. Konfigurationsdaten aktualisieren

⚠️ Es kann auch nötig den SHA Key hinzuzufügen: https://developers.google.com/android/guides/client-auth
- Überprüfe außerdem, dass der Packagename der App mit dem von Firebase übereinstimmt

⚠️ Falls du den Google-Provider **neu** aktivierst, solltest du zur Sicherheit:
- die `google-services.json` (Android)
- und `GoogleService-Info.plist` (iOS)

**neu herunterladen und ersetzen.**


---

### 5. iOS Konfiguration anpassen (`ios/Runner/Info.plist`)

```xml
<key>GIDClientID</key>
<string><!-- Hier die CLIENT_ID aus der GoogleService-Info.plist --></string>

<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string><!-- Hier REVERSE_CLIENT_ID, z.B. com.googleusercontent.apps.xyz --></string>
    </array>
  </dict>
</array>
```

Tipp: Die `REVERSE_CLIENT_ID` findest du ebenfalls in der `GoogleService-Info.plist`.

---

### 6. Android Konfiguration anpassen (`android/app/build.gradle`)

In der defaultConfig die minSdk = 23 setzen

```gradle
 defaultConfig {
      
        applicationId = "com.example.testvlapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
```



---

### 7. Funktion testen 🎉

- App starten
- Auf "Mit Google anmelden" klicken
- Authentifizierung prüfen

---
