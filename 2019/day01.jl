struct Module_
    mass::Number
end

required_fuel(mass::Number) = floor(mass / 3) - 2

required_fuel(m::Module_) = floor(m.mass / 3) - 2

function required_fuel_in_total(m::Module_)
    fuel = required_fuel(m)
    fuels::Vector{Number} = []
    while fuel > 0
        append!(fuels, fuel)
        fuel = required_fuel(fuel)
    end
    sum(fuels, init = 0)
end


part1 = floor(Int, sum(required_fuel(Module_(parse(Int, line))) for line in readlines("./input/day01.txt")))
println("Part 1: $part1")

part2 = floor(Int, sum(required_fuel_in_total(Module_(parse(Int, line))) for line in readlines("./input/day01.txt")))
println("Part 2: $part2")
