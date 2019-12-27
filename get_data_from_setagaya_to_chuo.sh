#!/bin/zsh

ruby scrape_and_output.rb input/setagaya_data.txt > output/setagaya_output.txt
ruby scrape_and_output.rb input/suginami_data.txt > output/suginami_output.txt
ruby scrape_and_output.rb input/minato_data.txt > output/minato_output.txt
ruby scrape_and_output.rb input/meguro_data.txt > output/meguro_output.txt
ruby scrape_and_output.rb input/chuo_data.txt > output/chuo_output.txt