function find_first_and_last_digits(string::String)::Int
    digits = filter(isnumeric, string)
    first_and_last = join([digits[begin], digits[end]])
    parse(Int, first_and_last)
end
# Part 1
total1 = sum(map(find_first_and_last_digits, readlines("day01.txt")))
println("Part 1: $total1")

# Part 2
function find_first_and_last_digits_spelled(string::String)::Int
    number_names = Dict(
        "one" => 1,
        "two" => 2,
        "three" => 3,
        "four" => 4,
        "five" => 5,
        "six" => 6,
        "seven" => 7,
        "eight" => 8,
        "nine" => 9
    )
    digit_positions = Dict(i => parse(Int, character) for (i, character) in enumerate(string) if isnumeric(character))
    spelled_number_positions = Dict{Int, Int}()
    for (name, value) in number_names
        for match in findall(name, string)
            spelled_number_positions[match[begin]] = number_names[string[match]]
        end
    end
    merge!(digit_positions, spelled_number_positions)
    number = parse(Int, join([digit_positions[minimum(keys(digit_positions))], digit_positions[maximum(keys(digit_positions))]]))
    number
end

# Part 2
total2 = sum(map(find_first_and_last_digits_spelled, readlines("day01.txt")))
println("Part 2: $total2")
