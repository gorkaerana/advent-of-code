using Pipe: @pipe

function counter(list)
    c = Dict()
    for item in list
        if haskey(c, item)
            c[item] += 1
        else
            c[item] = 1
        end
    end
    c
end
bit_type_counter(numbers) = [counter([bits[i] for bits in numbers]) for i in 1:length(numbers[2])]

function compare_reduce(dict, comp_func, precedence)
    extremum = comp_func(values(dict))
    if sum(extremum .== values(dict)) > 1
        return precedence
    end
    for (k, v) in collect(dict)
        if v == extremum
            return k
        end
    end
end
most_common(counter_dict) = compare_reduce(counter_dict, maximum, '1')
least_common(counter_dict) = compare_reduce(counter_dict, minimum, '0')

function bit_criteria(numbers, criteria_func)
    n_bits = length(numbers[1])
    filtered_numbers = numbers
    for idx in 1:n_bits
        if length(filtered_numbers) == 1
            break
        end
        bit_counters = bit_type_counter(filtered_numbers)
        bit = criteria_func.(bit_counters)[idx]
        filtered_numbers = filter(x -> x[idx] == bit, filtered_numbers)
    end
    filtered_numbers[1]
end
oxygen_generator_rating_filter(numbers) = bit_criteria(numbers, most_common)
co2_scrubber_rating_filter(numbers) = bit_criteria(numbers, least_common)

# Part 1
diagnostic_report = @pipe dirname(@__FILE__) |>
    joinpath(_, "input", "day03.txt") |>
    readlines(_)
n_bits = length(diagnostic_report[1])
# Count bit types across all numbers
bit_counters = bit_type_counter(diagnostic_report)
γ = @pipe bit_counters |> most_common.(_) |> join(_) |> parse(Int, _, base=2)
ϵ = @pipe bit_counters |> least_common.(_) |> join(_) |> parse(Int, _, base=2)
power_consumption = γ * ϵ
println("Part 1: the power consumption of the submarine is $power_consumption.")

# Part 2
oxygen_generator_rating = @pipe diagnostic_report |>
    oxygen_generator_rating_filter(_) |>
    parse(Int, _, base=2)
co2_scubber_rating = @pipe diagnostic_report |>
    co2_scrubber_rating_filter(_) |>
    parse(Int, _, base=2)
life_support_rating = oxygen_generator_rating * co2_scubber_rating
println("Part 2: the life support rating of the submarine is $life_support_rating.")
