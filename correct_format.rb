require 'spreadsheet'

original_data = []
count = 0
File.open("yokohama_data.txt", "r") do |f|
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

# 新規作成
book = Spreadsheet::Workbook.new
# いろいろな方法でデータを入れられる
# 計算式は入力できない
sheet = book.create_worksheet(name: "1")

sheet.row(0).concat  %w{検索地域 登録番号 氏名 氏名（カナ） 登録年月日 事務所の名称 事務所の所在地 事務所電話番号 所属会 報酬のある公職による業務停止 懲戒処分 研修受講義務の履行等に関する情報（年度） 受講義務時間 受講実績時間 達成率 年度中途登録による按分月数（時間） 免除申請による免除月数（時間） 性別 生年月日 事務所FAX 事務所メールアドレス 事務所ホームページアドレス}

# 事務所の重複を省く
# 税理士の名前（上の名前or下の名前）が税理士事務所に含まれる
# 同じ事務所内で出てくる人は一人（代表）
# 判定漏れで省かれてしまう事務所は仕方ない

l = original_data.length

index_to_show = []

l.times do |i|
  if original_data[i][1].include?("スクレイピングできません")
    index_to_show << i
    next
  else
    office_name = original_data[i][5] # 6番目が事務所の名前
    person_name = original_data[i][2].split("　")
    p person_name

    if office_name.include?(person_name[0]) || office_name.include?(person_name[1])
      puts "#{office_name}は#{person_name[0]}と#{person_name[1]}をふくみます"
      index_to_show << i
      # puts "#{original_data[i][5]}は#{office_name}の代表者です"
    else
      puts "duplicate: #{office_name}は#{person_name[0]}と#{person_name[1]}をふくみます"
    end
  end
end

p index_to_show
p index_to_show.length
index_to_show.each_with_index do |value, index|
  original_data[value].each_with_index do |single_data, j|
    sheet[index + 1, j] = single_data
  end
end

# original_data.each_with_index do |data_row, i|
#   data_row.each_with_index do |single_data, j|
#     sheet[i + 1, j] = single_data
#   end
# end

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