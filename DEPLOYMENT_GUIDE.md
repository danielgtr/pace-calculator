# iOS App Deployment Guide

## Quick Start: Get the App on Your iPhone

This guide will walk you through getting the Pace Calculator app onto your iPhone for testing.

## Prerequisites

1. **Mac with Xcode installed** (download from Mac App Store if needed)
2. **Apple ID** (free - no paid developer account needed for testing)
3. **iPhone** with iOS 16.0 or later
4. **Lightning/USB-C cable** to connect iPhone to Mac

## Step-by-Step Instructions

### 1. Transfer the Project to Your Mac

If you're working on a different machine, transfer the entire `PaceCalculator` folder to your Mac:

```bash
# Option 1: Clone from git
git clone [your-repo-url]
cd pace-calculator

# Option 2: Download and extract the ZIP
# Then navigate to the folder in Finder
```

### 2. Open the Project in Xcode

1. Locate the `PaceCalculator` folder
2. Double-click on `PaceCalculator.xcodeproj`
3. Xcode should open automatically

### 3. Configure Code Signing

This is the most important step for deployment:

1. In Xcode, click on the **PaceCalculator** project in the left sidebar (the blue icon at the top)
2. Under **TARGETS**, select **PaceCalculator**
3. Click on the **Signing & Capabilities** tab
4. Under **Team**, click the dropdown and select **"Add an Account..."** if your Apple ID isn't listed
5. Sign in with your Apple ID
6. Once signed in, select your account from the **Team** dropdown
7. Xcode will automatically create a provisioning profile

**Important**: Change the Bundle Identifier if needed:
- The default is `com.yourcompany.PaceCalculator`
- Change it to something unique like `com.[yourname].PaceCalculator`
- Example: `com.john.PaceCalculator`

### 4. Connect Your iPhone

1. Connect your iPhone to your Mac using a USB cable
2. Unlock your iPhone
3. If prompted on your iPhone, tap **Trust** and enter your passcode
4. In Xcode, you should see your iPhone appear in the device dropdown (top bar, next to "PaceCalculator")

### 5. Build and Run

1. Select your iPhone from the device dropdown in Xcode's toolbar
2. Click the **Play button** (▶️) in the top left corner
3. Xcode will build the app and install it on your iPhone
4. This may take a minute or two the first time

### 6. Trust the Developer Certificate (First Time Only)

The first time you run an app on your iPhone, you need to trust it:

1. On your iPhone, the app will try to open but may show a security warning
2. Go to **Settings → General → VPN & Device Management** (or **Profiles & Device Management**)
3. Under "Developer App", tap on your Apple ID email
4. Tap **Trust "[Your Email]"**
5. Tap **Trust** again in the popup
6. Go back to the home screen and open the Pace Calculator app

### 7. Using the App

The app is now installed and ready to use! It will stay on your iPhone for 7 days (with a free Apple ID) before needing to be re-installed. With a paid developer account ($99/year), apps last for a full year.

## Troubleshooting

### "Failed to code sign" error
- Make sure you selected your Apple ID in the Team dropdown
- Try changing the Bundle Identifier to something unique
- Restart Xcode and try again

### Device not showing up in Xcode
- Make sure your iPhone is unlocked
- Check that you clicked "Trust" on your iPhone
- Try unplugging and reconnecting the cable
- Restart both Xcode and your iPhone

### "Unable to install" error
- Delete any existing version of the app from your iPhone
- Clean the build folder: Product → Clean Build Folder
- Try building again

### App crashes on launch
- Check the Xcode console for error messages
- Make sure your iPhone is running iOS 16.0 or later (Settings → General → About → iOS Version)

### "Untrusted Developer" message
- See Step 6 above about trusting the developer certificate
- This is normal for the first install

## Making Changes to the App

### Changing the Bundle Identifier
1. In Xcode, select the project → Target → Build Settings
2. Search for "Product Bundle Identifier"
3. Change the value to your desired identifier

### Changing the Display Name
1. Open `Info.plist`
2. Find "Bundle display name" or add it
3. Change the value to your desired app name

### Updating the App
After making code changes:
1. Save all files (⌘+S)
2. Click the Play button (▶️) again
3. Xcode will rebuild and reinstall automatically

## Next Steps: Publishing to TestFlight/App Store

If you want to distribute the app more widely:

1. **Join the Apple Developer Program** ($99/year)
2. **Create an App Store Connect record**
3. **Archive the app** (Product → Archive in Xcode)
4. **Upload to TestFlight** for beta testing
5. **Submit for App Store review** for public release

## Files You Can Customize

- **Bundle Identifier**: Make it unique to you
- **Display Name**: Change "Pace Calculator" to your preferred name
- **Colors/Styling**: Edit the SwiftUI views to change colors and layout
- **Preset Distances**: Add or remove races in `PaceCalculator.swift`

## Support

If you encounter issues:
1. Check the Xcode console for error messages (View → Debug Area → Show Debug Area)
2. Clean the build folder and try again
3. Restart Xcode
4. Make sure all file references are correct (they should be relative, not absolute)

## Summary Checklist

- [ ] Xcode installed on Mac
- [ ] Project opened in Xcode
- [ ] Apple ID added and team selected
- [ ] Bundle identifier is unique
- [ ] iPhone connected and trusted
- [ ] iPhone selected in device dropdown
- [ ] Build succeeded (▶️)
- [ ] Developer certificate trusted on iPhone
- [ ] App launches successfully

Good luck with your app deployment!
