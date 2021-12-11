using Pipe: @pipe

octopus_grid = @pipe joinpath(@__DIR__, "input", "day11_small.txt") |>
    readlines(_) |>
    split.(_, "") |>
    map(l->parse.(Int, l), _) |>
    hcat(_...) |>
    transpose(_)

function adjacent_positions(row, col, grid)
    n_rows, n_cols = size(grid)
    mask = zeros(Int, n_rows, n_cols)
    for i in row-1:row+1
        for j in col-1:col+1
            if 0 < i <= n_rows && 0 < j <= n_cols
                mask[i, j] += 1
            end
        end
    end
    return mask
end

function energy_level_update(grid, mask)
    n_rows, n_cols = size(grid)
    # Consolidate all energy level updates around each flashing octopus
    energy_level_updates = []
    for row = 1:n_rows, col = 1:n_cols
        if getindex(mask, row, col) != 0
            push!(energy_level_updates, adjacent_positions(row, col, grid))
        end
    end
    cat(energy_level_updates...; dims=3)
    # sum(cat(energy_level_updates..., dims=3), dims=3)
end

function step(grid)
    n_rows, n_cols = size(grid)
    # Step 1
    new_grid = grid .+ 1
    # Step 2
    flash_mask = new_grid .> 9
    if any(flash_mask)
        new_grid .+= energy_level_update(grid, flash_mask)
        new_flash_mask = new_grid .> 9
    end
    # Step 3
    # new_grid[new_grid .> 9] .= 0
    return new_grid
end

display(octopus_grid)
println("")
octopus_grid = step(octopus_grid)

display(octopus_grid)
println("")
octopus_grid = step(octopus_grid)

display(octopus_grid)
println("")
