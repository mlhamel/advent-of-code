use std::collections::HashMap;
use lazy_static::lazy_static;

lazy_static! {
    static ref NUMBERS: HashMap<&'static str, i32> = {
        let mut map = HashMap::new();
        map.insert("zero", 0);
        map.insert("one", 1);
        map.insert("two", 2);
        map.insert("three", 3);
        map.insert("four", 4);
        map.insert("five", 5);
        map.insert("six", 6);
        map.insert("seven", 7);
        map.insert("eight", 8);
        map.insert("nine", 9);
        map
    };
}

pub fn first_1_0(content: std::string::String) -> Result<i32, i32> {
    println!("Day 1.0");

    Ok(content.lines().map( |line| {
        let parsed_num = line.chars().flat_map(
            |c| c.to_string().parse::<i32>()
        ).collect::<Vec<i32>>();

        let line_sum = format!("{:?}{:?}", parsed_num[0], parsed_num[parsed_num.len()-1]);

        let parsed_value = line_sum.parse::<i32>();

        match parsed_value {
            Ok(value) => value,
            Err(_) => 0
        }
    }).sum())
}

pub fn first_1_1(content: std::string::String) -> Result<i32, i32> {
    println!("Day 1.1");

    Ok(content.lines().map( |line| {
        let start = first_1_1_start(line).unwrap();
        let end = first_1_1_end(line).unwrap();
        let line_sum = format!("{:?}{:?}", start, end);
        let parsed_value = line_sum.parse::<i32>();

        match parsed_value {
            Ok(value) => value,
            Err(_) => 0
        }

    }).sum::<i32>())
}

fn first_1_1_start(line: &str) -> Result<i32, i32> {
    for i in 0..line.len() {
        let c = line.chars().nth(i).unwrap();

        let parsed_num = c.to_string().parse::<i32>();

        if parsed_num.is_ok() {
            let returned_value = parsed_num.unwrap();

            return Ok(returned_value);
        } else {
            let candidat = &line[0..i + 1];
            for (key, value) in NUMBERS.iter() {
                if candidat.contains(key) {
                    return Ok(*value);
                }
            }
        }
    }
    Ok(0)
}

fn first_1_1_end(line: &str) -> Result<i32, i32> {
    for i in (0..line.len()).rev() {
        let c = line.chars().nth(i).unwrap();
        let parsed_num = c.to_string().parse::<i32>();
        if parsed_num.is_ok() {
            return Ok(parsed_num.unwrap());
        } else {
            let candidat = &line[i..line.len()];
            for (key, value) in NUMBERS.iter() {
                if candidat.contains(key) {
                    return Ok(*value);
                }
            }
        }
    }
    Ok(0)
}