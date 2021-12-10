using Pipe: @pipe

input = @pipe joinpath(@__DIR__, "input", "day10_small.txt") |>
    readlines(_) |>
    join(_, "")

delimiters = Dict(
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
)
opening_delimiters = keys(delimiters)
closing_delimiters = values(delimiters)
function parser(string)
    for char in string
        if in(char, opening_delimiters)
            #
        elseif in(char, closing_delimiters)
            throw(error("Unexpected $(char)"))
        else
            # the last thing
        end
    end
end
s = "]"
parser(s)
