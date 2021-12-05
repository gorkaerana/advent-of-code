using Pipe: @pipe
using DataStructures: DefaultDict

input_data = @pipe dirname(@__FILE__) |>
    joinpath(_,  "input", "day05.txt") |>
    readlines(_)

function coordinate_range(a, b)
    if a > b
        return a:-1:b
    end
    return a:b
end

function euclidean_distance(x1, y1, x2, y2)
    sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function is_diagonal_line(x1, y1, x2, y2)
    ed = euclidean_distance(x1, y1, x2, y2)
    if isapprox(ed, 0)
        return true
    end
    ps = abs((x2 - x1) / ed)
    return isapprox(ps, sin(pi/4))
end

# Part 1
heatmap1 = DefaultDict(0)
heatmap2 = DefaultDict(0)
for row in input_data
    coordinates = split(row, r" -> |,")
    x1, y1, x2, y2 = parse.(Int, coordinates)
    # Part 1
    if (x1 == x2) || (y1 == y2)
        for x in coordinate_range(x1, x2)
            for y in coordinate_range(y1, y2)
                heatmap1[(x, y)] += 1
                heatmap2[(x, y)] += 1
            end
        end
    # Part 2
    elseif is_diagonal_line(x1, y1, x2, y2)
        for x in coordinate_range(x1, x2)
            for y in coordinate_range(y1, y2)
                if is_diagonal_line(x1, y1, x, y)
                    heatmap2[(x, y)] += 1
                end
            end
        end
    end
end

println("Part 1: the number of points where at least two vertical or horizontal lines overlap is $(sum(val > 1 for val in values(heatmap1))).")
println("Part 2: the number of points where at least two vertical, horizontal or diagonal lines overlap is $(sum(val > 1 for val in values(heatmap2))).")
