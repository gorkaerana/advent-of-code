from collections import Counter
from dataclasses import dataclass
from functools import reduce
from itertools import count
from operator import mul
from pathlib import Path
import re
from time import sleep
from typing import NamedTuple


@dataclass
class Robot:
    x: int
    y: int
    vx: int
    vy: int

    @classmethod
    def parse(cls, line):
        PATTERN = re.compile(r"p=(?P<x>\d+),(?P<y>\d+) v=(?P<vx>\-?\d+),(?P<vy>\-?\d+)")
        match = PATTERN.match(line)
        return cls(*(int(match[g]) for g in ["x", "y", "vx", "vy"]))
    


class Map(NamedTuple):
    nrows: int
    ncols: int
    robots: list[Robot]

    def __repr__(self):
        p = self.positions
        rows = []
        for nrow in range(nrows):
            row = []
            for ncol in range(ncols):
                row.append(p.get((ncol, nrow), " "))
            rows.append("".join([*map(str, row), "\n"]))
        return "".join(rows)

    @property
    def positions(self):
        return Counter((r.x, r.y) for r in robots)

    def iteration(self):
        for robot in robots:
            robot.x += robot.vx
            robot.y += robot.vy
            if robot.x < 0:
                robot.x = ncols + robot.x
            if robot.y < 0:
                robot.y = nrows + robot.y
            if robot.x >= ncols:
                robot.x = (robot.x % ncols)
            if robot.y >= nrows:
                robot.y = (robot.y % nrows)

    def safety_factor(self):
        QUADRANTS = [
            # Top left
            ((0, ncols // 2), (0, nrows // 2)),
            # Top right
            ((0, ncols // 2), ((nrows // 2) + 1, nrows)),
            # Bottom left
            (((ncols // 2) + 1, ncols), (0, nrows // 2)),
            # Bottom right
            (((ncols // 2) + 1, ncols), ((nrows // 2) + 1, nrows)),
        ]
        p = self.positions
        nrobots_per_quadrant = [
            sum(
                c
                for (x, y), c in p.items()
                if (lx <= x < ux) and (ly <= y < uy)
            )
            for (lx, ux), (ly, uy) in QUADRANTS
        ]
        return reduce(mul, nrobots_per_quadrant)

    def potential_base(self, n=5):
        p = self.positions
        for row in range(self.nrows):
            for col in range(0, self.ncols, n):
                if all(p[(j, row)] > 0 for j in range(col, col + n)):
                    return True
        return False
                


input_file = Path(__file__).parent / "input" / "day14.txt"
input_ = input_file.read_text()
nrows, ncols = 103, 101  # 7, 11


robots = list(map(Robot.parse, input_.splitlines()))
map_ = Map(nrows, ncols, robots)
for i in range(100):
    map_.iteration()
print("Part 1:", map_.safety_factor())


robots = list(map(Robot.parse, input_.splitlines()))
map_ = Map(nrows, ncols, robots)
pfor i in count(1):
    map_.iteration()
    if map_.potential_base():
        print(map_)
        print(i)
