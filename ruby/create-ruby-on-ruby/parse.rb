require "minruby"

tree = minruby_parse("1 + 2 * 4")
pp(tree)

pp(minruby_parse("(1 + 2) / 3 * 4 * (56 / 7 + 8 + 9)"))


p("====")

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
        end
    end
end

p(evaluate(tree))
p(evaluate(minruby_parse("(1 + 2) / 3 * 4 * (56 / 7 + 8 + 9)")))
