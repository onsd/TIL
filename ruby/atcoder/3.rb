def hello(name)
    return "Hello, #{name}"
end

%w[Ruby Python Java].each do |value|
    if value != "Java" 
        puts hello value
        # puts "Hello, #{value}"
    end
    unless value == "Ruby"
        puts hello value
    end
end

[true, false].each { |value| puts "x is true" if value }
