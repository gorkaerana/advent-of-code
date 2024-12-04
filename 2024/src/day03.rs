use std::env;
use std::fs;

use regex::{Captures, Regex};

fn extract_capture_groups<'a>(captures: Captures<'a>, names: Vec<&'a str>) -> Vec<i32> {
    names
        .iter()
        .map(|n| {
            captures
                .name(n)
		.unwrap()
                .as_str()
                .parse::<i32>()
		.unwrap()
        })
        .collect::<Vec<i32>>()
}

pub fn main() {
    let input_path = env::current_dir()
	.unwrap()
        .join("input")
        .join("day03.txt");
    let input = fs::read_to_string(input_path).unwrap();
    let part1_pattern = Regex::new(r"mul\((?<left>\d{1,3}),(?<right>\d{1,3})\)").unwrap();
    let part1_result: i32 = part1_pattern
        .captures_iter(&input)
        .map(|captures| extract_capture_groups(captures, vec!["left", "right"]))
        .map(|v| v.into_iter().reduce(|a, b| a * b).unwrap())
        .sum();
    println!("{}", "Day 3".to_owned());
    println!("Part 1: {:?}", part1_result);

    let part2_pattern = Regex::new(
        r"mul\((?P<left>\d{1,3}),(?P<right>\d{1,3})\)|(?P<do>do\(\))|(?P<dont>don't\(\))",
    )
    .unwrap();
    let mut do_: bool = true;
    let mut part2_result = 0;
    for captures in part2_pattern.captures_iter(&input) {
        if captures.name("do") != None {
            do_ = true;
            continue;
        };
        if captures.name("dont") != None {
            do_ = false;
            continue;
        };
        if do_ {
            part2_result += extract_capture_groups(captures, vec!["left", "right"])
                .into_iter()
                .reduce(|a, b| a * b)
                .unwrap();
        };
    }
    println!("Part 2: {}", part2_result)
}
