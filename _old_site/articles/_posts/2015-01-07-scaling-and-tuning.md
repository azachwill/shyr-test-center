---
layout: post
title: Scaling and Performance Tuning with shinyapps.io 
edited: 2015-01-07
description: As your applications get more complex, requiring more time to service a single request, and as more users interact with the application simultaneously, you may find that the user experience for your applications does not meet your expectations. Shinyapps.io lets you optimize the performance of your apps with several tuning parameters.
---

R is a single threaded application which means that a Shiny application cannot serve two different users at _precisely_ the same time. This is not an issue in _most_ cases because most computations only take tens or hundreds of milliseconds. As a result, a single R process can usually serve 5 to 30 requests/second. However, as your applications get more complex, requiring more time to service a single request, and as more users interact with the application simultaneously, you may find that the user experience for your applications does not meet your expectations.

## Fine-Tuning Your Shiny apps Performance

Shinyapps.io lets you optimize the performance of your apps with several tuning parameters. To see your current settings go to the Settings page for any application. The default settings have been chosen to address the needs of most applications.

## Key concepts and terms
There are several ideas that are important when considering the various tuning options that are available.

* Application
* Application Instance
* Worker
* Browser Connection

The diagram below shows how these ideas relate to each other.

![architecture](/images/scaling-and-tuning1.png)

### Application

An application is a combination of files that you upload to shinyapps.io. These files must include a ui.R file and a server.R file, and can also include data files.

A running application will have at least one Application Instance. You can add additional instances if the application is hosted on a paid tier.

### Application Instance

An Application Instance is a single server that responds to requests from end users. Shinyapps.io will start at least one Application Instance when a user first visits your application, and shinyapps.io will shut down this instance (or these instances) when the application is idle.

Each Application Instance will run one or more R Workers to fulfill user requests.

### Worker

A worker is a special type of R process that an Application Instance runs to service requests to an application. Each Application Instance can run multiple workers. Each worker process is capable of servicing multiple end users depending on the configuration and performance requirements of the application. If there are no processes available to handle a new request, the Application Instance will start a new worker process.

### Browser Connection

A browser connection is a connection between a user’s web browser and a worker serving your application.

A user creates a browser connection when they first send a request to your application through their web browser, or when they refresh their browser after it has gone idle. Shinyapps.io assigns each new browser connection to a worker. The worker responds by creating a session for the browser connection to use.

## Tuning parameters 

The architecture described above uses two load factors to fine tune the performance of your applications.

* **Worker Load Factor** - The threshold percentage after which a new browser connection will trigger the addition of a new worker.

* **Instance Load Factor** - The threshold percentage after which a new connection will trigger the addition of a new Application Instance (limited to the maximum instance limit, free tier is 1)

Each load factor is based on the idea of a threshold percentage, which is the percentage of available connections or processes that are allowed to open before shinyapps.io launches another worker or Application Instance. Both settings are configurable in the Advanced tab within the Settings page for a given application.

You can also use the Settings page to change:

* the size of your Application Instances
* the maximum number of workers per Application Instance
* the maximum number of connections per worker
* the amount of time at which an instance or connection goes idle.

Each of these changes will further fine tune the performance of your application.

## Lifecycle of an Application

The diagram below shows how shinyapps.io handles user requests throughout the life cycle of an application.

![architecture](/images/scaling-and-tuning2.png)

1. Publisher creates a new application and deploys it to shinyapps.io at [https://.shinyapps.io/](https://.shinyapps.io/)
2. A request from an end user triggers the start of an Application Instance
3. Application Instance will start with at least one worker
4. The number of connections to the worker increases as additional end users visit the application. When the Worker Load Factor threshold is exceeded, shinyapps.io adds another worker, so long as the max number of workers per Application Instance has not been reached. New connections are now assigned to the new worker.
5. New workers are added when needed as new users continue to visit the application. When the Instance Load factor is exceeded, shinyapps.io will trigger the addition of another Application Instance, so long as the max number of Application Instances has not been reached (the max number may be one).  
6. Shinyapps.io closes connections as end users close their browsers or are idle for longer than the Idle Timeout.
7. Shinyapps.io shuts down each worker once it has no further connections open.  
8. Shinyapps.io turns off each Application Instance once it has no running workers, or once its workers are idle for longer than the Instance Idle Timeout. This threshold timeout should be increased if you would like to avoid restarting the application. Note: Increasing the timeout will use up more active hours.
9. A new request from an end user causes shinyapps.io to turn on an Application Instance, and stages 2-9 repeat.

## Examples:

Assuming the following settings:

Instance Load Factor (default is 50%)  
Worker Load Factor (default is 5%)  
Max worker processes (default is 3)  
Max # of concurrent connections supported per worker (default is 50)

Determining when another worker would be started:

Max # of Concurrent connections per worker * Worker Load Factor  
50 * 5% = 2.5 (meaning the 3rd Browser Connection would add another worker up to the Max worker processes)  

Determining when another Application Instance would be started:

Max # of connections per worker * Max worker processes * Instance Load Factor  
50 * 3 * 50% = 75 (meaning the 76th connection would cause an additional instance to be started)

## Troubleshooting

When should you worry about tuning your applications? You should consider tuning your applications if:

1. Your application has several requests that are slow and you have enough concurrent usage that people’s expectations for responsiveness aren’t being met. For example, If your response time for some key calculations takes one second and you would like to make sure that the average response time for your application is less than two seconds, you will not want more than two concurrent requests per worker.

    + **Possible Diagnosis**: The application performance might be due to R’s single threaded nature. Spreading the load across additional workers should alleviate the issue.  
    + **Remedy**: Consider lowering the maximum number of connections per worker, and possibly increasing the maximum number of workers. Also consider adding additional Application Instances and aggressively scaling them by tweaking the Instance Load Factor to a lower percentage.

2. Sudden large spikes of traffic have poor performance even though you have configured multiple Application Instances. However, additional new users have good performance.

    + **Possible Diagnosis**: The number of workers within the first container are insufficient for the initial spike of traffic. When the additional containers are started, new users are routed to the new Application Instance.  
    + **Remedy**: Decrease the Instance Load Factor which will aggressively start up additional Application Instances and spread the load.

3. Your application suddenly goes grey and you see in your logs that the application was “killed”.

    + **Possible Diagnosis**: Each Application Instance has a size which corresponds to the amount of RAM (memory) that is allocated to it. If the amount of memory allocated to this application is exceeded, then the Application Instance could be shut down by shinyapps.  
    + **Remedy**: There are two possible solutions:  

        + Increase the size of the Application Instance.  
        + Decrease the number of workers per Application Instance. Since each worker takes up additional RAM, you may find that lowering the “Max worker processes” to two or one would help keep each Application Instance’s memory usage down.  

4. An application isn't fitting in memory even for the largest Application Instance size

    + **Possible Diagnosis**: If the application loads correctly with one or two users interacting with it, then it is possible that your data set sizes on a per worker basis are too big.  
    + **Remedy**: Decrease the number of workers per Application Instance.  

5. Your application stops accepting additional users beyond 150 connections.

    + **Possible Diagnosis**: It is likely that you have reached the limit on the number of connections that can be served by the default settings in an Application Instance.  
    + **Remedy**: A few things to try would be:  

        + Increase the allowed connections per worker by changing Connections setting for the application.
        + Increase the number of workers per Application Instance.
        + Add additional Application Instances.

6. An application that has a significant initialization time (loading lots of data, or talking to 3rd party web services) sometimes doesn’t load.

    + **Possible diagnosis**: Shinyapps.io has an “Instance Startup Timeout” which will stop an application if it is not responsive within that period of time at startup.  
    + **Remedy**: Increase the timeout on the Application Settings page.  
