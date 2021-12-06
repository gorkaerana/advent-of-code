using Pipe: @pipe

lanternfish = @pipe dirname(@__FILE__) |>
    joinpath(_, "input", "day06.txt") |>
    readlines(_)[1] |>
    split(_, ",") |>
    parse.(Int, _)
lanternfish = [3,4,3,1,2]

function epoch(population_array)
    population_array .-= 1
    for _ in 1:sum(population_array .== -1)
        push!(population_array, 8)
    end
    population_array[population_array .== -1] .= 6
    return population_array
end

n_days = 80
for day_no in 1:n_days
    lanternfish[:] = epoch(lanternfish)
end
println("Part 1: number of lanternfish after $(n_days) days: $(length(lanternfish)).")
