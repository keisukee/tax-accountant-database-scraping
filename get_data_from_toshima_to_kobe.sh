#!/bin/zsh

ruby scrape_and_output.rb input/toshima_data.txt > output/toshima_output.txt
ruby scrape_and_output.rb input/machida_data.txt > output/machida_output.txt
ruby scrape_and_output.rb input/sumida_data.txt > output/sumida_output.txt
ruby scrape_and_output.rb input/chiyoda_data.txt > output/chiyoda_output.txt
ruby scrape_and_output.rb input/kita_data.txt > output/kita_output.txt
ruby scrape_and_output.rb input/kobe_data.txt > output/kobe_output.txt