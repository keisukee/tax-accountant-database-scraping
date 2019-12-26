require "selenium-webdriver"

def url
  "https://www.zeirishikensaku.jp/z_top2.asp"
end

def move_to_next_page(driver, original_window, new_window)
  # ここからページネーションを調べてnextにいく処理
  driver.switch_to.window(original_window)

  page_elements = driver.find_elements(class: "PAGE")
  pagenation = page_elements[1]

  pagenation_links = pagenation.find_elements(tag_name: "a")
  if pagenation_links[pagenation_links.length - 1]
    pagenation_links[pagenation_links.length - 1].click
  else
    driver.close
    return
  end

  driver.switch_to.window(new_window)
end

def calc_pagenation_count(driver, original_window)
  driver.switch_to.window(original_window)
  
  page_elements = driver.find_elements(class: "PAGE")
  search_count_result = page_elements[2].find_element(tag_name: "font") # 件数 22件など
  count = search_count_result.text.to_i # 例えばcount = 22だったらページ遷移は2回, count = 1 ~ 10だったらページ遷移は0回
  trial_times = 0
  
  # ex) 検索結果 = count = 9件だったら、ページ遷移は0回。22件だったら、ページ遷移は2回
  while count > 10
    count -= 10
    trial_times += 1
  end
  
  trial_times
end

def scrape(location)
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_argument('-headless')
  driver = Selenium::WebDriver.for :firefox, options: options
  driver.get url
  sleep 1
  atags = driver.find_elements(tag_name: "a")
  a = atags[5]
  driver.execute_script("arguments[0].click();", a)
  sleep 2
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
  input_buttons[1].send_keys(location)
  sleep 1
  
  # 検索ボタンをクリック
  a_buttons = driver.find_elements(tag_name: "a")
  a_buttons[2].click
  
  # 検索結果が100件以上を越える場合、もしくは0件の場合、アラートが出る
  begin
    if dialog = driver.switch_to.alert
      puts location
      if dialog.text.include?('100件を超えています')
        puts "検索結果が100件を超えたのでスクレイピングできません"
      elsif dialog.text.include?('該当するデータはありません')
        puts "検索結果が0件でした。スクレイピングできません"
      end
      dialog.accept
      driver.close
      return
    end
  rescue => e
  end

  current_window = driver.window_handles.last

  # ページ遷移する回数 + 1ページ目の数だけ処理をループさせる
  trial_times = calc_pagenation_count(driver, current_window) + 1
  trial_times.times do |i|

    driver.switch_to.window(current_window)
    # 税理士の情報がテーブル要素に記述されているので、tag_name: "tr"でまとめて取得
    search_result_of_accountants_list = driver.find_elements(tag_name: "tr")
    # tax_accountant_table_data_listの最初の3つはテーブル外の要素なので除外
    search_result_of_accountants_list.delete(search_result_of_accountants_list[0])
    search_result_of_accountants_list.delete(search_result_of_accountants_list[0])
    search_result_of_accountants_list.delete(search_result_of_accountants_list[0])
  
    search_result_of_accountants_list.each do |tr|
      each_accountant_data_table = tr.find_elements(tag_name: "td")
      each_accountant_data_table_length = each_accountant_data_table.length
  
      # tr > td, td, ...となっているが、このtdの最後の要素が個別の税理士ページへのリンクになるので、そこだけ取得する
      show_link = each_accountant_data_table[each_accountant_data_table_length - 1].find_element(tag_name: "a")
      # 個別の税理士の詳細ページに遷移
      show_link.click
      sleep 2
      # リンクをクリックするとアラートが出るので処理
      dialog = driver.switch_to.alert
      if dialog.text == '利用条件に同意しますか？'
        dialog.accept
      else
        dialog.dismiss
      end

      sleep 2
      # 税理士の詳細ページにdriverのフォーカスを切り替えるため
      new_window = driver.window_handles.last
      driver.switch_to.window(new_window)
      sleep 1

      accountant_data_tables = driver.find_elements(tag_name: "tbody")
      # はじめに検索地域名を表示する
      puts location
      # 必要なデータは基本情報のテーブルと、メールアドレス名などの連絡先のデータのテーブルのみ
      2.times.each do |i|
        personal_info_trs = accountant_data_tables[i].find_elements(tag_name: "tr")
        personal_info_trs.delete(personal_info_trs[0])
        personal_info_trs.each do |tr|
          # 各trにtdが2つ以上ある
          tds = tr.find_elements(tag_name: "td")
          # 1番目はカラムのタイトルなので削除
          tds.delete(tds[0])

          if tds[0].text.length.zero?
            puts "xxx"
          else
            puts tds[0].text
          end
        end
      end
      driver.switch_to.window(current_window)
    end

    sleep 1
    move_to_next_page(driver, current_window, new_window)
    # driver.switch_to.window(current_window)
  end
  driver.quit
end


input_file_name = ARGV[0]

locations = []
count = 0
File.open(input_file_name, "r") do |f|
  f.each_line do |line|
    locations << line
  end
end

locations.each do |location|
  scrape(location)
end