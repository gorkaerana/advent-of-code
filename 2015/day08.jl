function number_string_characters(string::String)
    i = 2
    n = 0
    while i < length(string)
        character = string[i]
        if character == '\\'
            next = string[i+1]
            if next == '\\'
                n += 1
                i += 2
                continue
            elseif next == '"'
                n += 1
                i += 2
                continue                
            elseif next == 'x'
                n += 1
                i += 4
                continue
            end
        end
        i += 1
        n += 1
    end
    n
end

function new_encoding(string::String)::String
    characters::Vector{Char} = ['"']
    i = 1
    while i <= length(string)
        character = string[i]
        if character == '"'
            push!(characters, '\\')
            # push!(characters, character)
            # i += 1
            # continue
        elseif character == '\\'
            push!(characters, '\\')
            # push!(characters, character)                        
            # i += 1
            # continue
        end
        push!(characters, character)
        i += 1
    end
    push!(characters, '"')
    join(characters)
end

# Part 1
lines = readlines("input/day08.txt")
println("Part 1: $(sum(length.(lines)) - sum(number_string_characters.(lines)))")

# Part 2
println("Part 2: $(sum(length.(new_encoding.(lines))) - sum(length.(lines)))")
