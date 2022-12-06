using Pipe: @pipe

function find_first_start_of_packet(s::String, n::Int64)
    for i = (n+1):length(s)
        substring = s[(i-n+1):i]
        (length(Set(substring)) == n) && return i
    end
end

input = @pipe identity(@__FILE__) |>
    joinpath(dirname(_), "input", first(splitext(basename(_))) * ".txt") |>
    read(_, String)
println("Part 1: ", find_first_start_of_packet(input, 4))
println("Part 2: ", find_first_start_of_packet(input, 14))
