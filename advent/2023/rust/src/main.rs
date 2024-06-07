use std::env;
use std::fs;

pub mod day1;
pub mod day2;
pub mod day3;
pub mod day4;

fn main() {
    let args: Vec<String> = env::args().collect();
    let day: &String = &args[1]; // day
    let input: &String = &args[2]; // input
    let parameters: &Option<&String> = &args.get(3); // parameters

    let contents = fs::read_to_string(input)
        .expect("Should have been able to read the file");

    let parsed_parameters: String = parameters
        .unwrap_or(&String::from(""))
        .to_string();

    println!("Day: {:?}", day);
    println!("Input: {:?}", input);
    println!("Contents: {:?}", contents);

    let day_num = day.as_str();

    let value = match day_num {
        "1.0" => day1::first_1_0(contents),
        "1.1" => day1::first_1_1(contents),
        "2.0" => day2::second_1_0(contents, parsed_parameters),
        "2.1" => day2::second_1_1(contents),
        "3.0" => day3::third_1_0(contents),
        "3.1" => day3::third_1_1(contents),
        "4.0" => day4::four_1_0(contents),
        _ => Err(-1)
    };

    println!("Value: {:?}", value.unwrap());
}
