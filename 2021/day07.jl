using Pipe: @pipe

positions = @pipe dirname(@__FILE__) |>
    joinpath(_, "input", "day07.txt") |>
    readlines(_) |>
    split.(_, ",")[1] |>
    parse.(Int, _)

function minimum_fuel_consumption(positions_list; fuel_consumption_rate)
    max_position = maximum(positions)
    destination_tile = reduce(hcat, [1:max_position for _ in positions_list])
    positions_tile = transpose(reduce(hcat, [positions_list for _ in 1:max_position]))    
    @pipe positions_tile - destination_tile |>
        abs.(_) |>
        fuel_consumption_rate.(_) |>
        sum(_, dims=2) |>
        minimum(_)
end

println("Part 1: the minimum fuel consumption (assuming a constant fuel " *
    "consumption rate) is " *
    "$(minimum_fuel_consumption(positions; fuel_consumption_rate=x->x)).")

T(n) = n*(n+1)/2 # 1 + ... + n = n*(n+1)/2
println("Part 2: the minimum fuel consumption (assuming a constantly " *
    "increasing fuel consumption rate) is " *
    "$(minimum_fuel_consumption(positions; fuel_consumption_rate=T)).")
