export default async (request, context) => {
  const url = new URL(request.url);

  const patternArray = [
    //shiny.posit.co/r/ directories:\
    "\/r\/deploy",
    "\/r\/contribute",
    "\/r\/help",
    "\/r\/getstarted/build-an-app",
    // releases, e.g,: /0.1.2/upgrade.html
    "\/r\/reference\/shiny\/((\\d{1,3}\\.\\d{1,3}(\\.\\d{1,3})?)|latest)",
    //shiny.posit.co/py/ directories:
    "\/py\/docs",
    "\/py\/api\/core",
    "\/py\/api\/express",
    "/\py\/api\/testing"
    ];
    const pattern = new RegExp(patternArray.join("|"));
    const result = pattern.test(url);

    const patternArrayNot = [
      "\/r\/reference\/shiny\/latest(\/?)$",
      //shiny.posit.co/py/ directories:
      "\/py\/api\/core(\/?)$",
      "\/py\/api\/express(\/?)$",
      "/\py\/api\/testing(\/?)$"
      ];
      const patternNot = new RegExp(patternArrayNot.join("|"));
      const resultNot = patternNot.test(url);

     // Check if the URL path is one of the index.html pages
     if ( result && !resultNot &&  !url.pathname.endsWith(".html"))  {
      // Remove the trailing slash and add .html extension
      const newPathname = url.pathname.endsWith("/") ? url.pathname.slice(0, -1) + '.html' : url.pathname + '.html';
      const newUrl = `${url.origin}${newPathname}`;
    
        // Perform a 301 redirect
      return new Response(null, {
        status: 301,
        headers: {
          'Location': newUrl,
        },
      });
    }
     // If the URL does not match the criteria, proceed with the request as usual
    return context.next();
  };
   export const config = {
    path: ['/r/*','/py/*'],
  };
