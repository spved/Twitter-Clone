# Twitter-Clone
Twitter Clone Elixir Project

1 Problem definition
  The goal of this (and the next project) is to implement a Twitter-like engine and (in part 2) pair up with Web Sockets to provide full functionality.
  Specific things you have to do are:
  In part I, implement the following functionalities:
  1. Registeraccountanddeleteaccount
  2. Send tweet. Tweets can have hashtags (e.g. #COP5615isgreat) and mentions
  (@bestuser). You can use predefines categories of messages for hashtags.
  3. Subscribetouser'stweets.
  4. Re-tweets (so that your subscribers get an interesting tweet you got by other
  means).
  5. Allow querying tweets subscribed to, tweets with specific hashtags, tweets in
  which the user is mentioned (my mentions).
  6. Iftheuserisconnected,delivertheabovetypesoftweetslive(withoutquerying).
  Other considerations:
  The client part (send/receive tweets) and the engine (distribute tweets) have to be in separate processes. Preferably, you use multiple independent client processes that simulate thousands of clients and a single-engine process.
 
  1. Youneedtomeasurevariousaspectsofyoursimulatorandreportperformance.
  2. Write test cases using the elixir’s built-in ExUnit test framework verifying the correctness for each task. Specifically, you need to write unit tests and functional tests (simple scenarios in which a tweet is sent, the user is mentioned or re-
  tweets). Write 2-3 tests for each functionality.
  When you submit the project, make sure you include a README that explains what functionality is implemented, how to run the tests, etc. You need to submit a report with performance analysis.

2 Requirements
  Input: The input provided (as command line to your program will be of the form: mix run proj4 num_user num_msg
  Where num_user is the number of actors you have to create and num_msg is the number of tweets a user has to make.
  We can check for project using test cases that you will make. You don’t have to print certain output. You can print whatever you want.
  Make sure your test cases run using mix test.
  Actor modeling: In this project you have to use exclusively the actor facility (GenServer) in Elixir (projects that do not use multiple actors or use any other form of parallelism will receive no credit).

3 BONUS
  For bonus-
  You can also implement some extra functionalities that you want to implement.
  Write a Report-bonus.pdf to explain your functionalities and submit project4- bonus.zip with your code.
  For Project 4.2, implement a web interface using phoenix and capture various metrics and send them via Phoenix to the browser.
  More Project 4.2 details will be posted soon.
  1. Simulateperiodsofliveconnectionanddisconnectionforusers.
  2. SimulateaZipfdistributiononthenumberofsubscribers.Foraccountswithalot of subscribers, increase the number of tweets. Make some of these messages’ re-tweets.
