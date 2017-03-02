
# Mustard
Ruby on Rails based multi-environment test results server.  Mustard collects test results from closely related tests (IE Cross Browser or Mobile Testing on Multiple Device) and groups them for easy analysis.  The Mustard-Dijon is the front-end GUI and requires [Mustard-Seed](https://github.com/Orasi/Mustard-Seed) for storing test results.

# Orasi Software Inc
Orasi is a software and professional services company focused on software quality testing and management.  As an organization, we are dedicated to best-in-class QA tools, practices and processes. We are agile and drive continuous improvement with our customers and within our own business.


# Setup Mustard-Dijon
### Connecting to Mustard-Seed
In order to establish a connection with mustard-seed, the environment variable MUSTARD_URL must be set for the mustard-seed address.*Google can quickly assist you in adding an environment variable for your OS.*
 
 **Mac OS X example:**      

Open the terminal and enter ```sudo nano .bash_profile``` and then add the following line.       

```export MUSTARD_URL="http://ip_address:port_number"```         

An alternative to this approach is to edit the config/application.rb file within the mustard-dijon project.     

Replace: ```config.mustard_api = ENV['MUSTARD_URL']```    
with ```config.mustard_api = 'http://ip_address:port_number'```

# License
Licensed under [BSD License](/License)
