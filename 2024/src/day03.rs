use std::env;
use std::fs;

use regex::Regex;

pub fn main() {
    let input_path = env::current_dir()
        .expect("Could not get current directory")
        .join("input")
        .join("day03.txt");
    let input = fs::read_to_string(input_path).expect("Could not read input contents");
    let pattern = Regex::new(r"mul\((?<left>\d{1,3}),(?<right>\d{1,3})\)").unwrap();
    let part1_result: i32 = pattern
        .captures_iter(&input)
        .map(|capture| {
            let left: i32 = capture
                .name("left")
                .expect("Could not find capture group 'left'")
                .as_str()
                .parse::<i32>()
                .expect("Could not parse to integer");
            let right: i32 = capture
                .name("right")
                .expect("Could not find capture group 'right'")
                .as_str()
                .parse::<i32>()
                .expect("Could not parse to integer");
            (left, right)
        })
        .map(|(l, r)| l * r)
        .sum();
    println!("{}", "Day 3".to_owned());
    println!("Part 1: {}", part1_result);

    let pattern = Regex::new(
        r"mul\((?P<left>\d{1,3}),(?P<right>\d{1,3})\)|(?P<do>do\(\))|(?P<dont>don't\(\))",
    )
    .unwrap();
    let mut do_: bool = true;
    let mut part2_result = 0;
    for capture in pattern.captures_iter(&input) {
        if capture.name("do") != None {
            do_ = true;
            continue;
        };
        if capture.name("dont") != None {
            do_ = false;
            continue;
        };
        if do_ {
            let left: i32 = capture
                .name("left")
                .expect("Could not find capture group 'left'")
                .as_str()
                .parse::<i32>()
                .expect("Could not parse to integer");
            let right: i32 = capture
                .name("right")
                .expect("Could not find capture group 'right'")
                .as_str()
                .parse::<i32>()
                .expect("Could not parse to integer");
            part2_result += left * right
        };
    }
    println!("Part 2: {}", part2_result)
}
