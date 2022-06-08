from faker import Faker
import random

from hardcoded_info import worksites, leasing_periods, email_addresses


def generate_fake_users(fake_user_count):
    faker = Faker()
    email_list = []
    with open('insert_statements/user_insert_statement.txt', 'w') as f:
        for i in range(fake_user_count):
            first_name = faker.first_name().lower()
            last_name = faker.last_name().lower()
            domain = faker.domain_name()
            password = faker.password()
            age = random.randint(20, 55)
            email_address = f'{first_name}{last_name}@{domain}'
            worksite = get_random_element(worksites)
            email_list.append(email_address)
            f.write(f"insert into user values ('{email_address}', '{password}', '{worksite}', {age});" + "\n")
    return email_list


def generate_fake_price_plans(fake_price_plan_count, lowest_price, highest_price):
    with open('insert_statements/price_plan_insert_statement.txt', 'w') as f:
        for i in range(fake_price_plan_count):
            price = random.randint(lowest_price, highest_price)
            leasing_period = get_random_element(leasing_periods)
            f.write(f"insert into price_plan values (NULL, {price}, '{leasing_period}');" + "\n")


def generate_fake_user_apartment_wishlist(original_tuple_count, apartment_start_line, apartment_end_line):
    apartment_count = apartment_end_line - apartment_start_line + 1
    info_set = set()
    for i in range(original_tuple_count):
        email_address = get_random_element(email_addresses)
        apartment_id = random.randint(1, apartment_count)
        combined = email_address + ' ' + str(apartment_id)
        info_set.add(combined)

    with open('insert_statements/user_apartment_wishlist_insert_statement.txt', 'w') as f:
        for info in info_set:
            info_list = info.split()
            email_address = info_list[0]
            apartment_id = info_list[1]
            f.write(f"insert into user_apartment_wishlist values ('{email_address}', {apartment_id});" + "\n")


def generate_fake_floor_plan_and_price(
        price_plan_start_line,
        price_plan_end_line,
        apartment_start_line,
        apartment_end_line,
        floor_plan_type_count,
        floor_plan_min_area,
        floor_plan_max_area,
        maximum_floor_plan_count_per_apartment,
        maximum_price_plan_count_per_floor_plan
):
    apartment_id_floor_plan_id_price_plan_id_combined = set()
    with open('insert_statements/floor_plan_insert_statement.txt', 'w') as floor_plan_writer:
        for apartment_id in range(1, apartment_end_line - apartment_start_line + 2):
            for floor_plan_id in range(1, random.randint(1, maximum_floor_plan_count_per_apartment) + 1):
                floor_plan_type = random.randint(1, floor_plan_type_count)
                floor_plan_area = random.randint(floor_plan_min_area, floor_plan_max_area)
                floor_plan_writer.write(
                    f"insert into floor_plan values ({apartment_id}, {floor_plan_id}, {floor_plan_type}, {floor_plan_area});" + "\n")

                for i in range(1, random.randint(1, maximum_price_plan_count_per_floor_plan) + 1):
                    price_plan_id = random.randint(1, price_plan_end_line - price_plan_start_line + 1)
                    apartment_id_floor_plan_id_price_plan_id_combined.add(
                        f"{apartment_id} {floor_plan_id} {price_plan_id}")

    with open('insert_statements/floor_plan_price_insert_statement.txt', 'w') as floor_plan_price_writer:
        for info_string in apartment_id_floor_plan_id_price_plan_id_combined:
            info_list = info_string.split()
            apartment_id = info_list[0]
            floor_plan_id = info_list[1]
            price_plan_id = info_list[2]
            floor_plan_price_writer.write(f"insert into floor_plan_price values ({apartment_id}, {floor_plan_id}, {price_plan_id});" + "\n")


def get_random_element(lst):
    return lst[random.randint(0, len(lst) - 1)]


if __name__ == '__main__':
    # email_addresses = generate_fake_users(40)
    # print(email_addresses)
    # generate_fake_price_plans(50, 1100, 3000)
    # generate_fake_user_apartment_wishlist(80, 93, 112)
    generate_fake_floor_plan_and_price(40, 89, 93, 112, 5, 600, 1100, 5, 3)
