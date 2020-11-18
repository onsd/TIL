ARGV.each do |arg|
    File.open(arg) do |file|
        file.each do |line|
            puts line
        end
    end
end