# 葉
leaf_a = ["葉A"]
leaf_b = ["葉B"]
leaf_c = ["葉C"]
leaf_d = ["葉D"]

# 節
node3 = ["節3", leaf_b, leaf_d]
node2 = ["節2", leaf_a, node3]
node1 = ["節1", node2, leaf_d]


def preorder(tree)
    p(tree[0])
    if tree[0].start_with?("節")
        preorder(tree[1])
        preorder(tree[2])
    end
end

def preorder_only_leaf(tree)
    if tree[1].nil?
        p(tree[0])
    end
    if tree[0].start_with?("節")
        preorder_only_leaf(tree[1])
        preorder_only_leaf(tree[2])
    end
end

def postorder(tree)
    if tree[0].start_with?("節")
        postorder(tree[1])
        postorder(tree[2])
    end
    p(tree[0])
end

preorder(node1)
p("====")

preorder_only_leaf(node1)
p("====")

postorder(node1)
p("====")

# 節
node2 = ["節2", leaf_a, leaf_b]
node3 = ["節3", leaf_c, leaf_d]

# 木
node1 = ["節1", node2, node3]
postorder(node1)
