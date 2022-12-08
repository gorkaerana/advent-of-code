using Pipe: @pipe

function parse_input_to_matrix(filename::AbstractString)::Matrix{Int64}
    @pipe filename |>
        readlines |>
        collect.(_) |>
        mapreduce(x -> parse.(Int64, x), hcat, _) |>
        transpose
end

function is_visible(forest::Matrix{Int64}, cartesian_index::CartesianIndex)::Bool
    nrow, ncol = size(forest)
    row, col = Tuple(cartesian_index)
    # Edge trees are always visible
    ((row == 1) || (col == 1) || (row == nrow) || (col == ncol)) && return true
    # "A tree is visible if all of the other trees between it and an edge of the grid are shorter than it"
    # "Only consider trees in the same row or column; that is, only look up, down, left, or right from any given tree"
    height = forest[row, col]
    is_shorter = e -> e < height
    # Up
    all(map(is_shorter, forest[row, begin:(col-1)])) && return true
    # Down
    all(map(is_shorter, forest[row, (col+1):end])) && return true
    # Left
    all(map(is_shorter, forest[begin:(row-1), col])) && return true
    # Right
    all(map(is_shorter, forest[(row+1):end, col])) && return true
    false
end

function filterwhile(f, iter)
    rv = []
    for e in iter
        push!(rv, e)
        (!f(e)) && break
    end
    rv
end

function scenic_score(forest::Matrix{Int64}, cartesian_index::CartesianIndex)::Int64
    nrow, ncol = size(forest)
    row, col = Tuple(cartesian_index)
    height = forest[row, col]
    is_shorter = e -> e < height
    # Up
    up_score = filterwhile(is_shorter, reverse(forest[row, begin:(col-1)]))
    # Down
    down_score = filterwhile(is_shorter, forest[row, (col+1):end])
    # Left
    left_score = filterwhile(is_shorter, reverse(forest[begin:(row-1), col]))
    # Right
    right_score = filterwhile(is_shorter, forest[(row+1):end, col])
    prod(length.([up_score, down_score, left_score, right_score]))
end

input_file = @pipe identity(@__FILE__) |>
    joinpath(dirname(_), "input", first(splitext(basename(_))) * ".txt")

forest = parse_input_to_matrix(input_file)
println("Part 1: ", sum(map(ci -> is_visible(forest, ci), CartesianIndices(forest))))
println("Part 2: ", maximum(map(ci -> scenic_score(forest, ci), CartesianIndices(forest))))
