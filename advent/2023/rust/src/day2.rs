use regex::Regex;

struct Colors {
    pub red: i32,
    pub green: i32,
    pub blue: i32,
}

pub fn second_1_1(content: String) -> Result<i32, i32> {
    println!("Day 2.1");

    let re = Regex::new(r"([0-9]+)\s(blue|red|green)([,;\s]|$)").unwrap();

    let color_sum = content.split("\n").map(|line| {
        let mut max_colors = Colors {
            red: 0,
            green: 0,
            blue: 0,
        };

        for set in line.split(";") {
            for cap in re.captures_iter(set) {
                let number = cap[1].parse::<i32>().unwrap();
                let color = &cap[2];

                match color {
                    "red" => {
                        if max_colors.red < number {
                            max_colors.red = number;
                        }
                    },
                    "green" => {
                        if max_colors.green < number {
                            max_colors.green = number;
                        }
                    },
                    "blue" => {
                        if max_colors.blue < number {
                            max_colors.blue = number;
                        }
                    },
                    _ => {}
                }
            }
        }

        max_colors.red * max_colors.green * max_colors.blue
    }).sum::<i32>();

    Ok(color_sum)
}

pub fn second_1_0(
    content: String,
    parameters: String
) -> Result<i32, i32> {
    println!("Day 2.0");

    let parsed_parameter = parameters.split(",").map(|parameter| {
        let parameter = parameter.trim();
        let parameter = parameter.parse::<i32>();

        match parameter {
            Ok(value) => value,
            Err(_) => 0
        }
    }).collect::<Vec<i32>>();

    let requested_colors = Colors {
        red: parsed_parameter[0],
        green: parsed_parameter[1],
        blue: parsed_parameter[2],
    };

    let re_game_number = Regex::new(r"Game ([0-9]+)").unwrap();
    let re = Regex::new(r"([0-9]+)\s(blue|red|green)([,;\s]|$)").unwrap();

    let color_sum = content.split("\n").map(|line| {
        let mut game_number = 0;

        if let Some(cap) = re_game_number.captures(line) {
            game_number = cap[1].parse::<i32>().unwrap();
        }

        for set in line.split(";") {
            let mut line_colors = Colors {
                red: 0,
                green: 0,
                blue: 0,
            };

            for cap in re.captures_iter(set) {
                let number = cap[1].parse::<i32>().unwrap();
                let color = &cap[2];

                match color {
                    "red" => {
                        line_colors.red += number;
                    },
                    "green" => {
                        line_colors.green += number;
                    },
                    "blue" => {
                        line_colors.blue += number;
                    },
                    _ => {}
                }
            }

            if line_colors.red > requested_colors.red || line_colors.green > requested_colors.green || line_colors.blue > requested_colors.blue {
                return 0;
            }
        }

        game_number
    }).sum::<i32>();

    Ok(color_sum)
}