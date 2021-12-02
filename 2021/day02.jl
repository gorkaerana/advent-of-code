using Pipe: @pipe
using CSV
using DataFrames

directions = @pipe joinpath(dirname(@__FILE__), "input", "day02.txt") |>
    CSV.read(_, DataFrame, delim=' ', header=false) |>
    rename!(_, :Column1 => :direction, :Column2 => :quantity)
directions[directions.direction.=="up", :quantity] *= -1
directions[:, :forward_mask] = directions.direction.=="forward"
# Part 1
horizontal = sum(directions.quantity .* directions.forward_mask)
depth = sum(directions.quantity .* .~directions.forward_mask)
println("Part 1: the product of the horizontal position and depth is: $(horizontal * depth)")
# Part 2
aim = cumsum(directions.quantity .* .~directions.forward_mask)
aim_adjusted_depth = sum(directions.quantity .* directions.forward_mask .* aim)
println("Part 2: the product of the horizontal position and depth (adjusted for aim) is: $(horizontal * aim_adjusted_depth)")
