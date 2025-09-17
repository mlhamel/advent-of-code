use std::{collections::HashMap, num::ParseIntError};

use regex::Regex;

struct Day3 {
    numbers: HashMap<(i32, i32), Box<Number>>,
    re_for_numbers: Regex,
    re_for_symbols: Regex,
    re_for_gears: Regex,
}

impl Day3 {
    fn new() -> Day3 {
        Day3 {
            numbers: HashMap::new(),
            re_for_numbers: Regex::new(r"[0-9]").unwrap(),
            re_for_symbols: Regex::new(r"[^\d\s.]").unwrap(),
            re_for_gears: Regex::new(r"[\*]").unwrap(),
        }
    }

    pub fn new_from_content(content: String) -> Day3 {
        let mut day3 = Day3::new();

        for (line_index, line) in content.split("\n").enumerate() {
            let mut number: Option<Number> = None;

            for (index, c) in line.chars().enumerate() {
                if day3.re_for_numbers.is_match(&c.to_string()) {
                    if number.is_none() {
                        number = Some(Number::new());
                    }
                    if let Some(num) = number.as_mut() {
                        num.insert_value(c, index as i32).unwrap();
                    }
                }
                else {
                    if !number.is_none() {
                        let number_pointer = Box::new(number.unwrap());
                        day3.numbers.insert((index as i32, line_index as i32), number_pointer);
                    }
                    number = None;
                }
            }

            if !number.is_none() {
                day3.numbers.insert((line.len() as i32, line_index as i32), Box::new(number.unwrap()));
            }
        }
        day3
    }


    pub fn intersection_with_symbols(&mut self, content: String) -> Vec<i32> {
        let mut matches: Vec<i32> = Vec::new();

        for (line_index, line) in content.split("\n").enumerate() {
            for (index, c) in line.chars().enumerate() {
                if self.re_for_symbols.is_match(&c.to_string()) {
                    let mut posibilities: Vec<(usize, usize)> = Vec::new();

                    if index > 0 {
                        posibilities.push((index - 1, line_index));
                        posibilities.push((index - 1, line_index + 1));
                        if line_index > 0 {
                            posibilities.push((index - 1, line_index - 1));
                        }
                    }
                    if line_index > 0 {
                        posibilities.push((index, line_index - 1));
                        posibilities.push((index + 1, line_index - 1));
                    }
                    posibilities.push((index + 1, line_index));
                    posibilities.push((index, line_index + 1));
                    posibilities.push((index + 1, line_index + 1));

                    for (x, y) in posibilities {
                        let mut to_delete: Vec<(i32, i32)> = Vec::new();
                        for (k, v) in self.numbers.iter() {
                            if k.1 == y as i32 && v.indexes.iter().find(|i| **i == x as i32).is_some() {
                                matches.push(v.value.iter().map(|i| i.to_string()).collect::<Vec<String>>().join("").parse::<i32>().unwrap());
                                to_delete.push((k.0, k.1));
                            }
                        }
                        for k in to_delete {
                            self.numbers.remove(&k);
                        }
                    }
                }
            }
        }

        return matches;
    }

    pub fn gears_intersection_with_symbols(&mut self, content: String) -> Vec<i32> {
        let mut matches: Vec<i32> = Vec::new();

        for (line_index, line) in content.split("\n").enumerate() {
            for (index, c) in line.chars().enumerate() {
                if self.re_for_gears.is_match(&c.to_string()) {
                    let mut values_on_line: Vec<i32> = Vec::new();
                    let mut posibilities: Vec<(usize, usize)> = Vec::new();
                    let mut busted: bool = false;

                    if index > 0 {
                        posibilities.push((index - 1, line_index));
                        posibilities.push((index - 1, line_index + 1));
                        if line_index > 0 {
                            posibilities.push((index - 1, line_index - 1));
                        }
                    }
                    if line_index > 0 {
                        posibilities.push((index, line_index - 1));
                        posibilities.push((index + 1, line_index - 1));
                    }
                    posibilities.push((index + 1, line_index));
                    posibilities.push((index, line_index + 1));
                    posibilities.push((index + 1, line_index + 1));

                    for (x, y) in posibilities {
                        let mut to_delete: Vec<(i32, i32)> = Vec::new();
                        for (k, v) in self.numbers.iter() {
                            if k.1 == y as i32 && v.indexes.iter().find(|i| **i == x as i32).is_some() {
                                if values_on_line.len() == 2 {
                                    busted = true;
                                    break;
                                }

                                let value = v.value
                                    .iter()
                                    .map(|i| i.to_string())
                                    .collect::<Vec<String>>()
                                    .join("")
                                    .parse::<i32>()
                                    .unwrap();

                                values_on_line.push(value);
                                to_delete.push((k.0, k.1));
                            }
                        }
                        if !busted {
                            for k in to_delete {
                                self.numbers.remove(&k);
                            }
                        }
                    }

                    if !busted && values_on_line.len() == 2 {
                        let result = values_on_line[0] * values_on_line[1];
                        matches.push(result);
                    }
                }
            }
        }
        return matches;
    }
}




struct Number {
    pub value: Vec<i32>,
    pub indexes: Vec<i32>,
}

impl Number {
    fn new() -> Number {
        Number {
            value: Vec::new(),
            indexes: Vec::new(),
        }
    }

    fn insert_value(&mut self, value: char, index: i32) -> Result<(), ParseIntError> {
        match value.to_string().parse::<i32>() {
            Ok(v) => {
                self.value.push(v);
                self.indexes.push(index);
                Ok(())
            },
            Err(e) => {
                Err(e)
            }
        }
    }
}

pub fn third_1_0(content: String) -> Result<i32, i32> {
    println!("Day 3.0");

    let mut day3 = Day3::new_from_content(content.clone());
    let numbers = day3.intersection_with_symbols(content);

    Ok(numbers.iter().sum())
}


pub fn third_1_1(content: String) -> Result<i32, i32> {
    println!("Day 3.1");

    let mut day3 = Day3::new_from_content(content.clone());
    let numbers = day3.gears_intersection_with_symbols(content);

    Ok(numbers.iter().sum())
}
