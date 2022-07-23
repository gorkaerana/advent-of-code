using DataStructures: DefaultDict
using Pipe: @pipe

include("../utils.jl")
using .Utils: read_input


struct Instruction
    name::String
    register::Union{Nothing, String}
    offset::Union{Nothing, Int}
end


function parse_instruction(s::String)
    (name, register, offset) = @pipe s |>
        match(r"^(hlf|tpl|inc|jmp|jie|jio) (\-?\+?\w+),? ?(\-?\+?\w+)?", _) |>
        map(i -> getindex(_, i), 1:3)
    if name ∈ ["hlf", "tpl", "inc"]
        return Instruction(name, register, nothing)
    elseif name == "jmp"
        return Instruction(name, nothing, parse(Int, register))
    elseif name ∈ ["jie", "jio"]
        return Instruction(name, register, parse(Int, offset))
    else
        throw("Instruction '$(name)' not supported")
    end
end


function apply_instructions(instructions::Vector{Instruction}, init_kv::Dict)
    register_values = DefaultDict(0, init_kv)
    i = 1
    while i <= length(instructions)
        (name, register, offset) = @pipe i |> getindex(instructions, _) |> (_.name, _.register, _.offset)
        if name == "hlf"
            register_values[register] /= 2
        elseif name == "tpl"
            register_values[register] *= 3
        elseif name == "inc"
            register_values[register] += 1
        elseif (name == "jmp") ||
            (name == "jie" && register_values[register] % 2 == 0) ||
            (name == "jio" && register_values[register] == 1)
            i += (offset - 1)
        end
        i += 1
    end
    register_values
end


@pipe read_input(@__FILE__) |>
    parse_instruction.(_) |>
    apply_instructions(_, Dict()) |>
    getindex(_, "b") |>
    print("Part one: ", _, "\n")

@pipe read_input(@__FILE__) |>
    parse_instruction.(_) |>
    apply_instructions(_, Dict("a" => 1)) |>
    getindex(_, "b") |>
    print("Part two: ", _, "\n")
