import os
import csv
import re

input_directory = 'path/to/files'  # Directory containing text files
output_csv = 'compiled_texts.csv'       # output file

def compile_texts_to_csv(input_directory, output_csv):
    # List to hold the rows of CSV file
    rows = []

    # Iterate over each file in the input directory
    for filename in os.listdir(input_directory):
        # Only process text files
        if filename.endswith(".txt"):
            file_path = os.path.join(input_directory, filename)
            with open(file_path, 'r', encoding='utf-8') as file:
                content = file.read()
                lines = content.split('\n')
                for line in lines:
                    if re.search("[0-9 | .]+,        [0-9 | .]+,        [0-9 | .]+,        [0-9 | .]+,", line):
                        data = line.split(',')
                        data.insert(0, filename)
                        rows.append(data)

    # Write the rows to a CSV file
    with open(output_csv, 'w', newline='', encoding='utf-8') as csvfile:
        csvwriter = csv.writer(csvfile)
        # Write the data
        csvwriter.writerows(rows)

if __name__ == "__main__":
    # Compile the texts into a CSV file
    compile_texts_to_csv(input_directory, output_csv)
    print(f"Text documents compiled into {output_csv}")