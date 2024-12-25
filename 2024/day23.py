# /// script
# dependencies = [
#     "networkx==3.4.2",
#     "matplotlib"
# ]
# ///


from pathlib import Path
from pprint import pprint

import networkx as nx
import matplotlib.pyplot as plt

input_file = Path(__file__).parent / "input" / "day23.txt"
input_ = input_file.read_text()
graph = nx.Graph()
graph.add_edges_from(
    line.split("-") for line in input_.splitlines()
)

part1 = sum(
    1
    for cycle in nx.simple_cycles(graph, length_bound=3)
    if any(node.startswith("t") for node in cycle) and (len(cycle) == 3)
)
print(f"Part 1: {part1}")

part2 = ",".join(sorted(max(nx.enumerate_all_cliques(graph), key=len)))
print(f"Part 2: {part2}")
