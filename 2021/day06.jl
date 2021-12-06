using Pipe: @pipe
using DataStructures: counter, DefaultDict

lanternfish = @pipe dirname(@__FILE__) |>
    joinpath(_, "input", "day06.txt") |>
    readlines(_)[1] |>
    split(_, ",") |>
    parse.(Int, _) |>
    counter(_)

function epoch(population_counter)
    updated_population = DefaultDict(0)
    for (days_to_labour, n) in population_counter
        updated_population[days_to_labour-1] += n
    end
    if -1 in keys(updated_population)
        n_gave_birth = pop!(updated_population, -1)
        # Set counter to 8 for baby lanternfish
        updated_population[8] += n_gave_birth
        # Reset days to 6 for lanternfish that just gave birth
        updated_population[6] += n_gave_birth
    end
    return updated_population
end

n_days = 256
for day_no in 1:n_days
    global lanternfish
    lanternfish = epoch(lanternfish)
    if day_no == 80
        println("Part 1: number of lanternfish after $(day_no) days: $(sum(values(lanternfish))).")
    end
end
println("Part 2: number of lanternfish after $(n_days) days: $(sum(values(lanternfish))).")
