from pathlib import Path

def count_word_occurrences(word_search: list[list[str]], word: str):
    """`word_search` = list of rows"""
    word_length = len(word)
    n_occurrences = 0
    # Horizontal
    for row_no, _ in enumerate(word_search):
        for col_no in range(len(word_search[0]) - word_length + 1):
            s = [word_search[row_no][col_no + i] for i in range(word_length)]
            if ("".join(s) == word) or ("".join(reversed(s)) == word):
                n_occurrences += 1                
    # Vertical
    for row_no in range(0, len(word_search) - word_length + 1):
        for col_no, _ in enumerate(word_search[0]):
            s = [word_search[row_no + i][col_no] for i in range(word_length)]
            if ("".join(s) == word) or ("".join(reversed(s)) == word):
                n_occurrences += 1
    # Left-to-right diagonal
    for row_no in range(len(word_search) - word_length + 1):
        for col_no in range(len(word_search[0]) - word_length + 1):
            s = [word_search[row_no + i][col_no + i] for i in range(word_length)]
            if ("".join(s) == word) or ("".join(reversed(s)) == word):
                n_occurrences += 1
    # Right-to-left diagonal
    for row_no in range(len(word_search) - word_length + 1):    
        for col_no in range(word_length - 1, len(word_search[0])):
            s = [
                word_search[row_no + r][col_no + c]
                for r, c in zip(range(word_length), range(0, -word_length, -1))
            ]
            if ("".join(s) == word) or ("".join(reversed(s)) == word):
                n_occurrences += 1
    return n_occurrences


def count_word_crosses(word_search: list[list[str]], word: str):
    word_length = len(word)
    n_occurrences = 0
    for row_no in range(0, len(word_search) - word_length + 1):
        for col_no in range(0, len(word_search[0]) - word_length + 1):
            square = [[word_search[row_no + r][col_no + c] for c in range(0, word_length)] for r in range(0, word_length)]
            diag1 = [square[i][i] for i in range(0, word_length)]
            diag2 = [square[r][c] for r, c in zip(range(word_length), range(word_length - 1, -1, -1))]
            if (
                    ("".join(diag1) == word and "".join(diag2) == word)
                    or ("".join(reversed(diag1)) == word and "".join(diag2) == word)
                    or ("".join(diag1) == word and "".join(reversed(diag2)) == word)
                    or ("".join(reversed(diag1)) == word and "".join(reversed(diag2)) == word)
            ):
                n_occurrences += 1
    return n_occurrences


input_file = Path(__file__).parent / "input" / "day04.txt"
input_ = [list(l) for l in input_file.read_text().splitlines()]
print("Part 1:", count_word_occurrences(input_, "XMAS"))
print("Part 2:", count_word_crosses(input_, "MAS"))
