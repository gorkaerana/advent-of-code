OPCODES::Dict{Int, Function} = Dict(
    1 => +,
    2 => *
)

function run_program(program::Vector{Int64}, noun::Int64, verb::Int64)
    new_program = copy(program)
    new_program[1 + 1] = noun
    new_program[2 + 1] = verb 
    for i = 1:4:length(new_program)
        opcode_address, value1_address, value2_address, output_address = i:(i+3)
        opcode = new_program[opcode_address]
        (opcode == 99) && break
        opcode_function = get(OPCODES, opcode, nothing)
        isnothing(opcode_function) && error("Something went wrong at position $opcode_address: opcode has to be either '1', '2', or '99'; got $opcode")

        # Positions are 0-indexed in the new_program, whereas Julia is 1-indexed
        parameter1 = new_program[value1_address] + 1
        parameter2 = new_program[value2_address] + 1
        output_parameter = new_program[output_address] + 1
        value1 = new_program[parameter1]
        value2 = new_program[parameter2]

        new_program[output_parameter] = opcode_function(value1, value2)
    end
    new_program[1]
end

function iterate_solution_space(program::Vector{Int64}, target::Int64)
    max_value = length(program) - 1
    for noun = 1:max_value, verb = 1:max_value
        run_program(program, noun, verb) == target && return (100 * noun) + verb
    end
    error("Uh oh, did not find solution")
end


program = parse.(Int, split(first(readlines("./input/day02.txt")), ","))
println("Part 1: $(run_program(program, 12, 2))")
println("Part 2: $(iterate_solution_space(program, 19690720))")
