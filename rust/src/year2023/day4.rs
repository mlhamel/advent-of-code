use regex::Regex;

use std::collections::HashSet;

struct Day4 {
    content: String,
    points: Vec<i32>,
    lines_vect: Vec<String>,
}

impl Day4 {
    fn new(content: String) -> Day4 {
        let cloned_content = content.clone();
        let line_count = cloned_content.lines().count();
        let new_lines_vect: Vec<String> = cloned_content
            .lines()
            .collect::<Vec<&str>>()
            .iter()
            .map(|line| line.to_string())
            .collect::<Vec<String>>();

        Day4{
            content: cloned_content,
            points: vec![0; line_count],
            lines_vect: new_lines_vect,
        }
    }

    pub fn get_points(&self) -> i32 {
        return self.content.lines().map(|line| {
            calculate_points(line)
        }).sum();
    }

    pub fn get_winning_cards(&mut self) -> i32 {
        let length = self.lines_vect.len();

        for index in 0..length  {
            self.calculate_winning_cards(length-index-1);
        }
        return self.points.iter().sum();
    }

    fn calculate_winning_cards(&mut self, index: usize) {
        let line: &str = self.lines_vect.get(index).unwrap();

        Regex::new(r"Card([\s\d]*): ([\d\s]*)\|([\d\s]*)$")
            .unwrap()
            .captures(line)
            .map(|cap| {
                let raw_winnger_numbers = cap.get(2).unwrap().as_str().split_whitespace();
                let raw_numbers = cap.get(3).unwrap().as_str().split_whitespace();

                let winning_numbers: HashSet<i32> = HashSet::from_iter(raw_winnger_numbers.map(|n| n.trim().parse::<i32>().unwrap()));
                let numbers: HashSet<i32> = HashSet::from_iter(raw_numbers.map(|f| f.trim().parse::<i32>().unwrap()));

                let power = numbers.intersection(&winning_numbers).count() as i32;

                self.points[index] += 1;

                for x in 1..power+1 {
                    if index + x as usize <= self.points.len() {
                        self.points[index] += self.points[index+x as usize];
                    }
                }
            });
    }
}


pub fn four_1_0(content: String) -> Result<i32, i32> {
    let day4 = Day4::new(content);
    return Ok(day4.get_points());
}

pub fn four_1_1(content: String) -> Result<i32, i32> {
    let mut day4 = Day4::new(content);
    return Ok(day4.get_winning_cards());
}


fn calculate_points(line: &str) -> i32 {
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