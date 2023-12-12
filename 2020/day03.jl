struct ModIterator
    start::Integer
    step::Integer
    max::Integer
end

function Base.iterate(m::ModIterator, state=m.start)
    next = state + m.step
    (next > m.max) ? (state, next - m.max) : (state, next)
end

function count_trees(map::Vector{Vector{Char}}, slope::Vector{Int64})
    nrows, ncols = length(map), length(map[1])
    row_step, col_step = slope
    columns = ModIterator(1, col_step, ncols)
    sum(map[row][col] == '#' for (row, col) = zip(1:row_step:nrows, columns))
end

map_ = collect.(readlines("input/day03.txt"))
# Part 1
number_hit_trees = count_trees(map_, [1, 3])
println("Part 1: $number_hit_trees")
# Part 2
product_of_tree_counts = prod(map(s -> count_trees(map_, s), [[1, 1], [1, 3], [1, 5], [1, 7], [2, 1]]))
println("Part 2: $product_of_tree_counts")
