export default async (request, context) => {
  const url = new URL(request.url);

     // Check if the URL path is one of the index.html pages
    if (!url.pathname.endsWith(".html"))  {
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


  