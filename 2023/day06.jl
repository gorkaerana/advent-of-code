struct RaceInfo
    time::Integer  # milliseconds
    distance::Integer  # millimeters
end

function number_winning_strategies(race_info::RaceInfo)::Integer
    sum(map(t -> (race_info.time - t) * t > race_info.distance, 0:race_info.time))
end

function parse_multiple_race_info(input::Vector{String})::Vector{RaceInfo}
    times = parse.(Int, split(strip(split(input[1], ":")[2])))
    distances = parse.(Int, split(strip(split(input[2], ":")[2])))
    [RaceInfo(time, distance) for (time, distance) = zip(times, distances)]
end

function parse_single_race_info(input::Vector{String})::RaceInfo
    time = parse(Int, join(split(strip(split(input[1], ":")[2]))))
    distance = parse(Int, join(split(strip(split(input[2], ":")[2]))))
    RaceInfo(time, distance)
end

input = readlines("day06.txt")
product_of_number_of_winning_strategies = prod(number_winning_strategies.(parse_multiple_race_info(input)))
println("Part 1: $product_of_number_of_winning_strategies")
no_winning_strategies = number_winning_strategies(parse_single_race_info(input))
println("Part 2: $no_winning_strategies")
