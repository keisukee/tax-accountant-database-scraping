#!/bin/zsh

ruby scrape_and_output.rb input/nakano_data.txt > output/nakano_output.txt
ruby scrape_and_output.rb input/edogawa_data.txt > output/edogawa_output.txt
ruby scrape_and_output.rb input/adachi_data.txt > output/adachi_output.txt
ruby scrape_and_output.rb input/itabashi_data.txt > output/itabashi_output.txt
ruby scrape_and_output.rb input/katsushika_data.txt > output/katsushika_output.txt