use std::env;
use std::collections::HashMap;
use std::fs::File;
use std::io::{BufReader, BufRead};

pub fn main() {
    let input_path = env::current_dir()
	.expect("Could not get current directory")
	.join("input")
	.join("day01.txt");
    let file = File::open(input_path);
    let reader = BufReader::new(file.unwrap());

    let mut lefts: Vec<i32> = Vec::new();
    let mut rights: Vec<i32>  = Vec::new();
    for line in reader.lines() {
	match line {
	    Ok(content) => {
		let parts: Vec<&str> = content.split("   ").collect();
		lefts.push(parts[0].parse::<i32>().expect("Failure"));
		rights.push(parts[1].parse::<i32>().expect("Failure"));
	    },
	    Err(error) => eprintln!("Failure: {}", error)
	}
    }
    lefts.sort();
    rights.sort();
    println!("{}", "Day 1".to_owned());
    println!("Part 1: {}", lefts.iter().zip(rights.clone()).map(|(l, r)| (l - r).abs()).sum::<i32>());

    let mut right_counts = HashMap::<i32, i32>::new();
    for r in rights.iter() {
	*right_counts.entry(*r).or_insert(0) += 1;
    }
    println!("Part 2: {}", lefts.iter().map(|l| {l * *right_counts.entry(*l).or_default()}).sum::<i32>());
}
