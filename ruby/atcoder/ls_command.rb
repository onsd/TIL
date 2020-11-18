children = Dir::children('.').sort

# 文字数の最大値を算出。
string_length_max = children.map{ |child| child.length }.max

# ターミナルの幅 を 文字数の最大値+1 で割ることで、見やすく整形する準備を行う。
column = ('tput cols').to_i / (string_length_max + 1)

# 実表示部分。
children.each_slice(column) do |items|
  puts items.map{ |item| "%-#{string_length_max}s " % item }.join
end

