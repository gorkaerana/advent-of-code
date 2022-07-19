using Pipe: @pipe

include("../utils.jl")
using .Utils: read_input

"""
A la Python's itertools.groupby: https://docs.python.org/3/library/itertools.html#itertools.groupby
"""
function groupby(f, itr)
    grouped = []
    for item in itr
        f_ = f(item)
        if length(grouped) != 0 && f_ == grouped[end][1]
            push!(grouped[end][2], item)
        else
            push!(grouped, [f_, [item]])
        end
    end
    return grouped
end

function look_and_say(string)
    @pipe string |>
        groupby(identity, _) |>
        map(t -> (t[1], length(t[2])), _) |>
        map(reverse, _) |>
        join.(_) |>
        join
end

function look_and_say_sequence(input, n)
    let s = deepcopy(input)
        for i = 1:n
            s = look_and_say(s)
        end
        return s
    end
end


@pipe read_input(@__FILE__) |>
    first |>
    look_and_say_sequence(_, 40) |>
    print("Part one: ", length(_), "\n")

@pipe read_input(@__FILE__) |>
    first |>
    look_and_say_sequence(_, 50) |>
    print("Part two: ", length(_), "\n")
