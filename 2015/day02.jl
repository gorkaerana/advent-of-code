using Pipe: @pipe

include("../utils.jl")
using .Utils: read_input

smallest_n(a, n) = sort(a; alg=Base.Sort.PartialQuickSort(n))[1:n]

surface(l, w, h) = 2*l*w + 2*w*h + 2*h*l

extra(l, w, h) = prod(smallest_n([l, w, h], 2))

wrapping_paper(l, w, h) = surface(l, w, h) + extra(l, w, h)

smallest_perimeter(l, w, h) = 2 * sum(smallest_n([l, w, h], 2))

volume(l, w, h) = prod([l, w, h])

ribbon(l, w, h) = smallest_perimeter(l, w, h) + volume(l, w, h)

dimension_tuples = @pipe read_input(@__FILE__) |>
    split.(_, "x") |>
    map(t -> parse.(Int, t), _)


@pipe dimension_tuples |>
    map(t -> wrapping_paper(t...), _) |>
    sum |>
    print("Part one: ", _, "\n")

@pipe dimension_tuples |>
    map(t -> ribbon(t...), _) |>
    sum |>
    print("Part two: ", _, "\n")
