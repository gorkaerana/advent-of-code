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


function find_numbers(line::String)::Vector{Tuple{Integer, UnitRange{Integer}}}
    numbers::Vector{Tuple{Integer, UnitRange{Integer}}} = []
    line_chars = Dict(i => c for (i, c) in enumerate(line))
    col = 1
    while col < length(line)
        number::Vector{Char} = []
        range_::Vector{Integer} = []
        character = get(line_chars, col, nothing)
        if !isnothing(character)
            while isnumeric(character)
                append!(range_, col)
                append!(number, character)
                col += 1
                character = get(line_chars, col, nothing)
                isnothing(character) && break
            end
        end
        if (length(number) > 0) && (length(range_) > 0)
            tuple_ = (parse(Int, join(number)), range(range_[begin], range_[end]))
            push!(numbers, tuple_)
        end
        !isnothing(character) && !isnumeric(character) && (col += 1)
    end
    numbers
end
    
function find_symbols(line::String)::Vector{Tuple{Char, Integer}}
    symbols::Vector{Tuple{Char, Integer}} = []
    for (col, character) in enumerate(line)
        if !isnumeric(character) && (character != '.') # in Set(['*', '#', '+', '$'])
            push!(symbols, (character, col))
        end
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


function numbers_adjacent_to_symbols(numbers::Vector{NumberInfo}, symbols::Vector{SymbolInfo}, max_row::Integer, max_col::Integer)::Vector{NumberInfo}
    result::Vector{NumberInfo} = []
    symbols_set::Set{Tuple{Integer, Integer}} = Set((symbol.row, symbol.col) for symbol in symbols)
    for number in numbers
        if any(tile in symbols_set for tile in adjacent_tiles(number.row, number.col_range, max_row, max_col))
            push!(result, number)
        end
    end
    result
end

function numbers_not_adjacent_to_symbols(numbers::Vector{NumberInfo}, symbols::Vector{SymbolInfo}, max_row::Integer, max_col::Integer)::Vector{NumberInfo}
    result::Vector{NumberInfo} = []
    symbols_set::Set{Tuple{Integer, Integer}} = Set((symbol.row, symbol.col) for symbol in symbols)
    for number in numbers
        if !any(tile in symbols_set for tile in adjacent_tiles(number.row, number.col_range, max_row, max_col))
            push!(result, number)
        end
    end
    result
end

numbers::Vector{NumberInfo} = []
symbols::Vector{SymbolInfo} = []
lines = readlines("day03_small.txt")
for (row, line) in enumerate(lines)
    append!(numbers, (NumberInfo(number, row, col_range) for (number, col_range) in find_numbers(line)))
    append!(symbols, (SymbolInfo(symbol, row, col) for (symbol, col) in find_symbols(line)))
end
println(sum(number.number for number in numbers_adjacent_to_symbols(numbers, symbols, length(lines), length(lines[begin]))))
