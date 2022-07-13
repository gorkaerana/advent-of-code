using Pipe: @pipe

function polymer_template_counter(polymer_template, pair_insertion_rules)
    polymer_pair_counter = @pipe (polymer_template, pair_insertion_rules) |>
        vcat(_[1], keys(_[2])..., values(_[2])...) |>
        split.(_, "") |>
        vcat(_...) |>
        unique(_) |>
        Iterators.product(_, _) |>
        collect(_) |>
        vcat(_...) |>
        join.(_, "") |>
        Dict(key => 0 for key in _)
    for (p1, p2) in zip(polymer_template, polymer_template[2:end])
        polymer_pair_counter[p1 * p2] = 1
    end
    polymer_pair_counter
end

function process_input(input_filepath)
    input_lines = readlines(input_filepath)
    polymer_template = input_lines[1]
    pair_insertion_rules = @pipe input_lines[3:end] |>
        split.(_, " -> ") |>
        Dict(key => val for (key, val) in _)
    @pipe (polymer_template, pair_insertion_rules) |>
        (polymer_template_counter(_[1], _[2]), _[2])
end

function count_letters(polymer_pair_counter)
    letter_counts = @pipe polymer_pair_counter |>
        keys(_) |>
        split.(_, "") |>
        vcat(_...) |>
        unique(_) |>
        Dict(letter => 0 for letter in _)
    for (pair, count) in polymer_pair_counter
        letter_counts[string(pair[1])] += count
        letter_counts[string(pair[2])] += count
    end
    # Tally is kept in pairs
    for (letter, count) in letter_counts
        letter_counts[letter] = ceil(count / 2)
    end
    letter_counts
end

function pair_insertion_step(polymer_pair_counter, pair_insertion_rules)
    updated_counter = Dict(key => 0 for key in keys(polymer_pair_counter))
    for (pair, count) in polymer_pair_counter
        if count != 0
            insertion = pair_insertion_rules[pair]
            updated_counter[pair[1] * insertion] += count
            updated_counter[insertion * pair[2]] += count
        end
    end
    updated_counter
end

function pair_insertion_process(polymer_pair_counter, pair_insertion_rules, n)
    for i = 1:n
        polymer_pair_counter = pair_insertion_step(
            polymer_pair_counter,
            pair_insertion_rules
        )
    end
    polymer_pair_counter
end

@pipe joinpath(@__DIR__, "input", "day14.txt") |>
    process_input(_) |>
    pair_insertion_process(_[1], _[2], 10) |>
    count_letters(_) |>
    values(_) |>
    maximum(_) - minimum(_) |>
    print("Part 1: ", _, "\n")

@pipe joinpath(@__DIR__, "input", "day14.txt") |>
    process_input(_) |>
    pair_insertion_process(_[1], _[2], 40) |>
    count_letters(_) |>
    values(_) |>
    maximum(_) - minimum(_) |>
    print("Part 2: ", _, "\n")
