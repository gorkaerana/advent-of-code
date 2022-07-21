using JSON
using Pipe: @pipe

include("../utils.jl")
using .Utils: read_input


function recurse_add_numbers(json_object::Vector, exclude_keys::Vector=[], exclude_values::Vector=[])
    t = 0
    for e in json_object
        t += isa(e, Number) ? e : recurse_add_numbers(e, exclude_keys, exclude_values)
    end
    t
end

common_elements(a, b) = intersect(Set(a), Set(b))

function recurse_add_numbers(json_object::Dict, exclude_keys::Vector=[], exclude_values::Vector=[])
    t = 0
    no_forbidden_keys = isempty(common_elements(exclude_keys, keys(json_object)))
    no_forbidden_values = isempty(common_elements(exclude_values, values(json_object)))
    if no_forbidden_keys && no_forbidden_values
        for v in values(json_object)
            t += isa(v, Number) ? v : recurse_add_numbers(v, exclude_keys, exclude_values)
        end
    end
    t
end

recurse_add_numbers(s::String, exclude_keys::Vector, exclude_values::Vector) = 0

@pipe read_input(@__FILE__) |>
    first |>
    JSON.parse |>
    recurse_add_numbers(_) |>
    print("Part one: ", _, "\n")

@pipe read_input(@__FILE__) |>
    first |>
    JSON.parse |>
    recurse_add_numbers(_, [], ["red"]) |>
    print("Part two: ", _, "\n")
