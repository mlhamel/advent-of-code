import re

from typing import List


def resolve(stacks, moves):
    for move in moves:
        print("AVANT", stacks)
        items = []
        for _ in range(move["length"]):
            if stacks[move["from"]]:
                item = stacks[move["from"]].pop()
                items.insert(0, item)
                print(f"ITMES: {items}")
        if items:
            stacks[move["to"]].extend(items)
        print("APRES", stacks)
    for row in stacks:
        if row:
            print(list(reversed(row))[0])


raw_stacks1 = """
[X] [D] [X]
[N] [C] [X]
[Z] [M] [P]
 1   2   3
"""

raw_stacks2 = """
[S] [X] [X] [X] [X] [T] [Q] [X] [X]
[L] [X] [X] [X] [B] [M] [P] [X] [T]
[F] [X] [S] [X] [Z] [N] [S] [X] [R]
[Z] [R] [N] [X] [R] [D] [F] [X] [V]
[D] [Z] [H] [J] [W] [G] [W] [X] [G]
[B] [M] [C] [F] [H] [Z] [N] [R] [L]
[R] [B] [L] [C] [G] [J] [L] [Z] [C]
[H] [T] [Z] [S] [P] [V] [G] [M] [M]
 1   2   3   4   5   6   7   8   9
"""

raw_moves1 = """
move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"""

raw_moves2 = """
move 6 from 1 to 7
move 2 from 2 to 4
move 2 from 7 to 4
move 6 from 4 to 3
move 1 from 5 to 1
move 3 from 8 to 3
move 15 from 3 to 4
move 6 from 5 to 9
move 14 from 4 to 2
move 3 from 2 to 7
move 1 from 2 to 7
move 9 from 9 to 1
move 3 from 2 to 1
move 7 from 6 to 7
move 1 from 6 to 8
move 2 from 9 to 1
move 9 from 2 to 3
move 8 from 3 to 9
move 1 from 1 to 4
move 1 from 8 to 6
move 1 from 6 to 2
move 5 from 9 to 8
move 2 from 9 to 1
move 1 from 4 to 2
move 17 from 1 to 9
move 1 from 3 to 1
move 3 from 2 to 3
move 2 from 4 to 5
move 12 from 7 to 3
move 16 from 9 to 2
move 5 from 7 to 5
move 2 from 1 to 2
move 1 from 3 to 6
move 1 from 4 to 6
move 1 from 7 to 3
move 1 from 6 to 3
move 7 from 3 to 4
move 5 from 8 to 3
move 1 from 6 to 7
move 7 from 3 to 4
move 6 from 3 to 1
move 2 from 4 to 8
move 1 from 5 to 2
move 10 from 4 to 5
move 3 from 5 to 2
move 2 from 8 to 9
move 5 from 2 to 8
move 1 from 3 to 5
move 2 from 5 to 8
move 12 from 5 to 7
move 1 from 4 to 2
move 5 from 9 to 4
move 1 from 2 to 5
move 6 from 1 to 3
move 6 from 3 to 5
move 10 from 7 to 4
move 2 from 7 to 3
move 4 from 7 to 6
move 1 from 9 to 5
move 12 from 2 to 1
move 1 from 8 to 7
move 3 from 7 to 4
move 4 from 4 to 8
move 7 from 5 to 3
move 1 from 2 to 4
move 10 from 1 to 5
move 2 from 1 to 2
move 4 from 6 to 7
move 8 from 8 to 3
move 5 from 4 to 9
move 12 from 3 to 8
move 4 from 3 to 8
move 2 from 9 to 2
move 3 from 5 to 4
move 1 from 3 to 5
move 1 from 7 to 6
move 14 from 4 to 6
move 6 from 5 to 9
move 8 from 2 to 8
move 3 from 5 to 7
move 21 from 8 to 4
move 16 from 4 to 9
move 8 from 6 to 2
move 4 from 6 to 1
move 1 from 4 to 6
move 2 from 4 to 8
move 3 from 1 to 8
move 2 from 4 to 6
move 1 from 6 to 2
move 3 from 8 to 4
move 2 from 2 to 5
move 2 from 5 to 7
move 1 from 8 to 9
move 1 from 4 to 9
move 1 from 1 to 6
move 3 from 6 to 3
move 3 from 2 to 3
move 1 from 4 to 6
move 3 from 6 to 7
move 10 from 9 to 7
move 1 from 4 to 7
move 6 from 8 to 3
move 1 from 6 to 8
move 2 from 2 to 5
move 1 from 2 to 1
move 1 from 8 to 9
move 1 from 2 to 8
move 1 from 1 to 9
move 7 from 9 to 1
move 1 from 8 to 5
move 7 from 1 to 7
move 3 from 5 to 8
move 3 from 7 to 2
move 1 from 8 to 4
move 1 from 2 to 4
move 2 from 4 to 6
move 5 from 3 to 1
move 9 from 7 to 2
move 6 from 3 to 8
move 8 from 2 to 7
move 2 from 6 to 4
move 2 from 1 to 7
move 2 from 1 to 4
move 24 from 7 to 4
move 4 from 8 to 9
move 2 from 7 to 5
move 1 from 5 to 2
move 1 from 3 to 8
move 4 from 2 to 8
move 13 from 9 to 2
move 2 from 8 to 6
move 3 from 9 to 6
move 26 from 4 to 2
move 1 from 5 to 7
move 2 from 6 to 2
move 2 from 4 to 1
move 7 from 2 to 1
move 15 from 2 to 6
move 8 from 2 to 8
move 4 from 6 to 8
move 9 from 2 to 9
move 13 from 6 to 7
move 6 from 1 to 9
move 2 from 2 to 4
move 4 from 1 to 6
move 3 from 8 to 3
move 1 from 4 to 9
move 2 from 6 to 7
move 1 from 4 to 3
move 3 from 3 to 2
move 14 from 7 to 4
move 5 from 9 to 5
move 9 from 8 to 5
move 7 from 9 to 6
move 2 from 5 to 6
move 2 from 9 to 2
move 10 from 5 to 1
move 1 from 3 to 1
move 2 from 8 to 1
move 1 from 9 to 2
move 1 from 7 to 5
move 4 from 2 to 1
move 1 from 9 to 8
move 3 from 4 to 1
move 1 from 8 to 6
move 12 from 1 to 5
move 1 from 1 to 6
move 1 from 7 to 5
move 4 from 6 to 9
move 2 from 2 to 4
move 1 from 9 to 6
move 1 from 1 to 5
move 2 from 9 to 7
move 10 from 6 to 5
move 1 from 6 to 7
move 20 from 5 to 1
move 1 from 7 to 9
move 2 from 9 to 1
move 3 from 5 to 1
move 2 from 8 to 4
move 2 from 8 to 7
move 1 from 5 to 9
move 1 from 8 to 4
move 22 from 1 to 7
move 5 from 4 to 8
move 1 from 5 to 9
move 19 from 7 to 4
move 2 from 9 to 1
move 1 from 5 to 9
move 10 from 1 to 8
move 1 from 9 to 1
move 1 from 8 to 3
move 8 from 4 to 7
move 1 from 5 to 6
move 3 from 4 to 5
move 1 from 5 to 9
move 11 from 7 to 4
move 4 from 4 to 9
move 1 from 6 to 2
move 1 from 3 to 9
move 5 from 9 to 4
move 5 from 7 to 9
move 23 from 4 to 2
move 17 from 2 to 7
move 2 from 2 to 8
move 4 from 4 to 7
move 1 from 4 to 5
move 2 from 5 to 2
move 5 from 8 to 9
move 5 from 2 to 7
move 9 from 7 to 5
move 11 from 9 to 2
move 1 from 4 to 3
move 5 from 8 to 7
move 3 from 8 to 5
move 2 from 1 to 3
move 2 from 3 to 9
move 1 from 5 to 8
move 5 from 7 to 5
move 15 from 5 to 4
move 2 from 8 to 1
move 2 from 5 to 1
move 4 from 4 to 1
move 1 from 8 to 7
move 8 from 2 to 1
move 4 from 2 to 8
move 2 from 7 to 4
move 5 from 8 to 6
move 5 from 7 to 9
move 4 from 6 to 5
move 7 from 4 to 8
move 1 from 6 to 1
move 1 from 3 to 1
move 2 from 5 to 1
move 7 from 1 to 5
move 5 from 1 to 3
move 4 from 7 to 9
move 4 from 3 to 9
move 2 from 9 to 7
move 6 from 9 to 2
move 1 from 4 to 1
move 1 from 3 to 5
move 1 from 2 to 5
move 5 from 9 to 4
move 4 from 4 to 6
move 1 from 8 to 9
move 8 from 4 to 3
move 7 from 7 to 3
move 5 from 1 to 3
move 11 from 5 to 9
move 1 from 7 to 6
move 2 from 3 to 5
move 1 from 3 to 1
move 3 from 6 to 2
move 2 from 5 to 1
move 2 from 1 to 2
move 3 from 1 to 5
move 5 from 9 to 2
move 2 from 6 to 8
move 2 from 3 to 8
move 4 from 9 to 7
move 3 from 5 to 2
move 2 from 1 to 8
move 1 from 9 to 8
move 1 from 9 to 2
move 4 from 7 to 9
move 11 from 8 to 7
move 1 from 8 to 2
move 6 from 9 to 7
move 3 from 7 to 1
move 13 from 2 to 7
move 24 from 7 to 1
move 2 from 2 to 6
move 1 from 8 to 3
move 1 from 9 to 3
move 5 from 2 to 4
move 1 from 2 to 5
move 1 from 6 to 2
move 1 from 6 to 3
move 1 from 2 to 4
move 3 from 7 to 3
move 2 from 1 to 7
move 2 from 3 to 8
move 2 from 7 to 8
move 9 from 3 to 2
move 3 from 4 to 8
move 1 from 5 to 1
move 9 from 2 to 1
move 3 from 4 to 9
move 1 from 7 to 8
move 6 from 3 to 9
move 2 from 1 to 5
move 15 from 1 to 3
move 13 from 3 to 9
move 11 from 1 to 4
move 5 from 4 to 1
move 6 from 3 to 6
move 4 from 4 to 8
move 6 from 1 to 4
move 1 from 5 to 2
move 1 from 2 to 1
move 3 from 4 to 2
move 2 from 8 to 5
move 2 from 4 to 2
move 9 from 9 to 3
move 9 from 3 to 5
move 2 from 9 to 4
move 5 from 2 to 6
move 1 from 1 to 8
move 1 from 4 to 1
move 10 from 9 to 2
move 9 from 2 to 4
move 10 from 4 to 1
move 3 from 1 to 3
move 4 from 1 to 2
move 5 from 2 to 4
move 2 from 5 to 2
move 4 from 1 to 7
move 10 from 5 to 4
move 2 from 2 to 4
move 1 from 9 to 2
move 2 from 3 to 5
move 1 from 3 to 5
move 3 from 6 to 7
move 8 from 4 to 9
move 6 from 6 to 1
move 4 from 9 to 5
move 2 from 9 to 1
move 1 from 2 to 6
move 6 from 5 to 2
move 3 from 7 to 9
move 4 from 8 to 2
move 1 from 7 to 9
move 1 from 5 to 3
move 2 from 7 to 4
move 1 from 7 to 1
move 14 from 1 to 9
move 1 from 1 to 9
move 1 from 3 to 8
move 3 from 2 to 5
move 2 from 4 to 2
move 6 from 8 to 1
move 1 from 2 to 1
move 5 from 1 to 9
move 1 from 1 to 7
move 2 from 8 to 5
move 1 from 5 to 4
move 1 from 6 to 1
move 8 from 2 to 7
move 2 from 6 to 1
move 9 from 9 to 5
move 11 from 4 to 8
move 4 from 7 to 4
move 6 from 4 to 6
move 1 from 7 to 4
move 6 from 6 to 7
move 1 from 5 to 9
move 6 from 8 to 9
move 8 from 9 to 5
move 1 from 4 to 5
move 15 from 9 to 3
move 3 from 1 to 4
move 6 from 7 to 2
move 3 from 4 to 9
move 2 from 7 to 3
move 1 from 7 to 3
move 1 from 7 to 2
move 2 from 8 to 1
move 3 from 8 to 5
move 2 from 1 to 7
move 8 from 3 to 6
move 3 from 6 to 5
move 1 from 6 to 1
move 10 from 5 to 7
move 6 from 5 to 4
move 4 from 2 to 4
move 6 from 5 to 1
move 6 from 1 to 8
move 2 from 9 to 2
move 2 from 9 to 7
move 6 from 3 to 7
move 1 from 3 to 5
move 1 from 1 to 9
move 2 from 8 to 1
move 2 from 5 to 4
move 3 from 3 to 7
move 10 from 4 to 6
move 1 from 9 to 7
move 12 from 7 to 3
move 12 from 3 to 8
move 2 from 1 to 5
move 1 from 1 to 3
move 13 from 8 to 1
move 7 from 7 to 1
move 13 from 6 to 9
move 1 from 7 to 4
move 6 from 5 to 3
move 3 from 4 to 3
move 6 from 3 to 1
move 10 from 9 to 4
move 2 from 7 to 6
move 8 from 1 to 9
move 3 from 2 to 9
move 1 from 3 to 5
move 1 from 3 to 5
move 1 from 1 to 4
move 6 from 9 to 3
move 2 from 6 to 7
move 4 from 9 to 5
move 4 from 1 to 6
move 1 from 2 to 4
move 6 from 1 to 4
move 3 from 9 to 3
move 3 from 6 to 8
move 3 from 8 to 7
move 5 from 5 to 1
move 1 from 3 to 9
move 1 from 9 to 5
move 1 from 3 to 2
move 2 from 5 to 1
move 1 from 6 to 9
move 1 from 6 to 3
move 2 from 9 to 7
move 2 from 8 to 1
move 1 from 3 to 2
move 1 from 2 to 5
move 1 from 7 to 1
move 7 from 7 to 9
move 12 from 1 to 9
move 1 from 5 to 2
move 1 from 7 to 1
move 13 from 4 to 7
move 1 from 9 to 4
move 5 from 7 to 3
move 4 from 9 to 1
move 8 from 7 to 9
move 3 from 2 to 3
move 4 from 3 to 7
move 5 from 4 to 6
move 3 from 9 to 4
move 10 from 1 to 5
move 3 from 4 to 7
move 16 from 9 to 2
move 3 from 9 to 2
move 6 from 5 to 3
move 4 from 6 to 2
move 1 from 4 to 6
move 2 from 6 to 8
move 1 from 5 to 2
move 1 from 5 to 8
move 7 from 7 to 2
move 16 from 2 to 1
move 1 from 5 to 1
move 10 from 2 to 8
move 14 from 8 to 5
move 2 from 2 to 6
move 1 from 2 to 5
move 2 from 2 to 1
move 8 from 1 to 7
move 4 from 1 to 7
move 2 from 1 to 7
move 5 from 3 to 2
move 1 from 1 to 6
move 2 from 2 to 5
move 4 from 1 to 7
move 1 from 2 to 8
move 1 from 2 to 8
move 3 from 6 to 7
move 10 from 7 to 5
move 1 from 2 to 8
move 27 from 5 to 9
move 1 from 5 to 6
move 1 from 6 to 4
move 1 from 4 to 3
move 3 from 3 to 7
move 4 from 3 to 6
move 2 from 6 to 4
move 3 from 8 to 1
move 2 from 6 to 1
move 12 from 7 to 8
move 2 from 3 to 9
move 1 from 9 to 2
move 1 from 2 to 8
move 2 from 1 to 2
move 6 from 3 to 8
move 1 from 7 to 4
move 15 from 9 to 5
move 7 from 9 to 4
move 1 from 2 to 1
move 16 from 8 to 2
move 8 from 5 to 2
move 24 from 2 to 9
move 3 from 1 to 2
move 24 from 9 to 1
move 5 from 5 to 9
move 3 from 4 to 1
move 1 from 7 to 6
move 1 from 6 to 3
move 1 from 3 to 2
move 3 from 2 to 3
move 1 from 5 to 6
move 1 from 2 to 7
"""

def parse_stacks(data) -> List:
    parsed_data = list(map(lambda x: x.split(","), filter(None, data.split("\n"))))
    stacks = [[] for _ in range(1 + len(parsed_data))]
    for row in parsed_data[:-1]:
        preparsed = list(map(lambda x: x.strip("[]"), row[0].split(" ")))
        for i, lst in enumerate(preparsed):
            for j in lst:
                if j != "X":
                    stacks[i].insert(0, j)
    return stacks


def parse_moves(data) -> List:
    moves = []
    parsed_data = list(map(lambda x: x.split(","), filter(None, data.split("\n"))))
    compiled_re = re.compile("^move (\d.*) from (\d.*) to (\d.*)")
    for row in parsed_data:
        rs = compiled_re.search(row[0])
        moves.append(
            {
                "length": int(rs.group(1)),
                "from": int(rs.group(2))-1,
                "to": int(rs.group(3))-1,
            }
        )
    return moves



if __name__ == "__main__":
    parsed_stacks = parse_stacks(raw_stacks1)
    parsed_moves = parse_moves(raw_moves1)
    resolve(parsed_stacks, parsed_moves)
