// A permanent redirect to the same path and query on the main domain, so
// search engines and links settle on one address.
export default {
  fetch(request) {
    const url = new URL(request.url);
    url.protocol = "https:";
    url.host = "vercelian.co";
    return Response.redirect(url.href, 301);
  },
};
