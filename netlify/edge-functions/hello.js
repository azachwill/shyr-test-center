export default async (request, context) => {
    const url = new URL(request.url);
    let newPathname = '';
    let newUrl = '';
  
    // Check if the URL path starts with /docs and ends with a trailing slash
    switch (url){
    case (url.pathname.startsWith('/py/docs') && url.pathname.endsWith('/')):
      // Remove the trailing slash and add .html extension
      newPathname = url.pathname.slice(0, -1) + '.html';
      newUrl = `${url.origin}${newPathname}`;
      break;
    case ( url.pathname.endsWith('index.html')):
      // Remove the trailing slash and add .html extension
      newPathname = url.pathname.slice(0, -1) + 'index.html';
      newUrl = `${url.origin}${newPathname}`;
      break;     
    default:
      break;
      }
      {
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
    path: '/*',
  };
  