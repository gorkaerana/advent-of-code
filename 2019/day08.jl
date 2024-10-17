function gather_image(image_data::String, width::Int64, height::Int64)::Array{Char}
    permutedims(
        reshape(collect(image_data), width, height, :),
        (2, 1, 3)
    )
end

function top_visible_pixel(input::Vector{Char})# ::Char
    first_black = findfirst(==('0'), input)
    first_white = findfirst(==('1'), input)
    isnothing(first_black) && isnothing(first_white) && return '2'
    isnothing(first_black) && return '1'
    isnothing(first_white) && return '0'
    (first_black < first_white) ? '0' : '1'
end


image_data = first(readlines("./input/day08.txt"))
image = gather_image(image_data, 25, 6)

z = argmin(reshape(sum(image .== '0', dims=(1, 2)), :))  # Layer with fewest zeros
output1 = sum(image[:, :, z] .== '1') * sum(image[:, :, z] .== '2')
println("Part 1: $output1")

message = dropdims(mapslices(top_visible_pixel, image, dims=3), dims=3)
for row = 1:size(message, 1)
    for col = 1:size(message, 2)
        value = message[row, col]
        (value == '0') ? print(" ") : print("#")
    end
    println()
end
