def add_id_to_statements(filename):
    with open(filename, 'r') as f:
        lines = f.read().split('\n')

    with open(f'new_{filename}', 'w') as f_writer:
        id = 1
        for line in lines:
            pos = line.find('(')
            if pos == -1:
                continue
            left = line[:pos + 1]
            right = line[pos + 1:]
            new_line = left + str(id) + ', ' + right
            f_writer.write(new_line + '\n')
            id += 1



if __name__ == '__main__':
    add_id_to_statements('restaurant_statements.txt')