OPCODES::Dict{Int, Function} = Dict(
    1 => +,
    2 => *
)

program = parse.(Int, split(first(readlines("./input/day02_small.txt")), ","))
println("Program: ", program)
# program[1 + 1] = 12
# program[2 + 1] = 2
# println("Program: ", program)
for i = 1:4:length(program)
    opcode_index, value1_index, value2_index, output_index = i:(i+3)
    opcode = program[opcode_index]
    (opcode == 99) && break
    opcode_function = get(OPCODES, opcode, nothing)
    isnothing(opcode_function) && error("Something went wrong at position $opcode_index: opcode has to be either '1', '2', or '99'; got $opcode")

    # Positions are 0-indexed in the program, and 1-indexed in Julia
    value1_position = program[value1_index] + 1
    value2_position = program[value2_index] + 1
    output_position = program[output_index] + 1
    value1 = program[value1_position]
    value2 = program[value2_position]

    program[output_position] = opcode_function(value1, value2)
    println(program)
    println("---")
end
