using Pipe: @pipe

include("../utils.jl")
using .Utils: read_input

struct Reindeer
    name::String
    speed::Int      # km/s
    fly_time::Int   # s
    rest_time::Int  # s
end


function parse_description(desc::String)
    @pipe desc |>
        match(r"(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds.", _) |>
        collect |>
        (_[1], parse.(Int, _[2:end])...) |>
        Reindeer(_...)
end


function completed_distances(time::Int, reindeers::Vector{Reindeer}, leader_points::Int)
    distances, points = (zeros(Int, length(reindeers)), zeros(Int, length(reindeers)))
    for t = 1:time
        for (i, reindeer) in enumerate(reindeers)
            fly_time = reindeer.fly_time
            loop_time = fly_time + reindeer.rest_time
            adjusted = mod(t, loop_time)
            adjusted = adjusted == 0 ? t : adjusted
            if adjusted <= fly_time
                distances[i] += reindeer.speed
            end
        end
        points[findall(isequal(maximum(distances)), distances)] .+= leader_points
    end
    (distances, points)
end


@pipe read_input(@__FILE__) |>
    parse_description.(_) |>
    completed_distances(2503, _, 0) |>
    first |>
    maximum |>
    print("Part one: ", _, "\n")

@pipe read_input(@__FILE__) |>
    parse_description.(_) |>
    completed_distances(2503, _, 1) |>
    last |>
    maximum |>
    print("Part two: ", _, "\n")
