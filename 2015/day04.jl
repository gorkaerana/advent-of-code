using MD5: md5, bytes2hex
using Pipe: @pipe

include("../utils.jl")
using .Utils: read_input

compute_md5(s) = bytes2hex(md5(s))

"""
Given a `key`, find the first integer that, appending it to the `key`, will match `pattern`
"""
function find_integer_creating_hash_matching_pattern(key, pattern)
    for i in Base.Iterators.countfrom(1)
        md5_hash = @pipe i |>
            string |>
            key * _ |>
            compute_md5
        if match(pattern, md5_hash) !== nothing
            return i
        end
    end
end

secret_key = @pipe read_input(@__FILE__) |> first
@pipe secret_key |> find_integer_creating_hash_matching_pattern(_, r"^0{5,}") |> print("Part one: ", _, "\n")
@pipe secret_key |> find_integer_creating_hash_matching_pattern(_, r"^0{6}") |> print("Part two: ", _, "\n")
