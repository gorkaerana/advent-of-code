from pathlib import Path
import re


def parse(problem, adjust=False):
    PATTERN = re.compile(
        r"""
    Button\s+A:\s+X\+(?P<x_A>\d+),\s+Y\+(?P<y_A>\d+)\n
    Button\s+B:\s+X\+(?P<x_B>\d+),\s+Y\+(?P<y_B>\d+)\n
    Prize:\s+X=(?P<x_P>\d+),\s+Y=(?P<y_P>\d+)
    """,
        flags=re.VERBOSE,
    )
    match = PATTERN.search(problem)
    values = [int(match[group]) for group in ["x_A", "x_B", "y_A", "y_B", "x_P", "y_P"]]
    if adjust:
        values[-1] += 10000000000000
        values[-2] += 10000000000000
    return values


def solve(cost_A, cost_B, x_A, x_B, y_A, y_B, x_P, y_P, tol = 1e-6):
    # This is an integer linear programming problem. Luckily, we have two
    # contraint equations for two variables, meaning there will be a single
    # solution--if any. Mathematically:
    # [[x_P], [y_P]] = [[x_A, x_B], [y_A, y_B]] @ [[a], [b]]
    # where
    # - (x_P, y_P) is the prize location,
    # - (x_A, y_A) is the vector describing the movement when pushing button A,
    # - (x_B, y_B) is the vector describing the movement when pushing button B,
    # - a is the amount of times button A ought to be pushed,
    # - b is the amount of times button B ought to be pushed.
    # We find solution by inverting [[x_A, x_B], [y_A, y_B]], which is analytically
    # solved, see
    # https://en.wikipedia.org/wiki/Invertible_matrix#Inversion_of_2_%C3%97_2_matrices
    determinant = x_A * y_B - x_B * y_A
    if determinant < tol:
        # If the determinant is zero, there is no solution
        return None
    a = ((y_B * x_P) + (-x_B * y_P)) / determinant
    b = ((-y_A * x_P) + (x_A * y_P)) / determinant
    if not ((abs(a - round(a)) < tol) and (abs(b - round(b)) < tol)):
        # If any of the solutions is not an integer, we ignore it
        return None
    return cost_A * a + cost_B * b


input_file = Path(__file__).parent / "input" / "day13.txt"
input_ = input_file.read_text()
problems = input_.split("\n\n")

print("Part 1:", sum(filter(None, (solve(3, 1, *parse(problem)) for problem in problems))))
print("Part 2:", sum(filter(None, (solve(3, 1, *parse(problem, adjust=True)) for problem in problems))))
