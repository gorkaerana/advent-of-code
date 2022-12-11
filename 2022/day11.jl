struct Monkey
    number::Int64
    items::Vector{Int128}
    operation::Function
    test::Function
    success::Int64
    failure::Int64
    divisor::Int64
end

function parse_monkeys(input_file::AbstractString)::Dict{Int64, Monkey}
    regex = r"
    Monkey\s(\d+):\n
    \s+Starting\sitems:\s([\d+,*\s]+)\n
    \s+Operation:\s(.*)\n
    \s+Test:\sdivisible\sby\s(\d+)
    \s+If\strue:\sthrow\sto\smonkey\s(\d+)
    \s+If\sfalse:\sthrow\sto\smonkey\s(\d+)
    "x
    OPERATION_MAP = Dict("+" => +, "*" => *)
    monkeys = Dict()
    to_int = x -> parse(Int64, x)
    for m in eachmatch(regex, read(input_file, String))
        monkey_n, starting_items, operation, test, success, failure = m.captures
        monkey_n = to_int(monkey_n)
        _, op, var2 = split(split(operation, " = ")[2], r" + | * ")
        divisor = to_int(test)
        op = OPERATION_MAP[op]
        operation_function = (var2 == "old") ? x -> op(x, x) : x -> op(x, to_int(var2))
        monkeys[monkey_n] = Monkey(
            monkey_n,
            to_int.(split(starting_items, ", ")),
            operation_function,
            x -> mod(x, divisor) == 0,
            to_int(success),
            to_int(failure),
            divisor
        )
    end
    monkeys
end

function rounds(monkeys::Dict{Int64, Monkey}, n_rounds::Int64, relief::Function)::Dict{Int64, Int64}
    items_inspected = Dict(k => 0 for k in keys(monkeys))
    for round in 1:n_rounds
        for n in 0:(length(monkeys)-1)
            monkey = monkeys[n]
            while length(monkey.items) > 0
                worry_level = popfirst!(monkey.items)
                worry_level = monkey.operation(worry_level)
                worry_level = relief(worry_level)
                target_monkey = monkey.test(worry_level) ? monkey.success : monkey.failure
                push!(monkeys[target_monkey].items, worry_level)
                items_inspected[n] += 1
            end
        end
    end
    items_inspected
end

function monkey_business(inspected_items::Dict{Int64, Int64})::Int64
    prod(reverse(sort(collect(values(inspected_items))))[begin:2])
end

here = dirname(@__FILE__)
filename = first(splitext(basename(@__FILE__)))
input_file = joinpath(here, "input", filename * ".txt")
monkeys = parse_monkeys(input_file)
println("Part 1: ", monkey_business(rounds(monkeys, 20, w -> floor(w / 3))))
monkeys = parse_monkeys(input_file)
M = lcm(collect(m.divisor for m in values(monkeys)))
println("Part 2: ", monkey_business(rounds(monkeys, 10000, w -> mod(w, M))))
