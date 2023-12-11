using Base.Iterators: cycle, repeat

const Instructions = Vector{Char}
const Network = Dict{SubString, Vector{SubString{String}}}

function parse_input(input::Vector{String})::Tuple{Instructions, Network}
    instructions = input |> first |> collect
    network = Dict(
        key => split(strip(value, ['(', ')']), ", ")
        for (key, value) = split.(input[3:end], " = ")
            )
    tuple(instructions, network)
end

function count_steps_from_start_nodes(
    instructions::Instructions,
    network::Network,
    start_nodes::Union{Vector{String}, Vector{SubString}},
    end_criteria::Function
    )
    step_counter = 0
    nodes = start_nodes
    for i = cycle(1:length(instructions))
        instruction = instructions[i]
        for (j, node) in enumerate(nodes)
            nodes[j] = network[node][(instruction == 'R') ? 2 : 1]
        end
        step_counter += 1
        end_criteria(nodes) && break
    end    
    step_counter
end

input = readlines("day08.txt")
instructions, network = parse_input(input)

n_steps = count_steps_from_start_nodes(instructions, network, ["AAA"], n -> n[1] == "ZZZ")
println("Part 1: $n_steps")
