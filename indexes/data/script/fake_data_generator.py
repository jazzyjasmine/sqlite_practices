import csv
import random
from faker import Faker


APARTMENT_NAME_SUFFIX = [
    ' Park',
    ' Court',
    ' Apartments',
    ' Living',
    ' Homes',
    ' Village',
    ' Square',
    ' Views',
    ' Place',
    ' House',
    ' Units',
    ' Villas'
]


def generate_landlords(tuple_num,
                       csv_filename='landlords.csv',
                       rating_lower_bound=0,
                       rating_higher_bound=5,
                       rating_decimal_place=1,
                       rating_count_lower_bound=0,
                       rating_count_higher_bound=400):
    """generate data for "landlord" table"""
    faker = Faker()
    with open(f'csv/{csv_filename}', 'w') as f:
        # create the csv writer
        writer = csv.writer(f)

        for landlord_id in range(1, tuple_num + 1):
            landlord_name = faker.company()
            landlord_rating = round(random.uniform(rating_lower_bound, rating_higher_bound), rating_decimal_place)
            landlord_rating_count = random.randint(rating_count_lower_bound, rating_count_higher_bound)
            writer.writerow([landlord_id, landlord_name, landlord_rating, landlord_rating_count])


def generate_worksites(tuple_num,
                       csv_filename='worksites.csv'):
    """generate data for "worksite" table"""
    faker = Faker()
    with open(f'csv/{csv_filename}', 'w') as f:
        writer = csv.writer(f)

        for worksite_id in range(1, tuple_num + 1):
            worksite_name = faker.company()
            curr_data_list = [worksite_id, worksite_name]
            curr_data_list.extend(get_fake_address())
            writer.writerow(curr_data_list)


def get_fake_address():
    faker = Faker()
    address = faker.street_address()
    city = faker.city()
    state = random.randint(1, 56)
    zipcode = faker.zipcode()
    latitude = faker.latitude()
    longitude = faker.longitude()
    return [address, city, state, zipcode, latitude, longitude]


def generate_apartments(tuple_count,
                        max_landlord_id,
                        csv_filename='apartments.csv'):
    faker = Faker()
    with open(f'csv/{csv_filename}', 'w') as f:
        writer = csv.writer(f)

        for apartment_id in range(1, tuple_count + 1):
            apartment_name = faker.city() + random.choice(APARTMENT_NAME_SUFFIX)
            laundry_type = random.randint(1, 2)
            parking_type = random.randint(1, 3)
            landlord_id = random.randint(1, max_landlord_id)
            official_website = faker.url()
            curr_tuple_list = [apartment_id,
                               apartment_name,
                               laundry_type,
                               parking_type,
                               landlord_id,
                               official_website]
            curr_tuple_list.extend(get_fake_address())
            writer.writerow(curr_tuple_list)


def generate_users(tuple_count,
                   max_worksite_id,
                   min_age=18,
                   max_age=70,
                   csv_filename='users.csv'):
    faker = Faker()
    user_email_addresses = []
    with open(f'csv/{csv_filename}', 'w') as f:
        writer = csv.writer(f)
        for user_id in range(1, tuple_count + 1):
            unique_email_address = faker.first_name() + str(user_id) + '@' + faker.hostname()
            user_email_addresses.append(unique_email_address)
            user_password = faker.password()
            worksite_id = random.randint(1, max_worksite_id)
            age = random.randint(min_age, max_age)
            writer.writerow([unique_email_address, user_password, worksite_id, age])

    return user_email_addresses


def generate_user_apartment_relations(user_email_addresses,
                                      max_apartment_id,
                                      max_apartment_count_per_user,
                                      csv_filename='user_apartment_wishlist.csv'):
    with open(f'csv/{csv_filename}', 'w') as f:
        writer = csv.writer(f)
        for user in user_email_addresses:
            apartment_count = random.randint(0, max_apartment_count_per_user)

            if apartment_count == 0:
                continue

            apartment_ids = random.sample(range(1, max_apartment_id + 1), apartment_count)
            for apartment_id in apartment_ids:
                writer.writerow([user, apartment_id])


if __name__ == '__main__':
    pass
    # generate_landlords(11000)
    # generate_apartments(15000, 11000)
    # generate_worksites(11000)
    # user_email_addresses = generate_users(10000, 11000)
    # generate_user_apartment_relations(user_email_addresses,
    #                                   15000,
    #                                   15)



