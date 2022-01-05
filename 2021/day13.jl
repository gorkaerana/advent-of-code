using Pipe: @pipe

function process_input(filepath)
    positions, instructions = @pipe filepath |>
        read(_, String) |>
        split(_, "\n\n")
    # Dotted paper is boolean matrix
    positions = @pipe positions |>
        split(_, "\n") |>
        split.(_, ",") |>
        map(t -> parse.(Int, t), _)
    paper = @pipe positions |>
        [maximum(map(t->t[i], _)) for i = 1:length(positions[1])] |>
        _ .+ 1 |>
        zeros(Bool, _[2], _[1])
    for (j, i) in positions
        paper[i+1, j+1] = 1
    end
    # Instructions are (axis, index) tuples
    instructions = @pipe instructions |>
        strip(_) |>
        split(_, "\n") |>
        split.(_, " ") |>
        map(t -> t[end], _) |>
        split.(_, "=") |>
        map(t -> [t[1], parse(Int, t[end])+1], _)
    paper, instructions
end

function fold(paper, axis, index)
    nrows, ncols = size(paper)
    if axis == "x"
        # Vertical fold
        new_paper = zeros(Bool, nrows, index)
        new_nrows, new_ncols = size(new_paper)
        # Copy information from non-folded paper
        for i = 1:new_nrows, j = 1:new_ncols
            new_paper[i, j] = paper[i, j]
        end
        # Actual fold
        for i = 1:new_nrows, j = new_ncols:ncols
            v = paper[i, j]
            if v == 1
                new_paper[i, new_ncols - (j - new_ncols)] = v
            end
        end
        new_paper = new_paper[:, 1:end-1]
    elseif axis == "y"
        # Horizontal fold
        new_paper = zeros(Bool, index, ncols)
        new_nrows, new_ncols = size(new_paper)
        # Copy information from non-folded paper
        for i = 1:new_nrows, j = 1:new_ncols
            new_paper[i, j] = paper[i, j]
        end
        # Actual fold
        for i = new_nrows:nrows, j = 1:new_ncols
            v = paper[i, j]
            if v == 1
                new_paper[new_nrows - (i - new_nrows), j] = v
            end
        end
        new_paper = new_paper[1:end-1, :]
    end
    new_paper
end

function beautiful_display(boolean_matrix)
    nrows, ncols = size(boolean_matrix)
    for i = 1:nrows
        @pipe boolean_matrix[i, :] |>
            [_[j] == 1 ? "#" : "." for j = 1:ncols] |>
            join(_, "") |>
            print(_, "\n")
    end
end

let
    paper, instructions = @pipe joinpath(@__DIR__, "input", "day13.txt") |>
        process_input(_)
    first_fold = true
    for (axis, index) in instructions
        paper = fold(paper, axis, index)
        if first_fold
            first_fold = false
            print("Part 1: ", sum(paper), ".\n")
        end
    end
    print("Part 2:\n")
    beautiful_display(paper)
end
