struct NumberInfo
    number::Integer
    row::Integer
    col_range::UnitRange{Integer}
end

struct SymbolInfo
    symbol::Char
    row::Integer
    col::Integer
end

struct Adjacency
    number::NumberInfo
    symbol::SymbolInfo
end

function find_numbers(line::String)::Vector{Tuple{Integer, UnitRange{Integer}}}
    numbers::Vector{Tuple{Integer, UnitRange{Integer}}} = []
    line_chars = Dict(i => c for (i, c) in enumerate(line))
    col = 1
    while col < length(line)
        number::Vector{Char} = []
        columns::Vector{Integer} = []
        character = get(line_chars, col, nothing)
        if !isnothing(character)
            while isnumeric(character)
                append!(columns, col)
                append!(number, character)
                col += 1
                character = get(line_chars, col, nothing)
                isnothing(character) && break
            end
        end
        if (length(number) > 0) && (length(columns) > 0)
            tuple_ = (parse(Int, join(number)), range(columns[begin], columns[end]))
            push!(numbers, tuple_)
        end
        !isnothing(character) && !isnumeric(character) && (col += 1)
    end
    numbers
end
    
function find_symbols(line::String)::Vector{Tuple{Char, Integer}}
    symbols::Vector{Tuple{Char, Integer}} = []
    for (col, character) in enumerate(line)
        !isnumeric(character) && (character != '.') && push!(symbols, (character, col))
    end
    symbols
end


function adjacent_tiles(row::Integer, col_range::UnitRange{Integer}, max_row::Integer, max_col::Integer)::Vector{Tuple{Integer, Integer}}
    adjacents::Vector{Tuple{Integer, Integer}} = []
    for i in (row-1):(row+1), j in (col_range[begin]-1):(col_range[end]+1)
        (i > 0) && (j > 0) && (i <= max_row) && (j <= max_col) && push!(adjacents, (i, j))
    end
    adjacents
end

function find_adjacents(numbers::Vector{NumberInfo}, symbols::Vector{SymbolInfo}, max_row::Integer, max_col::Integer)::Vector{Adjacency}
    result::Vector{Adjacency} = []
    symbols_dict::Dict{Tuple{Integer, Integer}, SymbolInfo} = Dict((symbol.row, symbol.col) => symbol for symbol in symbols)
    for number in numbers
        for tile in adjacent_tiles(number.row, number.col_range, max_row, max_col)
            symbol = get(symbols_dict, tile, nothing)
            if any(!isnothing(symbol))
                push!(result, Adjacency(number, symbol))
            end            
        end
    end
    result
end

numbers::Vector{NumberInfo} = []
symbols::Vector{SymbolInfo} = []
lines = readlines("day03.txt")
for (row, line) in enumerate(lines)
    append!(numbers, (NumberInfo(number, row, col_range) for (number, col_range) in find_numbers(line)))
    append!(symbols, (SymbolInfo(symbol, row, col) for (symbol, col) in find_symbols(line)))
end

adjacencies = find_adjacents(numbers, symbols, length(lines), length(lines[begin]))

# Part 1
sum_of_numbers_adjacent_to_symbols = sum(adjacency.number.number for adjacency in adjacencies)
println("Part 1: $sum_of_numbers_adjacent_to_symbols")

# Part 2
adjacent_symbols_counter::Dict{SymbolInfo, Integer} = Dict()
for adjacent in adjacencies
    c = get(adjacent_symbols_counter, adjacent.symbol, 0)
    adjacent_symbols_counter[adjacent.symbol] = c + 1
end
gear_ratios = [
    prod(adjacency.number.number for adjacency = filter(a -> a.symbol == symbol, adjacencies))
    for symbol = keys(filter(p -> (p.second == 2) && (p.first.symbol == '*'), adjacent_symbols_counter))
        ]
sum_of_gear_ratios = sum(gear_ratios)
println("Part 2: $sum_of_gear_ratios")
