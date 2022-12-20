from typing import Dict, Iterator, List, NamedTuple, Optional, Tuple


class Command(NamedTuple):
    direction: str
    iterations: int


class Position(NamedTuple):
    up: Optional["Position"]
    down: Optional["Position"]

    left: Optional["Position"]
    right: Optional["Position"]

    head: bool = False
    tail: bool = False
    visited: bool = False

    def move(self, direction: str) -> "Position":
        moved_to: Optional[Position] = None
        self.head = False
        match direction:
            case ["left"]:
                moved_to = self.left
            case ["right"]:
                moved_to = self.right
            case ["up"]:
                moved_to = self.up
            case ["down"]:
                moved_to = self.down

        moved_to.head = True

        return moved_to


def resolve(start_position: Position, data: Iterator[Command]) -> int:
    current_position = start_position
    for command in data:
        for _ in range(command.iterations):
            current_position = current_position.move(command.direction)
    return 0


def parse_raw_data(raw_data: str) -> Iterator[Command]:
    rows = list(map(lambda x: x.split(" "), filter(None, raw_data.split("\n"))))
    for direction, iterations in rows:
        yield Command(direction=direction, iterations=iterations)


def make_board(x: int, y: int, start: Tuple[int, int]) -> Optional[Position]:
    start_x, start_y = start
    positions: List[List[Position]] = [[[None]*6]*5]
    current_position: Optional[Position] = None
    for i in range(x):
        for j in range(y):
            head_tail = i == start_x and j == start_y
            current_position = Position(visited=True, head=head_tail, tail=head_tail)
            left = positions[i-1][j]
            up = positions[i][j-1]

            left.right = current_position
            up.down = current_position

            current_position.left = left
            current_position.up = up

            positions[i][j] = current_position
    return current_position


raw_data1 = """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"""


if __name__ == "__main__":
    parsed_data = parse_raw_data(raw_data=raw_data1)
    if start_position := make_board(6, 5):
        print(resolve(start_position, parsed_data))
