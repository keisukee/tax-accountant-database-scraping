require "selenium-webdriver"

driver = Selenium::WebDriver.for :firefox
def url
  "https://www.zeirishikensaku.jp/z_top2.asp"
end

def move_to_next_page(driver, original_window, new_window)
  # ここからページネーションを調べてnextにいく処理
  driver.switch_to.window(original_window)

  page_elements = driver.find_elements(class: "PAGE")
  pagenation = page_elements[1]

  pagenation_links = pagenation.find_elements(tag_name: "a")
  pagenation_links[pagenation_links.length - 1].click

  driver.switch_to.window(new_window)
  sleep 3
end

def calc_pagenation_count(driver, original_window)
  driver.switch_to.window(original_window)

  page_elements = driver.find_elements(class: "PAGE")
  search_count_result = page_elements[2].find_element(tag_name: "font") # 件数 22件など
  count = search_count_result.text.to_i # 例えばcount = 22だったらページ遷移は2回, count = 1 ~ 10だったらページ遷移は0回
  trial_times = 0

  while count > 10
    count -= 10
    trial_times += 1
  end

  trial_times
end

driver.get url

driver.manage.timeouts.implicit_wait = 5

sleep 1

atags = driver.find_elements(tag_name: "a")
a = atags[5]
driver.execute_script("arguments[0].click();", a)
sleep 1
driver.execute_script("javascript:onclick=jf_SearchClick(1);")
sleep 1
trs = driver.find_elements(tag_name: "tr")

new_window = driver.window_handles.last
driver.close
# 取得した新規ウィンドウのハンドルに移動
driver.switch_to.window(new_window)
sleep 1

trs = driver.find_elements(tag_name: "tr")

input_buttons = driver.find_elements(tag_name: "input")
input_buttons[4].click # 事務所所在地のラジオボタンをクリック
sleep 1
# input_buttons[1].send_keys("山梨県北杜市") # 1ページのみ
input_buttons[1].send_keys("下北沢") # 2ページ
# input_buttons[1].send_keys("恵比寿南") # 3ページ
sleep 1

# 検索ボタンをクリック
a_buttons = driver.find_elements(tag_name: "a")
a_buttons[2].click

current_window = driver.window_handles.last

trial_times = calc_pagenation_count(driver, current_window) + 1

trial_times.times do |i|

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
    sleep 1
    goal_tds = driver.find_elements(tag_name: "td")
    goal_tds.each do |td|
      puts td.text
    end

    driver.switch_to.window(current_window)
  end

  sleep 1
  move_to_next_page(driver, current_window, new_window)
  driver.switch_to.window(current_window)
end

driver.quit