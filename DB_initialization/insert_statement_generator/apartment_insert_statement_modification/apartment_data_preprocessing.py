import sys


def apartment_data_preprocessing(input_apartment_statement_file, input_location_statement_file):
    with open(input_apartment_statement_file, 'r') as f:
        apartment_statements = f.read()
    with open(input_location_statement_file, 'r') as f:
        location_statements = f.read()
    apartment_statement_list = apartment_statements.split('\n')
    location_statement_list = location_statements.split('\n')
    location_statement_slice_start = location_statement_list[0].find(',')

    new_statements = []
    for index, apartment_statement in enumerate(apartment_statement_list):
        apartment_statement_splitted = apartment_statement.split(', ')
        del apartment_statement_splitted[-3]
        apartment_statement_temp = ", ".join(apartment_statement_splitted)[:-2]
        location_statement_slice = location_statement_list[index][location_statement_slice_start:]
        new_statement = apartment_statement_temp + location_statement_slice
        new_statements.append(new_statement)

    with open('new_apartment_insert_statements.txt', 'w') as f:
        for new_statement in new_statements:
            f.write(new_statement + '\n')


if __name__ == '__main__':
    # python3 apartment_data_preprocessing.py original_apartment_insert_statements.txt original_location_apartment_insert_statements.txt
    apartment_data_preprocessing(sys.argv[1], sys.argv[2])
