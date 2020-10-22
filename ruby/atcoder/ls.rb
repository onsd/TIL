children = Dir::entries(".").sort

children.each do |n|
    puts(n)
end

print Dir