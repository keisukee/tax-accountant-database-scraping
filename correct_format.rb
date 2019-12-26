require 'spreadsheet'

original_data = []
count = 0
File.open("hoge.txt", "r") do |f|
  f.each_line do |line|
    if count % 22 == 0 && line
      original_data << []
    end
    if line.include?("スクレイピングできません")
      original_data[original_data.length - 1] << line.gsub(/\n/, "")
      count = 0
      next
    else
      original_data[original_data.length - 1] << line.gsub(/\n/, "")
      count += 1
    end
  end
end

# p original_data
# original_data.each do |each_data|
#   puts each_data.length
# end


# 新規作成
book = Spreadsheet::Workbook.new
# いろいろな方法でデータを入れられる
# 計算式は入力できない
sheet = book.create_worksheet(name: "1")

sheet.row(0).concat  %w{検索地域 登録番号 氏名 氏名（カナ） 登録年月日 事務所の名称 事務所の所在地 事務所電話番号 所属会 報酬のある公職による業務停止 懲戒処分 研修受講義務の履行等に関する情報（年度） 受講義務時間 受講実績時間 達成率 年度中途登録による按分月数（時間） 免除申請による免除月数（時間） 性別 生年月日 事務所FAX 事務所メールアドレス 事務所ホームページアドレス}


original_data.each_with_index do |data_row, i|
  data_row.each_with_index do |single_data, j|
    sheet[i + 1, j] = single_data
  end
end

book.write('test.xls')

# カラム 22個
# 検索地域
# 登録番号
# 氏名
# 氏名（カナ）
# 登録年月日
# 事務所の名称
# 事務所の所在地
# 事務所電話番号
# 所属会
# 報酬のある公職による業務停止
# 懲戒処分
# 研修受講義務の履行等に関する情報（年度）
# 受講義務時間
# 受講実績時間
# 達成率
# 年度中途登録による按分月数（時間）
# 免除申請による免除月数（時間）
# 性別
# 生年月日
# 事務所FAX
# 事務所メールアドレス
# 事務所ホームページアドレス