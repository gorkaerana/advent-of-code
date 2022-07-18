using Pipe: @pipe

using DataStructures: DefaultDict

include("../utils.jl")
using .Utils: read_input


n_matches(pattern::Regex, string::String) = length(collect(eachmatch(pattern, string)))

contains_at_least_three_vowels(s::String) = n_matches(r"[aeiou]", s) >= 3

contains_at_least_one_letter_that_appears_twice_in_a_row(s::String) = n_matches(r"([a-z])\1", s) >= 1

contains_forbidden_string(s::String) = n_matches(r"ab|cd|pq|xy", s) >= 1

function is_nice(s::String)
    contains_at_least_three_vowels(s) &&
        contains_at_least_one_letter_that_appears_twice_in_a_row(s) &&
        !contains_forbidden_string(s)
end

contains_at_least_one_letter_which_repeats_with_exactly_one_letter_between(s::String) = n_matches(r"([a-z])[a-z]\1", s) >= 1

contains_a_pair_of_any_two_letters_that_appears_at_least_twice_in_the_string_without_overlapping(s::String) = n_matches(r"([a-z]{2})([a-z]+)?\1", s) >= 1

function is_nicer(s::String)
    contains_at_least_one_letter_which_repeats_with_exactly_one_letter_between(s) &&
        contains_a_pair_of_any_two_letters_that_appears_at_least_twice_in_the_string_without_overlapping(s)
end

@pipe read_input(@__FILE__) |>
    is_nice.(_) |>
    sum |>
    print("Part one: ", _, "\n")

@pipe read_input(@__FILE__) |>
    is_nicer.(_) |>
    sum |>
    print("Part two: ", _, "\n")
