struct Graph{T}
    nodes::Set{T}  # A.k.a. vertices, points
    edges::Dict{T, Vector{T}}  # A.k.a. links, lines
    weights::Dict{Tuple{T, T}, Float64}
end

function dijkstra(graph::Graph{T}, source::T) where {T}
    distances::Dict{T, Float64} = Dict()
    previous::Dict{T, Union{T, Nothing}} = Dict()
    q::Dict{T, T} = Dict()
    for node in graph.nodes
        distances[node] = Inf
        previous[node] = nothing
        q[node] = node
    end
    distances[source] = 0

    while !isempty(q)
        current_node = argmin(x -> distances[x], keys(q))
        pop!(q, current_node)
        for neighbour in get(graph.edges, current_node, [])
            alt = distances[current_node] + graph.weights[(current_node, neighbour)]
            if alt < distances[neighbour]
                distances[neighbour] = alt
                previous[neighbour] = current_node
            end
        end
    end
    return distances, previous
end

OrbitGraph = Graph{String}

function make_orbit_graph(filename::String, bidirectional::Bool)::OrbitGraph
    nodes::Vector{String} = []
    edges::Dict{String, Vector{String}} = Dict()
    weights::Dict{Tuple{String, String}, Float64} = Dict()
    for line in readlines(filename)
        focus, orbit = split(line, ")")
        push!(nodes, focus, orbit)
        for (source, target) in [(focus, orbit), (orbit, focus)]
            weights[(source, target)] = 1
            if isnothing(get(edges, source, nothing))
                edges[source] = [target]
            else
                push!(edges[source], target)
            end
            !bidirectional && break
        end
    end
    Graph{String}(Set(nodes), edges, weights)
end

function count_orbits(orbit_graph::OrbitGraph, planet::String, accumulator::Int64 = 0)::Int64
    # Base case
    isnothing(get(orbit_graph.edges, planet, nothing)) && return accumulator
    # Recursion
    total = accumulator
    for p in orbit_graph.edges[planet]
        total += count_orbits(orbit_graph, p, accumulator + 1)
    end
    total
end

n_orbits = count_orbits(make_orbit_graph("./input/day06.txt", false), "COM")
println("Part 1: $n_orbits")

distances, previous = dijkstra(make_orbit_graph("./input/day06.txt", true), "YOU")
n_orbital_transfers = distances["SAN"] - 2
println("Part 2: $n_orbital_transfers")
