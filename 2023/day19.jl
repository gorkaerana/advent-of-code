const Rating = Dict{String, Integer}

struct Workflow
    name::String
    rules::Vector{String}
end

function parse_rating(rating::SubString{String})::Rating
    Dict(k => parse(Int, v) for (k, v) = split.(split(strip(rating, ['{', '}']), ','), '='))
end

function parse_workflow(workflow::SubString{String})
    name, rules = split(workflow, '{')
    Workflow(name, split(strip(rules, '}'), ','))
end


function parse_input(input)::Tuple{Dict{String, Workflow}, Vector{Rating}}
    workflows, ratings = split(input, "\n\n")
    Dict(w.name => w for w = workflows |> split .|> parse_workflow), ratings |> split .|> parse_rating
end

function does_rating_follow_rule(rating::Union{Rating, Dict{String, Int64}}, rule::SubString{String})
    if occursin('>', rule)
        category, amount = split(rule, '>')
        return rating[category] > parse(Int, amount)
    elseif occursin('<', rule)
        category, amount = split(rule, '<')
        return rating[category] < parse(Int, amount)
    end
end

function classify_rating(rating::Union{Rating, Dict{String, Int64}}, workflows::Dict{String, Workflow}, start_workflow::String="in")
    workflow_name = start_workflow
    while true
        ((workflow_name == "A") || (workflow_name == "R")) && break
        current_workflow = workflows[workflow_name]
        for rule = current_workflow.rules
            if occursin(':', rule)
                rule, destination = split(rule, ':')
                if does_rating_follow_rule(rating, rule)
                    workflow_name = destination
                    break
                end
            else
                workflow_name = rule
            end
        end
    end
    workflow_name
end

workflows, ratings = read("day19_small.txt", String) |> parse_input
sum_of_rating_numbers_for_accepted_parts = sum(sum(values(rating)) for rating = ratings if classify_rating(rating, workflows) == "A")
println("Part 1: $sum_of_rating_numbers_for_accepted_parts")
# Brute force
# sum(1 for x = 1:4000, m = 1:4000, a = 1:4000, s = 1:4000 if classify_rating(Dict("x" => x, "m" => m, "a" => a, "s" => s), workflows) == "A")

# Need to make the full tree and see which branches lead to "A"
