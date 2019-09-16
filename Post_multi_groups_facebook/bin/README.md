Objective: Interact with facebook
 - Perl Web Client to Interact with Dynamic Web Pages
 - Perl Client for the Selenium Remote Control test tool

technologic:
 - Perl

Dependencies 
 - (cpanm) www::mechanize - Optional - (only to interact with html forms)
  -(cpanm) Selenium::Remote::Driver-> https://metacpan.org/pod/Selenium::Remote::Driver
 - (install) chromedriver -> https://sites.google.com/a/chromium.org/chromedriver/downloads
 - (install) Selenium Standalone server -> https://www.seleniumhq.org/download/

To run
 - to start server with user interface ->java -Dwebdriver.chrome.driver=/usr/bin/chromedriver -jar /server/selenium-server-standalone-3.13.0.jar
 - or to start server with headless -> xvfb-run java -Dwebdriver.chrome.driver=/usr/bin/chromedriver -jar /server/selenium-server-standalone-3.13.0.jar
 - Go do Browser -> http://127.0.0.1:4444/wd/hub/static/resource/hub.html

future
 - Docker images for Selenium Standalone Server Hub and Node configurations with Chrome and Firefox -> https://github.com/SeleniumHQ/docker-selenium

Notes:
 - Facebook page code is all generated client-side. Scraping this without a JS engine is going to be hard.