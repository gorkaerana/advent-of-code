using Pipe: @pipe

include("../utils.jl")
using .Utils: read_input

ALPHABET = collect('a':'z')

function next_password(current::String)
    new_password = []
    change_char = true
    for char in reverse(current)
        new_char = char
        if change_char
            new_char = @pipe char |>
                findfirst(isequal(_), ALPHABET) |>
                _ + 1 |>
                mod(_, length(ALPHABET) + 1) |>
                ((_ == 0) ? 1 : _) |>
                ALPHABET[_]
        end
        if new_char != 'a'
            change_char = false
        end
        push!(new_password, new_char)
    end
    reverse(join(new_password, ""))
end

function has_n_matches(pattern::Regex, s::String, n::Int)
    @pipe eachmatch(pattern, s) |>
        collect |>
        length |>
        >=(n)
end

function contains_one_increasing_straight_of_at_least_three_letters(s::String)
    @pipe ALPHABET |>
        zip(_, _[2:end], _[3:end]) |>
        collect |>
        join.(_) |>
        join(_, "|") |>
        Regex |>
        has_n_matches(_, s, 1)
end

function contains_chars(s::String, l::Vector{Char})
    @pipe l |>
        join(_, "|") |>
        Regex |>
        has_n_matches(_, s, 1)
end

function contain_at_least_two_different_non_overlapping_pairs_of_letters(s::String)
    @pipe ALPHABET |>
        zip(_, _) |>
        collect |>
        join.(_) |>
        join(_, "|") |>
        Regex |>
        has_n_matches(_, s, 2)
end

function is_valid(password::String)
    contains_one_increasing_straight_of_at_least_three_letters(password) &&
        !contains_chars(password, ['i', 'o', 'l']) &&
        contain_at_least_two_different_non_overlapping_pairs_of_letters(password)
end

function find_next_valid_password(password::String)
    let new_password = password
        while !is_valid(new_password)
            new_password = next_password(new_password)
        end
        new_password
    end
end

new = @pipe read_input(@__FILE__) |>
    first |>
    find_next_valid_password
print("Part one: $(new)\n")

@pipe new |>
    next_password |>
    find_next_valid_password |>
    print("Part two: ", _, "\n")
