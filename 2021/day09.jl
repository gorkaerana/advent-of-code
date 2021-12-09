using Pipe: @pipe

heightmap = @pipe joinpath(@__DIR__, "input", "day09.txt") |>
    readlines(_) |>
    split.(_, "") |>
    map(l->parse.(Int, l), _) |>
    hcat(_...) |>
    transpose(_)

function adjacent_indexes(array, row, col)
    n_rows, n_cols = size(array)
    adjacents = []
    # Up and down
    for i in row-1:2:row+1
        if 0 < i <= n_rows
            push!(adjacents, (i, col))
        end
    end
    # Right and left
    for j in col-1:2:col+1
        if 0 < j <= n_cols
            push!(adjacents, (row, j))
        end
    end
    return adjacents
end

adjacent_values(array, row, col) = @pipe array |>
    map(index->getindex(_, index...), adjacent_indexes(_, row, col))

function lowest_point_indexes(array)
    lowest_points = []
    for row in 1:size(heightmap, 1)
        for col in 1:size(heightmap, 2)
            current_height = heightmap[row, col]
            if current_height < minimum(adjacent_values(heightmap, row, col))
                push!(lowest_points, (row, col))
            end
        end
    end
    lowest_points
end

lowest_points(array) = @pipe array |>
    map(index->getindex(_, index...), lowest_point_indexes(_))

risk_levels(array) = lowest_points(array) .+ 1

function basin_indexes(array, i, j; aggregator)
    if array[i, j] == 9
        return aggregator
    end
    for (row, col) in reduce(vcat, ([(i, j)], adjacent_indexes(array, i, j)))
        if !((row, col) in aggregator)
            if array[row, col] != 9
                push!(aggregator, (row, col))
            end
            basin_indexes(array, row, col; aggregator=aggregator)
        end
    end
    return aggregator
end

function basins(array)
    basins = []
    for (row, col) in lowest_point_indexes(array)
        push!(basins, basin_indexes(array, row, col; aggregator=[]))
    end
    basins
end

# Part 1
@show sum(risk_levels(heightmap))

# Part 2
@show *(sort(length.(basins(heightmap)))[end-2:end]...)
