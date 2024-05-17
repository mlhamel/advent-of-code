use std::env;
use std::fs;

pub mod day1;
pub mod day2;

fn main() {
    let args: Vec<String> = env::args().collect();
    let day: &String = &args[1]; // day
    let input: &String = &args[2]; // input

    let contents = fs::read_to_string(input)
        .expect("Should have been able to read the file");

    println!("Day: {:?}", day);
    println!("Input: {:?}", input);
    println!("Contents: {:?}", contents);

    let day_num = day.as_str();

    let value = match day_num {
        "1.0" => day1::first_1_0(contents),
        "1.1" => day1::first_1_1(contents),
        "2.0" => day2::second_1_0(contents),
        _ => Err(-1)
    };

    println!("Value: {:?}", value.unwrap());
}
