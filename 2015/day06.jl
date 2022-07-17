using Pipe: @pipe

include("../utils.jl")
using .Utils: read_input


coordinate_to_tuple(s) = @pipe s |> split(_, ",") |> parse.(Int128, _)

function parse_instruction(instruction_string)
    @pipe match(r"(turn on|toggle|turn off) (\d+,\d+) through (\d+,\d+)", instruction_string) |>
        (_[1], coordinate_to_tuple(_[2]), coordinate_to_tuple(_[3])) |>
        (_[1], reverse(_[2]), reverse(_[3])) |>  # Coordinates are given as (col, row)
        (_[1], _[2] .+ 1, _[3] .+ 1)  # Coordinates are zero-indexed, unlike Julia
end

function apply_instruction(grid, instruction_tuple, action_map)
    (action, top_left, bottom_right) = instruction_tuple
    (row_indexes, col_indexes) = (top_left[1]:bottom_right[1], top_left[2]:bottom_right[2])
    action_func = action_map[action]
    grid[row_indexes, col_indexes] .= action_func(grid[row_indexes, col_indexes])    
    return grid
end

function display_lights(grid_shape, action_map)
    let grid = zeros(Int128, grid_shape...)
        for instruction in parse_instruction.(read_input(@__FILE__))
            grid = apply_instruction(grid, instruction, action_map)
        end
        return grid
    end
end

@pipe Dict("turn on" => x -> 1, "toggle" => x -> mod.(x .+ 1, 2), "turn off" => x -> 0) |>
    display_lights((1000, 1000), _) |>
    sum |>
    print("Part one: ", _, "\n")

@pipe Dict("turn on" => x -> x .+ 1, "toggle" => x -> x .+ 2, "turn off" => x -> max.(x .- 1, zeros(size(x)))) |>
    display_lights((1000, 1000), _) |>
    sum |>
    print("Part two: ", _, "\n")
