use regex::Regex;

use std::{collections::HashSet, str::Lines};

struct Day4 {
    content: String,
    counter: i32,
    points: Vec<i32>,
}

impl Day4 {
    fn new(content: String) -> Day4 {
        let line_count = content.lines().count();
        Day4{
            content: content,
            counter: 0,
            points: vec![0; line_count],
        }
    }

    pub fn get_points(&self) -> i32 {
        return self.content.lines().map(|line| {
            calculate_points(line)
        }).sum();
    }

    pub fn get_winning_cards(&mut self) -> i32 {
        let cloned_content = self.content.clone();
        let lines_vect: Vec<&str> = cloned_content.lines().collect();
        let length = lines_vect.len();
        for index in 0..length  {
            let cloned_content = self.content.clone();
            self.calculate_winning_cards(&cloned_content.lines().collect::<Vec<&str>>(), length-index-1);
        }
        return self.points.iter().sum();
    }

    fn calculate_winning_cards(&mut self, lines_vect: &Vec<&str>, index: usize) {
        /*
         * Card 1: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 | 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
         * Card 2: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 | 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
         * Card 3: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 | 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
         * Card 4: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 | 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
         *             7 6
         *            4 5
         *             3
         *             2
         */
        println!("Index: {:?}", index);
        let line: &str = lines_vect.get(index).unwrap();

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
                        println!("power: {:?} -> {:?}", index+x as usize, self.points[index+x as usize]);
                        self.points[index] += self.points[index+x as usize];
                    }
                }
                println!("Points: {:?} -> {:?}", self.points, power);
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