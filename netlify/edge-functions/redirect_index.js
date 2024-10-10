export default async (request, context) => {
  const url = new URL(request.url);
  const pattern = /(https:\/\/shyr-test-center\.netlify\.app|https:\/\/shypy-test-center\.netlify\.app)(\/?)/;
  const result = pattern.test(url);

  // Redirect specific URLs to their base paths
  if ( !result && url.pathname.endsWith("/"))  {
    // Add .html extension
    const newPathname = url.pathname + 'index.html';
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
 path: ['/'],
};
