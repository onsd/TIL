require "minruby"
def evaluate(tree)
    if tree[0] == "lit"
        tree[1]
    else
        left = evaluate(tree[1])
        right = evaluate(tree[2])
        case tree[0]
        when "+"
            left + right
        when "-"
            left - right
        when "*"
            left * right
        when "/"
            left / right
        when "%"
            left % right
        when "**"
            left ** right
        when "<"
            left < right
        when ">"
            left > right
        when "=="
            left == right
        end
    end
end

def max(tree)
    if tree[0] == "lit"
        tree[1]
    else
        left = max(tree[1])
        right = max(tree[2])
        left < right ? right : left
    end
end    
str = gets
tree = minruby_parse(str)
answer = max(tree)
p(answer)