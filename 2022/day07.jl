using Base.Iterators: countfrom

struct File
    name::String
    size::Integer
end

struct Directory
    name::String
    files::Vector{File}
    dirs::Vector{Directory}
end

size(f::File) = f.size
size(d::Directory) = sum(size.(d.files), init=0) + sum(size.(d.dirs), init=0)

function parse_directory_tree(lines::Vector{String})
    dir_tree::Dict{String, Union{Directory, File}} = Dict()
    current_dir_name::Union{String, Nothing} = nothing
    line_no = 1
    while line_no < length(lines)
        line = lines[line_no]
        if startswith(line, "\$ cd")
            _, dir_name = split(strip(strip(line, ['\$'])))
            if dir_name == ".."
                for v in values(dir_tree)
                    if (typeof(v) == Directory) && any(d.name == current_dir_name for d = v.dirs)
                        current_dir_name = v.name
                        break
                    end
                end
            else
                d = Directory(dir_name, [], [])
                !isnothing(current_dir_name) && push!(dir_tree[current_dir_name].dirs, d)
                dir_tree[dir_name] = d
                current_dir_name = dir_name
            end
        elseif startswith(line, "\$ ls")
            for next_line_no = countfrom(line_no + 1)
                (next_line_no > length(lines)) && break
                next_line = lines[next_line_no]
                startswith(next_line, "\$ ") && break
                if startswith(next_line, "dir")
                    push!(dir_tree[current_dir_name].dirs, Directory(split(next_line)[2], [], []))
                else
                    size, name = split(next_line)
                    push!(dir_tree[current_dir_name].files, File(name, parse(Int, size)))
                end
            end
        end
        line_no += 1
    end
    dir_tree
end

directory_tree = "input/day07.txt" |> readlines |> parse_directory_tree
display(directory_tree)
# println(sum(size(v) for v in values(directory_tree) if size(v) <= 100000))
