# 葉
leaf_a = ["葉A"]
leaf_b = ["葉B"]
leaf_c = ["葉C"]
leaf_d = ["葉D"]

# 節
node2 = ["節2", leaf_a, leaf_b]
node3 = ["節3", leaf_c, leaf_d]

# 木
node1 = ["節1", node2, node3]


def preorder(tree)
    p(tree[0])
    if tree[0].start_with?("節")
        preorder(tree[1])
        preorder(tree[2])
    end
end

preorder(node1)