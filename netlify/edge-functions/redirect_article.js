export default async (request, context) => {
    const url = new URL(request.url);
    const pattern = /\/(core|express|testing)(\/?)$/;
    const result = pattern.test(url);

     // Check if the URL path is one of the index.html pages
    if ( !result && !url.endsWith(".html"))  {
      // Remove the trailing slash and add .html extension
      const newPathname = url.pathname.slice(0) + '.html';
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
    path: ['/py/docs/*', "/py/api/*"],
  };
 