---
layout: post
title: Migrating authentication on shinyapps.io
edited: 2020-12-16
description: The general release of shinyapps.io introduced a new mechanism for authentication and authorization. This system replaced the previous rscrypt based approach to provide a more flexible and manageable flow.
---

The general release of shinyapps.io in 2015 introduced a new mechanism for authentication and authorization. This system replaced the existing rscrypt based approach and provides a more flexible and manageable flow.

The current authentication system provides several advantages. With it you can:

* Add or remove authorized users without restarting the application thereby preserving the sessions of logged in users.
* Manage application access through the admin interface.
* Leverage Google or Github authentication to improve security for your users.
* Save your users the burden of managing and maintaining their own user authentication information.

The steps below were used to migrate applications from the old authentication system to the new one:

1. Set the Application Visibility setting to Private in the Users tab for that application and click Save Settings. This will restart the application and apply the new setting. Note, once you do this, none of the existing users will be able to authenticate.
2. On your local system, rename the `passwords.txt` file in `/shinyapps` to `old_passwords.txt`.
3. Re-deploy your application using `shinyapps::deployApp()`
4. In the Users tab, add the email addresses for the individuals that were in your `old_passwords.txt` file. If you were not using email addresses before, you will need to do so at this time. Don't worry if your users don't have Google or GitHub accounts, they can always use local authentication through shinyapps.io.
5. Your users should now be able to authenticate and see your application.
