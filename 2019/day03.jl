Point = Tuple{Int64, Int64}
Points = Vector{Point}

manhattan(p::Point) = sum(map(abs, p))

function get_points(path::String)::Points
    points::Points = [(0, 0)]
    for instruction in split(path, ",")
        direction = instruction[1]
        n_steps = parse(Int, instruction[2:end])
        x, y = points[end]
        if direction == 'U'
            append!(points, [(i, y) for i = (x+1):(x+n_steps)])
        elseif direction == 'R'
            append!(points, [(x, i) for i = (y+1):(y+n_steps)])
        elseif direction == 'D'
            append!(points, [(i, y) for i = (x-1):-1:(x-n_steps)])
        elseif direction == 'L'
            append!(points, [(x, i) for i = (y-1):-1:(y-n_steps)])
        else
            error("Direction can only be one of 'U', 'R', 'D', or 'L'; got $direction")
        end
    end
    popfirst!(points)
    points
end

crossings(path1::Points, path2::Points)::Points = intersect(path1, path2)

n_steps_to(point::Point, points::Points)::Int64 = findfirst([point] .== points)

input_lines = readlines("./input/day03.txt")
first_cable = get_points(input_lines[1])
second_cable = get_points(input_lines[2])
intersections = crossings(first_cable, second_cable)

output1 = first(map(manhattan, sort(intersections, by=manhattan)))
println("Part 1: $output1")

output2 = minimum([sum([n_steps_to(p, cable) for cable = [first_cable, second_cable]]) for p in intersections])
println("Part 2: $output2")
