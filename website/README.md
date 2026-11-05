# vercelian.co

The website, a static site in `public/`, served by Vercel from the `vercelian` project in the A-PEAK Works team.

Deploy from this folder with `vercel deploy --prod`, after linking it once with `vercel link --scope a-peak --project vercelian`. `.vercelignore` keeps everything but `public/` and `vercel.json` out of the upload.

## What `vercel.json` does

- **Clean addresses.** `/privacy` serves `privacy.html`, and the `.html` addresses redirect to the clean ones for good. Addresses that don't exist get `404.html`.
- **www.** `www.vercelian.co` redirects to the same path and query on `vercelian.co`, so links and search engines settle on one address. The rule matches `/:path(.*)`, not `/:path*`, which on Vercel skips the home page.
- **Security headers.** The site loads everything from itself. The demo needs inline styles for its colors; nothing else is inline.
- **Fonts.** The font file never changes, so browsers can keep it for a year.
- **Text files.** The Markdown copies of the pages and the `.txt` files are served as UTF-8, since many tools misread anything beyond ASCII without a character set. The Markdown copies also name the HTML pages as the originals, so search engines list those instead.
- **Search.** Only `vercelian.co` is indexed. Every other address the project answers on, such as `vercelian.vercel.app`, sends `X-Robots-Tag: noindex`.

## DNS

The domain is registered with Namecheap, and its DNS is on Cloudflare. `vercelian.co` and `www` are A records to `76.76.21.21`, set to DNS only so traffic goes straight to Vercel. The MX and TXT records are Namecheap's email forwarding.
