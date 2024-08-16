export default async (request, context) => {
  const getURL = window.location.href;
  let articleUrl = getURL.indexOf(".html");
  let indexUrl = getURL.indexOf("index.html");

  if ( articleUrl > 0 && indexUrl < 0 ) { //this is an article page with an .html extension
    let redirectURL = getUrl.split(".html")+"/";
    const url = new URL(redirectURL, request.url); // Replace  with  target URL
  return Response.redirect(url, 301); 
  }
};
