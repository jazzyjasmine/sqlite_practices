import json
import sys


def get_worksite_name_list(json_filename):
    # Opening JSON file
    json_file = open(json_filename)

    # returns JSON object as
    # a dictionary
    data = json.load(json_file)

    name_list = []
    for info_dict in data['features']:
        name = info_dict['properties']['Location']['Business Name']
        name_list.append(name)

    return name_list


def process_json_data(json_filename, table_name):
    # Opening JSON file
    json_file = open(json_filename)

    # returns JSON object as
    # a dictionary
    data = json.load(json_file)

    insert_statement_list = []
    for info_dict in data['features']:
        if 'Address' not in info_dict['properties']['Location']:
            continue
        addresses = info_dict['properties']['Location']['Address']
        chicago_position = addresses.find('Chicago')
        address = info_dict['properties']['Location']['Address'][:chicago_position - 2]
        zipcode = addresses[-7:-2]
        name = info_dict['properties']['Location']['Business Name']
        latitude = info_dict['properties']['Location']['Geo Coordinates']['Latitude']
        longitude = info_dict['properties']['Location']['Geo Coordinates']['Longitude']
        insert_statement_list.append(
            f"insert into {table_name} values (NULL, '{name}', NULL, '{address}', 'Chicago', 17, '{zipcode}', '{latitude}', '{longitude}'); --{name}")

    with open(f'{table_name}_insert_statement.txt', 'w') as f:
        for statement in insert_statement_list:
            f.write(statement + '\n')


if __name__ == '__main__':
    # python3 json_processing.py json/groceries.json grocery
    # json_filename = sys.argv[1]
    # table_name = sys.argv[2]
    # process_json_data(json_filename, table_name)
    print(get_worksite_name_list('json/worksites.json'))
