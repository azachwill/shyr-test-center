export default async (request, context) => {
  const url = new URL(request.url);

  // Redirect specific URLs to their base paths
  if (url.pathname === '/index.html') {
    if (url.hostname === 'shypy-test-center.netlify.app') {
      return Response.redirect('https://shypy-test-center.netlify.app/', 301);
    } else if (url.hostname === 'shyr-test-center.netlify.app') {
      return Response.redirect('https://shyr-test-center.netlify.app/', 301);
    }
  }

  // Redirect all other URLs ending in '/' to '/index.html'
  if (url.pathname.endsWith('/') && url.pathname !== '/') {
    url.pathname += 'index.html';
    return Response.redirect(url.toString(), 301);
  }

  // If no redirect is needed, return the original request
  return context.next();
};
