using DataStructures: Deque, pop!, popfirst!, push!, pushfirst!
using IterTools: chain, repeat
using Pipe: @pipe

function clean_bucket(s)
    strip(s, [' ', '[', ']'])
end

function parse_crate_row(s::T, n::Int64) where T <: String
    regex = Regex(join(["^", join(repeat(["(\\[[A-Z]\\]|[ ]{3})"], n), " ")], ""))
    clean_bucket.(match(regex, s).captures)
end

function parse_move(s::T) where T <: String
    m = match(r"move (\d+) from (\d+) to (\d+)", s)
    amount, from, to = parse.(Int, m.captures)
    amount, from, to
end

function find_stack_line(lines::Vector{String})
    for (lineno, line) in enumerate(lines)
        all(c -> isspace(c) || isnumeric(c), line) && return lineno
    end
end

function parse_input(filename::AbstractString)
    lines = readlines(filename)
    stack_lineno = find_stack_line(lines)
    stacks = lines[begin:(stack_lineno-1)]
    n_stacks = maximum(parse.(Int64, split(lines[stack_lineno])))
    movements = lines[(stack_lineno+2):end]
    stacks, n_stacks, movements
end

function stacks_to_queues(stacks::Vector{String}, n_stacks::Int64)
    queues = Dict(i => Deque{String}() for i = 1:n_stacks)
    for crate_row in stacks
        for (i, crate) in enumerate(parse_crate_row(crate_row, n_stacks))
            q = queues[i]
            if crate != ""
                push!(q, crate)
            end
        end
    end
    queues
end

function make_movement!(queues::Dict{Int64, Deque{String}}, amount::Int64, from_index::Int64, to_index::Int64, part::Int64=1)
    from_q = queues[from_index]
    to_q = queues[to_index]
    to_be_pushed = [popfirst!(from_q) for i = 1:amount]
    if part == 2
        to_be_pushed = reverse(to_be_pushed)
    end
    for item in to_be_pushed
        pushfirst!(to_q, item)
    end
    queues
end

input_file = @pipe identity(@__FILE__) |>
    joinpath(dirname(_), "input", first(splitext(basename(_))) * ".txt")

for part = 1:2
    stacks, n_stacks, movements = parse_input(input_file)
    queues = stacks_to_queues(stacks, n_stacks)
    for (amount, from, to) in parse_move.(movements)
        make_movement!(queues, amount, from, to, part)
    end
    answer = join([popfirst!(queues[i]) for i = 1:length(queues)], "")
    println("Part $part: $answer")
end
