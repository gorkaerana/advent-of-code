Grid = Matrix{Char}

function get_grid(filename::String)::Grid
    permutedims(reduce(hcat, collect.(readlines(filename))), (2, 1))
end

function neighbouring_indices(cartesian_index::CartesianIndex, height::Int64, width::Int64)::Vector{CartesianIndex}
    x, y = Tuple(cartesian_index)
    indices::Vector{CartesianIndex} = []
    # Top
    (x > 1) && push!(indices, CartesianIndex(x - 1, y))
    # Right
    (y < width) && push!(indices, CartesianIndex(x, y + 1))
    # Bottom
    (x < height) && push!(indices, CartesianIndex(x + 1, y))
    # Left
    (y > 1) && push!(indices, CartesianIndex(x, y - 1))
    indices
end

function update_grid(grid::Grid)::Grid
    new_grid::Grid = deepcopy(grid)
    for (index, value) in pairs(IndexCartesian(), grid)
        n_neighbouring_bugs = count(.==('#'), map(ci -> grid[ci], neighbouring_indices(index, size(grid)...)))
        # Bug dies
        (value == '#') && (n_neighbouring_bugs != 1) && (new_grid[index] = '.')
        # Empty tile gets infested
        (value == '.') && (1 <= n_neighbouring_bugs <= 2) && (new_grid[index] = '#')
    end
    new_grid
end

function Base.display(grid::Grid)
    for i = 1:size(grid, 1)
        for j = 1:size(grid, 2)
            print(grid[i, j])
        end
        println()
    end
    println()
end


function biodiversity_rating(grid::Grid)# ::Int64
    flattened = reshape(permutedims(grid, (2, 1)), 1, :)
    only((flattened .== '#') * (2 .^ collect(0:(length(flattened) - 1))))
end

function evolve_until_repeated_layout(grid::Grid)
    grid_history::Array = grid
    for minute = Base.Iterators.countfrom()
        old_grid = grid
        (minute > 1) && (grid_history = cat(grid_history, old_grid, dims=3))
        grid = update_grid(old_grid)
        any(all(grid_history .== grid, dims=(1, 2))) && return grid
    end
end

grid = get_grid("./input/day24.txt")
repeated_layout = evolve_until_repeated_layout(grid)
rating = biodiversity_rating(repeated_layout)
println("Part 1: $rating")
