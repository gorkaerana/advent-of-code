use std::env;
use std::fs::File;
use std::io::{BufRead, BufReader};

type Row = Vec<char>;
type WordSearch = Vec<Row>;

fn reverse(s: String) -> String {
    s.chars()
        .rev()
        .map(|c| c.to_string())
        .collect::<Vec<String>>()
        .join("")
}

fn count_word_occurrences(word_search: WordSearch, word: String) -> i32 {
    let mut n_occurrences: i32 = 0;
    // Horizontal matches
    for row_no in 0..word_search.len() {
        for col_no in 0..(word_search[0].len() - word.len() + 1) {
            let v: String = (0..word.len())
                .map(|i| word_search[row_no][col_no + i].to_string())
                .collect::<Vec<_>>()
                .join("");

            if (v == word) || (reverse(v) == word) {
                n_occurrences += 1;
            }
        }
    }
    // Vertical matches
    for row_no in 0..(word_search.len() - word.len() + 1) {
        for col_no in 0..(word_search[0].len()) {
            let v: String = (0..word.len())
                .map(|i| word_search[row_no + i][col_no].to_string())
                .collect::<Vec<_>>()
                .join("");
            if (v == word) || (reverse(v) == word) {
                n_occurrences += 1;
            }
        }
    }
    // Left-to-right diagonal matches
    for row_no in 0..(word_search.len() - word.len() + 1) {
        for col_no in 0..(word_search[0].len() - word.len() + 1) {
            let v: String = (0..word.len())
                .map(|i| word_search[row_no + i][col_no + i].to_string())
                .collect::<Vec<_>>()
                .join("");
            if (v == word) || (reverse(v) == word) {
                n_occurrences += 1;
            }
        }
    }
    // Right-to-left diagonal matches
    for row_no in 0..(word_search.len() - word.len() + 1) {
        for col_no in (word.len() - 1)..word_search[0].len() {
            let v: String = (0..word.len())
                .map(|i| word_search[row_no + i][col_no - i].to_string())
                .collect::<Vec<_>>()
                .join("");
            if (v == word) || (reverse(v) == word) {
                n_occurrences += 1;
            }
        }
    }
    n_occurrences
}

fn count_word_crosses(word_search: WordSearch, word: String) -> i32 {
    let mut n_occurrences = 0;
    for row_no in 0..(word_search.len() - word.len() + 1) {
        for col_no in 0..(word_search[0].len() - word.len() + 1) {
            let mut square: WordSearch = Vec::new();
            for r in 0..word.len() {
                let mut row: Row = Vec::new();
                for c in 0..word.len() {
                    row.push(word_search[row_no + r][col_no + c])
                }
                square.push(row)
            }
            let diag1: String = (0..square.len())
                .map(|i| square[i][i].to_string())
                .collect::<Vec<String>>()
                .join("");
            let diag2: String = (0..square.len())
                .map(|i| square[i][word.len() - i - 1].to_string())
                .collect::<Vec<String>>()
                .join("");
            if ((diag1.clone() == word) && (diag2.clone() == word))
                || ((reverse(diag1.clone()) == word) && (diag2.clone() == word))
                || ((diag1.clone() == word) && (reverse(diag2.clone()) == word))
                || ((reverse(diag1.clone()) == word) && (reverse(diag2.clone()) == word))
            {
                n_occurrences += 1;
            }
        }
    }
    n_occurrences
}

pub fn main() {
    let input_path = env::current_dir().unwrap().join("input").join("day04.txt");
    let file = File::open(input_path);
    let reader = BufReader::new(file.unwrap());
    let input_: WordSearch = reader
        .lines()
        .map(|l| l.unwrap().chars().collect::<Row>())
        .collect();
    println!("{}", "Day 4".to_owned());
    println!(
        "Part 1: {}",
        count_word_occurrences(input_.clone(), "XMAS".to_owned())
    );
    println!(
        "Part 2: {}",
        count_word_crosses(input_.clone(), "MAS".to_owned())
    );
}
