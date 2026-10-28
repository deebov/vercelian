# Privacy Policy

**Effective date:** October 26, 2026

Vercelian is a macOS menu bar app that shows your Vercel deployments. This policy explains what the app does with your information.

**In short:** Vercelian does not collect your data. It has no server of its own, and everything stays on your Mac except the requests it makes to Vercel on your behalf.

## What we collect

Nothing. Vercelian has no accounts of its own, no analytics, no advertising, no tracking, and no third-party SDKs. We never receive your access token, your Vercel data, or your usage of the app.

## What the app keeps on your Mac

- **Your Vercel access token.** You create it on vercel.com and paste it into the app. It is stored in your macOS login Keychain and sent only to Vercel's API (`api.vercel.com`) over HTTPS.
- **Your selected team.** The ID of the team you are viewing is stored in your Keychain so the app remembers it.
- **Preferences.** Your notification and menu bar icon settings are stored in the app's preferences.

## What the app reads from Vercel

To show your deployments, the app requests your name, username, and email address, your teams and projects, and your recent deployments. Deployment details include URLs, branch names, commit messages, repository names, and who created the deployment. This data is held in memory while the app runs, is not written to disk, and is not sent anywhere else.

If you turn on notifications, the app creates them on your Mac and macOS shows them in Notification Center. A notification contains the project name, the deployment status, and the start of the commit message.

## Where data is sent

Only to Vercel, to load your deployments and to cancel or redeploy them when you ask. Vercel's handling of your data is covered by [Vercel's Privacy Policy](https://vercel.com/legal/privacy-policy).

Links you open from the app, such as a deployment URL, the Vercel dashboard, or GitHub, open in your web browser and are subject to those sites' own policies.

If you have chosen in macOS settings to share analytics with app developers, Apple may provide us with anonymous crash reports. Apple controls this, not the app.

## Removing your data

- **Sign out** in Vercelian's settings to remove your access token and selected team from your Keychain. The app also signs you out automatically if Vercel reports that your token has expired or been revoked.
- **Revoke the token** at any time at [vercel.com/account/tokens](https://vercel.com/account/tokens). This immediately ends the app's access to your account.
- **To remove everything,** sign out, delete the app, and delete its folder at `~/Library/Containers/com.vercelian.app`. If you deleted the app without signing out first, remove the `com.vercelian.app` item in Keychain Access.

## Children

Vercelian is a tool for developers and is not directed at children.

## Changes

If this policy changes, the new version will be posted here with a new effective date.

## Contact

Questions about this policy: open an issue at [github.com/deebov/vercelian/issues](https://github.com/deebov/vercelian/issues).

Vercelian is an independent project and is not affiliated with, endorsed by, or sponsored by Vercel Inc.
