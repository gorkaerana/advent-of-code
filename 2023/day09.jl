function find_next_value(input_line::String)
    series = parse.(Int, strip.(split(input_line)))
    triangle::Vector{Vector{Int64}} = [series, diff(series)]
    # Make triangle
    while !all(i == 0 for i = triangle[end])
        push!(triangle, diff(triangle[end]))
    end
    # Backtrack
    for i = length(triangle):-1:2
        push!(triangle[i - 1], triangle[i][end] + triangle[i - 1][end])
    end
    triangle[1][end]
end

function find_previous_value(input_line::String)
    series = parse.(Int, strip.(split(input_line)))
    triangle::Vector{Vector{Int64}} = [series, diff(series)]
    # Make triangle
    while !all(i == 0 for i = triangle[end])
        push!(triangle, diff(triangle[end]))
    end
    # Backtrack
    for i = length(triangle):-1:2
        prepend!(triangle[i - 1], triangle[i - 1][1] - triangle[i][1])
    end
    triangle[1][1]
end

input = readlines("day09.txt")
# Part 1
sum_next_values = sum(find_next_value.(input))
println("Part 1: $sum_next_values")
# Part 2
sum_previous_values = sum(find_previous_value.(input))
println("Part 2: $sum_previous_values")
