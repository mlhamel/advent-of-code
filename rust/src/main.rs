use std::env;
use std::fs;

pub mod year2023;
pub mod year2024;

fn main() {
    let args: Vec<String> = env::args().collect();
    let year: &String = &args[1]; // year
    let day: &String = &args[2]; // day
    let input: &String = &args[3]; // input
    let parameters: &Option<&String> = &args.get(4); // parameters

    let contents = fs::read_to_string(input)
        .expect("Should have been able to read the file");

    let parsed_parameters: String = parameters
        .unwrap_or(&String::from(""))
        .to_string();

    println!("Year: {:?}", year);
    println!("Day: {:?}", day);
    println!("Input: {:?}", input);
    println!("Contents: {:?}", contents);

    let value = match (year.as_str(), day.as_str()) {
        ("2023", "1.0") => year2023::day1::first_1_0(contents),
        ("2023", "1.1") => year2023::day1::first_1_1(contents),
        ("2023", "2.0") => year2023::day2::second_1_0(contents, parsed_parameters),
        ("2023", "2.1") => year2023::day2::second_1_1(contents),
        ("2023", "3.0") => year2023::day3::third_1_0(contents),
        ("2023", "3.1") => year2023::day3::third_1_1(contents),
        ("2023", "4.0") => year2023::day4::four_1_0(contents),
        ("2023", "4.1") => year2023::day4::four_1_1(contents),
        // Add 2024 matches here as needed
        _ => Err(-1)
    };

    println!("Value: {:?}", value.unwrap());
}
