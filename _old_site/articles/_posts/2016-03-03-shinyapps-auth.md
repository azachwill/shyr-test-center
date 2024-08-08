---
layout: post
title: Authentication and authorization model for shinyapps.io
edited: 2016-03-03
description: With shinyapps.io, you can limit access to your application by enabling authentication. To enable authentication in the administrative UI, select the application to modify and click on the Users tab.
---

With shinyapps.io, you can limit access to your application by enabling authentication. To enable authentication in the administrative UI, select the application to modify and click on the Users tab. If you currently use the pre-beta authentication scheme, please follow the <a href="#Migrating">instructions to upgrade to the new system here.</a>

Here is a sample application with the default visibility settings (Public):
<img src="https://www.rstudio.com/wp-content/uploads/2015/01/shinyapps-screen-settings.png" alt="" />

Change the Application Visibility to Private and click on Save Settings. Changing the visibility of your application <span style="text-decoration: underline;">will require a restart</span> of the application. The Owner of the account and other members of the account will automatically be included in the list of authorized users.
<img src="https://www.rstudio.com/wp-content/uploads/2015/01/shinyapps-user-screen-settings.png" alt="" />

After the application is restarted you can add authorized users by entering their email addresses and clicking on Add User.
<img src="https://www.rstudio.com/wp-content/uploads/2015/01/shinyapps-add-user.png" alt="" />

Each user will receive an email from shinyapps.io with an invite to view your application. If a user does not already have an authenticated account on shinyapps.io, they will be able to create one by authenticating through one of the following three methods:
<ul>
  <li>Google Authorization</li>
  <li>GitHub authorization</li>
  <li>shinyapps.io authentication</li>
</ul>
shinyapps.io will prompt each visitor to your app for a username and password if they have not been authenticated. Only users who log-in with valid credentials will be able to view or use the app.
<a name="Migrating"></a>
If you currently use the pre-beta authentication scheme, please upgrade to the new system right away. We will be deprecating support for the old authentication system during the beta. For instructions on how to upgrade, please read the guide below.

&nbsp;
<h2>Migrating from our older authentication system</h2>
The beta release of shinyapps.io introduces a new mechanism for authentication and authorization. This system replaces the existing rscrypt based approach and provides a more flexible and manageable flow.

The new authentication system provides several advantages:
<ul>
  <li>Adding or removing authorized users no longer requires restarting the application thereby preserving the sessions of logged in users.</li>
  <li>Managing application access can now be handled through the admin interface.</li>
  <li>Security has been improved by leveraging Google or Github authentication for your users.</li>
  <li>Your users are no longer burdened with the task of managing and maintaining user authentication information.</li>
</ul>
To migrate your application from the old authentication system to the new one you will need to follow these steps:
<ol>
  <li>Set the Application Visibility setting to Private in the Users tab for that application and click Save Settings. This will restart the application and apply the new setting. Note, once you do this, none of the existing users will be able to authenticate.</li>
  <li>On your local system, rename the passwords.txt file in /shinyapps to old_passwords.txt.</li>
  <li>Re-deploy your application using shinyapps::deployApp()</li>
  <li>In the Users tab, add the email addresses for the individuals that were in your old_passwords.txt file. If you were not using email addresses before, you will need to do so at this time. Don’t worry if your users don’t have Google or GitHub accounts, they can always use local authentication through shinyapps.io.</li>
  <li>Your users should now be able to authenticate and see your application.</li>
</ol>
<h3>FAQ</h3>
<p><strong>Question</strong>: Can a given application have both the old and new authentication systems active at the same time?</p>
<p><strong>Answer</strong>: Yes, it is possible during the beta until we deprecate the old system. The user would be prompted to authenticate twice. We will disable the old authentication system in the weeks before the general availability of the service.</p>
