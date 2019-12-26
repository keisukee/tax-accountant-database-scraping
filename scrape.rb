require "selenium-webdriver"
# require 'selenium-phantomjs'
# require 'capybara'
# require 'poltergeist'

driver = Selenium::WebDriver.for :firefox
def url
  "https://www.zeirishikensaku.jp/z_top2.asp"
  # "https://www.zeirishikensaku.jp/default.html"
  # "https://www.zeirishikensaku.jp/sch/zs_sch1.asp"
end

driver.get url
# driver.execute_script("alert()")
# javascript:onClick=jf_SerchClick();
# javascript:onclick=jf_SearchClick(1); 名前・所在地で検索したいとき: 検索ボタンを
# javascript:onclick=jf_SearchClick(1);

driver.manage.timeouts.implicit_wait = 5

# wait = Selenium::WebDriver::Wait.new(:timeout => 15)

# driver.switch_to.frame("naiyo")

# wait = Selenium::WebDriver::Wait.new(:timeout => 10)
# wait.until {driver.find_elements(tag_name: 'a').displayed?}
sleep 1

atags = driver.find_elements(tag_name: "a")
a = atags[5]
driver.execute_script("arguments[0].click();", a)
sleep 1
driver.execute_script("javascript:onclick=jf_SearchClick(1);")
sleep 1
trs = driver.find_elements(tag_name: "tr")
# trs.each do |tr|
#   puts tr.text
# end

new_window = driver.window_handles.last
driver.close
# 取得した新規ウィンドウのハンドルに移動
driver.switch_to.window(new_window)
sleep 1

trs = driver.find_elements(tag_name: "tr")

# trs.each do |tr|
#   puts tr.text
# end
# puts atags.length
# atags[5].click
# sleep 50

input_buttons = driver.find_elements(tag_name: "input")
input_buttons[4].click # 事務所所在地のラジオボタンをクリック
sleep 1
input_buttons[1].send_keys("山梨県北杜市")
sleep 1

# 検索ボタンをクリック
a_buttons = driver.find_elements(tag_name: "a")
a_buttons[2].click
# driver.execute_script("javascript:onClick=jf_SerchClick();")

current_window = driver.window_handles.last
driver.switch_to.window(current_window)

trs = driver.find_elements(tag_name: "tr")
# trの最初の3つはテーブル外の要素なので除外
trs.delete(trs[0])
trs.delete(trs[0])
trs.delete(trs[0])

trs.each do |tr|
  tds = tr.find_elements(tag_name: "td")
  tds_length = tds.length
  show_link = tds[tds_length - 1].find_element(tag_name: "a")
  show_link.click

  sleep 1
  dialog = driver.switch_to.alert
  if dialog.text == '利用条件に同意しますか？'
    dialog.accept
  else
    dialog.dismiss
  end
  driver.switch_to.window(current_window)
  new_window = driver.window_handles.last
  driver.switch_to.window(new_window)
  sleep 5
  goal_tds = driver.find_elements(tag_name: "td")
  goal_tds.each do |td|
    puts td.text
  end
  # sleep 3
  # driver.close
  driver.switch_to.window(current_window)
  # tds.each do |td|
  #   puts td.text
  # end
end

sleep 1

driver.quit