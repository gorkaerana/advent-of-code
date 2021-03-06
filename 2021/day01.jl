using Pipe: @pipe

function read_file_content(path::String)
    lines = []
    open(path, "r") do file
        while !eof(file)
            push!(lines, readline(file))
        end
    end
    return lines
end

depths = @pipe joinpath(dirname(@__FILE__), "input", "day01.txt") |>
    read_file_content(_) |>
    parse.(Int64, _)

# Part 1
n_larger_measurement = sum([t[2]-t[1]>=0 for t in zip(depths, depths[2:end])])
println("The number of depth measurements bigger than their previous one is $(n_larger_measurement).")

# Part 2
windows = [w for w in zip(depths, depths[2:end], depths[3:end])]
n_larger_sums = sum([sum(w[2]) > sum(w[1]) for w in zip(windows, windows[2:end])])
println("The number of three-measurement sliding window larger than the previous one is $(n_larger_sums).")
