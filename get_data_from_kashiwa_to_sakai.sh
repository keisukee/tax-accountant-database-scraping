#!/bin/zsh

ruby scrape_and_output.rb input/kashiwa_data.txt > output/kashiwa_output.txt
ruby scrape_and_output.rb input/matsudo_data.txt > output/matsudo_output.txt
ruby scrape_and_output.rb input/osaka_data.txt > output/osaka_output.txt
ruby scrape_and_output.rb input/maikata_data.txt > output/maikata_output.txt
ruby scrape_and_output.rb input/sakai_data.txt > output/sakai_output.txt


