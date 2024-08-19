export default async (request, context) => {
    const url = new URL(request.url);
     // Check if the URL path starts with /docs and ends with a trailing slash
    if (url.pathname.startsWith('/py/docs') && url.pathname.endsWith('/')) {
      // Remove the trailing slash and add .html extension
      const newPathname = url.pathname.slice(0, -1) + '.html';
      const newUrl = `${url.origin}${newPathname}${url.search}`;
    
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
    path: '/py/docs/*',
  };
 