import pandas as pd
import re

def read_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        return file.read()

def extract_date_from_filename(file_name):
    coincidencias = re.search(r'\d{4}-\d{2}-\d{2}', file_name)
    return coincidencias.group() if coincidencias else None

def parse_paragraphs(content):
    return content.split('\n\n\n')

def process_paragraphs(paragraphs):
    data = []
    for paragraph in paragraphs:
        lines = paragraph.strip().split('\n')
        agent = lines.pop(0).replace("AGENTE: ", "")
        for line in lines:
            data_line = [agent] + line.replace(' ', '').split(',')
            if data_line[2].strip() == 'D':
                data.append(data_line)

    return data

def main():
    file_path = "OFEI1204.txt"
    content = read_file(file_path)
    paragraphs = parse_paragraphs(content)

    name_file = paragraphs.pop(0)
    fecha = extract_date_from_filename(name_file)

    data = process_paragraphs(paragraphs)

    columns = ['Agente', 'Planta', 'Tipo'] + ['Hora_{}'.format(i) for i in range(1, 25)]
    df = pd.DataFrame(data, columns=columns)

    output_file = 'typeD-{}.csv'.format(fecha)
    df.to_csv(output_file, index=True)


if __name__ == "__main__":
    main()
