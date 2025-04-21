export default async (request, context) => {
  const url = new URL(request.url);

  const patternArray = [
    //shiny.posit.co/r/ directories:\
    "/r/deploy",
    "/r/contribute",
    "/r/help",
    "/r/getstarted/build-an-app",
    // releases, e.g,: /0.1.2/upgrade.html
    "/r/reference/shiny/(\\d{1,3}\\.\\d{1,3}(\\.\\d{1,3})?|latest)",
    //shiny.posit.co/py/ directories:
    "/py/docs",
    "/py/api/core",
    "/py/api/express",
    "/py/api/testing"
  ];
  const pattern = new RegExp(patternArray.join("|"));
  const result = pattern.test(url);

  //exclude the following from redirect_article processing:
  const patternArrayNot = [
    "/r/reference/shiny/(\\d{1,3}\\.\\d{1,3}(\\.\\d{1,3})?|latest)(\\/?)$",
    //shiny.posit.co/py/ directories:
    "/py/api/core(\\/?)$",
    "/py/api/express(\\/?)$",
    "/py/api/testing(\\/?)$"
  ];
  const patternNot = new RegExp(patternArrayNot.join("|"));
  const resultNot = patternNot.test(url.pathname);

  // If the URL does not match the criteria, proceed with the request as usual
  if (!result || resultNot || url.pathname.endsWith(".html")) {
    return context.next();
  }

  // Remove the trailing slash and add .html extension
  const newPathname = url.pathname.endsWith("/") ? url.pathname.slice(0, -1) + '.html' : url.pathname + '.html';
  const newUrl = `${url.origin}${newPathname}${url.search}${url.hash}`;

  // Perform a 301 redirect
  return new Response(null, {
    status: 301,
    headers: {
      'Location': newUrl,
    },
  });
};

export const config = {
  path: ['/r/*', '/py/*'],
};