use std::env;
use std::fs;

fn first(content: std::string::String) {
    let mut sum = 0;
    for line in content.lines() {
        let parsed_num = line.chars().flat_map(
            |c| c.to_string().parse::<i32>()
        ).collect::<Vec<i32>>();

        let line_sum = format!("{:?}{:?}", parsed_num[0], parsed_num[parsed_num.len()-1]);

        sum += line_sum.parse::<i32>().unwrap();
    }
    println!("Sum: {:?}", sum);
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let day: &String = &args[1]; // day
    let input: &String = &args[2]; // input

    let contents = fs::read_to_string(input)
        .expect("Should have been able to read the file");

    println!("Day: {:?}", day);
    println!("Input: {:?}", input);
    println!("Contents: {:?}", contents);

    let day_num = day.as_str().parse::<u32>().unwrap();

    match day_num {
        1 => first(contents),
        _ => println!("Not implemented yet"),
    }
}
