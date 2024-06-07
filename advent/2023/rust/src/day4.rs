use regex::Regex;

use std::collections::HashSet;

struct Day4 {
    content: String,
}

impl Day4 {
    fn new(content: String) -> Day4 {
        Day4{
            content: content,
        }
    }

    pub fn run(&self) -> i32 {
        return self.content.lines().map(|line| {
            parse_line(line)
        }).sum();
    }
}


pub fn four_1_0(content: String) -> Result<i32, i32> {
    let day4 = Day4::new(content);
    return Ok(day4.run());
}


fn parse_line(line: &str) -> i32 {
    let parsed_line = Regex::new(r"Card[\s\d]*: ([\d\s]*)\|([\d\s]*)$")
        .unwrap()
        .captures(line)
        .map(|cap| {
            let raw_winnger_numbers = cap.get(1).unwrap().as_str().split_whitespace();
            let raw_numbers = cap.get(2).unwrap().as_str().split_whitespace();

            let winning_numbers: HashSet<i32> = HashSet::from_iter(raw_winnger_numbers.map(|n| n.trim().parse::<i32>().unwrap()));
            let numbers: HashSet<i32> = HashSet::from_iter(raw_numbers.map(|f| f.trim().parse::<i32>().unwrap()));

            let base: i32 = 2;

            let power = numbers.intersection(&winning_numbers).count() as u32;
            let mut value = 0;

            if power >= 1 {
                value = base.pow(power-1);
            }

            return value;
        });

    return match parsed_line {
        Some(score) => score,
        None => 0,

    }
}