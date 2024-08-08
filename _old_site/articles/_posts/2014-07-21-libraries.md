---
layout: post
title: Allowing different libraries for different apps on Shiny Server, Shiny Server Pro, and RStudio Connect
edited: 2020-12-16
author: Jeff Allen
description: This article describes how to configure deployed applications to use different sets of libraries.
---

This article describes two ways to configure applications to use different sets of libraries in Shiny Server, Shiny Server Pro, and RStudio Connect.

## Different libraries for different apps on RStudio Connect

RStudio Connect installs the R package dependencies of Shiny applications using the [`rsconnect`](https://github.com/rstudio/rsconnect) and [`packrat`](https://github.com/rstudio/packrat) R packages to identify the target source code and enumerate its dependencies. That information is bundled into an archive (`.tar.gz`) file and uploaded to RStudio Connect. This is done on a per-app basis, therefore two apps on RStudio Connect can use different packages or different versions of the same packages. The `packrat` package attempts to re-use R packages whenever possible, so if two apps share the same version of a package as a dependency, they can take advantage of previously-installed packages, hence making deployment faster.

## Different libraries for different apps on Shiny Server and Shiny Server Pro

Allowing for different libraries for different apps on Shiny Server and Shiny Server Pro requires a different approach. In the remainder of this article we describe two ways to configure applications to use different sets of libraries on Shiny Server and Shiny Server Pro. 

* Method 1 relies on Shiny Server's `exec_supervisor` feature. It will only work with Shiny Server Pro.
* Method 2 relies on Shiny Server's `run_as` feature. It will work with both Shiny Server and Shiny Server Pro.

### Method 1 - exec_supervisor

With Shiny Server Pro, you can run R sessions under a program supervisor that modifies the environment of the sessions. You can use this supervisor to set the `R_LIBS_USER` environmental variable, which controls which libraries a session may use.

[Section 3.6](https://docs.rstudio.com/shiny-server/#program-supervisors) of the Shiny Server [Administrator's Guide](https://docs.rstudio.com/shiny-server/) explains how to add a program supervisor. You add an `exec_supervisor` setting to your server config file to specify a supervisor (and the arguments which control its behavior). 

The file below uses `exec_supervior` to modify the default  _/etc/shiny-server/shiny-server.conf_ file that ships with Shiny Server. `exec_supervisor` partitions the applications up by setting the `R_LIBS_USER` environment variable. 

Near the bottom of the file, a `/finance` sub-location is defined for apps that use a specific set of libraries. Beneath that, a specific app is given its own set of libraries. 

{% highlight R %}
# Instruct Shiny Server to run applications as the user "shiny"
run_as shiny;

# Specify the authentication method to be used.
# Initially, a flat-file database stored at the path below.
auth_passwd_file /etc/shiny-server/passwd;

# Define a server that listens on port 3838
server {
  listen 3838;

  # Define a location at the base URL
  location / {
    # Define a default library for applications
    exec_supervisor "R_LIBS_USER=/usr/lib/LibraryA";

    # Only up tp 20 connections per Shiny process and 
    # at most 3 Shiny processes per application. 
    # Proactively spawn a new process when our processes 
    # reach 90% capacity.
    utilization_scheduler 20 .9 3;

    # Host the directory of Shiny apps stored in this directory
    site_dir /srv/shiny-server;

    # Log all Shiny output to files in this directory
    log_dir /var/log/shiny-server;

    # When a user visits the base URL rather than a particular application,
    # an index of the applications available in this directory will be shown.
    directory_index on;

    # Now define a sub-location at /finance
    location /finance {
      # Define a library that should be used by the finance department
      exec_supervisor "R_LIBS_USER=/usr/lib/FinanceLibrary";

      
      # Further, define another sub-location that happens to correspond to 
      # a particular app.
      location /app1 {
        #Define a specific library to be used by this application
        exec_supervisor "R_LIBS_USER=/usr/lib/LibraryC";
      }
    }
  }
}

# Provide the admin interface on port 4151
admin 4151 {
  
  # Restrict the admin interface to the usernames listed here. Currently
  # just one user named "admin"
  required_user admin;
}
{% endhighlight %}

In this case, you could set up as many different libraries as you want and specify a different library for each location, or even each application that you want to deploy. This would give you fine-grained control over each of your applications.


### Method 2 - run_as

Shiny Server (and Shiny Server Pro) use a `run_as` setting to determine which user should spawn each R Shiny processes. The user setting determines which library R will look in for packages (as well as which directories the app will be able to read and write to).

The `run_as` setting can be configured globally, or for a particular server or location. As a result, you can set up different locations for hosting apps that use different packages. Each location can be affiliated with its own user—each of which presumably has a different set of libraries specified with a _~/.Rprofile_ file.

With this approach, you would probably have only a handful of users that you create that each maintain their own separate libraries. 

[Section 2.3](http://rstudio.github.io/shiny-server/latest/#run_as) of the Shiny Server [Administrator's Guide](http://rstudio.github.io/shiny-server/latest/) explains how to set a user with `run_as`.

The file below uses `run_as` to modify the default  _/etc/shiny-server/shiny-server.conf_ file that ships with Shiny Server. `run_as`defines a global user, `shiny`, for the server. It then defines a different user for the `/finance` location, `shinyFinance`. The finance department can deploy apps in this location. Those apps will be restricted to the packages in the library of `shinyFinance`, which may be different than the packages in the library of the user named`shiny`.

{% highlight R %}
# Specify the authentication method to be used.
# Initially, a flat-file database stored at the path below.
auth_passwd_file /etc/shiny-server/passwd;

# Define a server that listens on port 3838
server {
  listen 3838;

  # Define a location at the base URL
  location / {
    # Instruct Shiny Server to run applications as
    # the user "shiny" by default
    run_as shiny;

    # Only up tp 20 connections per Shiny process and 
    # at most 3 Shiny processes per application. 
    # Proactively spawn a new process when our processes 
    # reach 90% capacity.
    utilization_scheduler 20 .9 3;

    # Host the directory of Shiny apps stored in this directory
    site_dir /srv/shiny-server;

    # Log all Shiny output to files in this directory
    log_dir /var/log/shiny-server;

    # When a user visits the base URL rather than a particular application,
    # an index of the applications available in this directory will be shown.
    directory_index on;
    
    location /finance {
      # Run as a different user for this location
      run_as shinyFinance;
    }
  }
}

# Provide the admin interface on port 4151
admin 4151 {
  
  # Restrict the admin interface to the usernames listed here. Currently
  # just one user named "admin"
  required_user admin;
}
{% endhighlight %}