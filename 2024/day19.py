from functools import cache
from pathlib import Path


@cache
def n_solutions(design, patterns):
    if design == "":
        return 1
    return sum(
        n_solutions(design[len(pattern):], patterns)
        for pattern in patterns
        if design.startswith(pattern)
    )


input_file = Path(__file__).parent / "input" / "day19.txt"
input_ = input_file.read_text()
patterns, designs = input_.split("\n\n")
patterns = tuple(patterns.split(", "))
designs = designs.split()

print("Part 1:", sum(n_solutions(d, patterns) > 0 for d in designs))
print("Part 2:", sum(n_solutions(d, patterns) for d in designs))
