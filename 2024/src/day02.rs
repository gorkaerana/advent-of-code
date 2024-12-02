use std::env;
use std::fs::File;
use std::io::{BufReader, BufRead};

type Level = i32;
type Report = Vec<Level>;

fn is_report_safe(report: Report) -> bool {
    let pairwise = report.iter().cloned().zip(&report[1..]);
    let all_decreasing = pairwise
	.clone()
	.all(|(c, n)| {
	    let diff: i32 = (c - n).abs();
	    (c >= *n) && (1 <= diff) && (diff <= 3)
	});
    let all_increasing = pairwise
	.clone()
	.all(|(c, n)| {
	    let diff: i32 = (c - n).abs();
	    (c <= *n) && (1 <= diff) && (diff <= 3)
	});
    all_decreasing || all_increasing
}

fn problem_dampener(report: Report) -> bool {
    report
	.iter()
	.cloned()
	.enumerate()
	.any(
	    |(index, _value)| {
		let dampened: Report = report.iter().cloned()
		    .enumerate()
		    .filter(|(i, _v)| { *i != index })
		    .map(|(_i, v)| { v })
		    .collect::<Report>();
		is_report_safe(dampened)
	    }
	)
}

pub fn main() {
    let input_path = env::current_dir()
	.expect("Could not get current directory")
	.join("input")
	.join("day02.txt");
    let file = File::open(input_path);
    let reader = BufReader::new(file.unwrap());

    let mut reports: Vec<Report> = Vec::new();
    for line in reader.lines() {
	match line {
	    Ok(content) => {
		let report: Vec<Level> = content.split(" ").map(|e| {e.parse::<i32>()}.expect("Failure")).collect();
		reports.push(report)
	    },
	    Err(error) => eprintln!("Failure: {}", error)
	}
    }    
    println!("{}", "Day 2".to_owned());
    println!("Part 1: {}", reports.iter().map(|r: &Report| {is_report_safe(r.clone())}).map(|b| {b as i32}).sum::<i32>());
    println!("Part 2: {}", reports.iter().map(|r: &Report| {problem_dampener(r.clone())}).map(|b| {b as i32}).sum::<i32>())
}
