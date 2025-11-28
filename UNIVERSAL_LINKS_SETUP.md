# Universal Links / App Links Setup Guide

To remove the browser prompt and enable automatic app opening, you need to set up Universal Links (iOS) and App Links (Android).

## Current Setup (Custom URL Scheme)
- Uses `janus://checkout-success` and `janus://checkout-cancel`
- Shows browser prompt: "Open in Janus?"
- Works but requires user confirmation

## Target Setup (Universal Links/App Links)
- Uses `https://yourdomain.com/checkout-success` and `https://yourdomain.com/checkout-cancel`
- Opens app automatically without prompt
- Seamless user experience

## Steps to Implement

### 1. Update Edge Function

Update your Stripe checkout edge function to use HTTPS URLs:

```javascript
success_url: "https://yourdomain.com/checkout-success?session_id={CHECKOUT_SESSION_ID}",
cancel_url: "https://yourdomain.com/checkout-cancel"
```

Replace `yourdomain.com` with your actual domain (e.g., your Supabase project domain or a custom domain).

### 2. Create Redirect Pages

Create two HTML pages on your server:

**checkout-success.html:**
```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful</title>
    <script>
        // Get session_id from URL
        const urlParams = new URLSearchParams(window.location.search);
        const sessionId = urlParams.get('session_id');
        
        // Try to open app with custom scheme (fallback)
        window.location.href = 'janus://checkout-success?session_id=' + sessionId;
        
        // If app doesn't open, show message
        setTimeout(function() {
            document.body.innerHTML = '<h1>Payment Successful!</h1><p>Please open the Janus app to continue.</p>';
        }, 1000);
    </script>
</head>
<body>
    <h1>Redirecting to Janus app...</h1>
</body>
</html>
```

**checkout-cancel.html:**
```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Cancelled</title>
    <script>
        // Try to open app with custom scheme (fallback)
        window.location.href = 'janus://checkout-cancel';
        
        // If app doesn't open, show message
        setTimeout(function() {
            document.body.innerHTML = '<h1>Payment Cancelled</h1><p>Please open the Janus app to continue.</p>';
        }, 1000);
    </script>
</head>
<body>
    <h1>Redirecting to Janus app...</h1>
</body>
</html>
```

### 3. iOS Universal Links Setup

Add to `ios/Runner/Info.plist`:

```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:yourdomain.com</string>
</array>
```

Create `.well-known/apple-app-site-association` file on your server:

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAM_ID.com.your.bundle.id",
        "paths": [
          "/checkout-success*",
          "/checkout-cancel*"
        ]
      }
    ]
  }
}
```

### 4. Android App Links Setup

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="https"
        android:host="yourdomain.com"
        android:pathPrefix="/checkout-success" />
    <data
        android:scheme="https"
        android:host="yourdomain.com"
        android:pathPrefix="/checkout-cancel" />
</intent-filter>
```

Create `.well-known/assetlinks.json` file on your server:

```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.your.package.name",
    "sha256_cert_fingerprints": ["YOUR_SHA256_FINGERPRINT"]
  }
}]
```

## Quick Solution (Without Domain Setup)

If you don't have a domain set up yet, the current custom URL scheme (`janus://`) will continue to work, but will show the browser prompt. This is a security feature and cannot be completely removed without Universal Links/App Links.

The app will still receive the deep link when opened, even if Safari shows an error.

