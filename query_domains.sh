#!/bin/bash

# Проверяем наличие аргумента (IP адрес)
if [ -z "$1" ]; then
    echo "Usage: $0 <IP>"
    exit 1
fi

# Получаем абсолютный путь к скрипту
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Проверяем наличие файла с доменами
if [ ! -f "$script_dir/domen.txt" ]; then
    echo "File '$script_dir/domen.txt' not found."
    exit 1
fi

# Очищаем файл result.txt перед записью
> "$script_dir/result.txt"

# Читаем домены из файла и выполняем dig для каждого из них
while IFS= read -r domain || [ -n "$domain" ]; do
    echo "Querying domain: $domain"
    # Выполняем dig с параметрами +noall +answer и добавляем результат в файл result.txt
    dig +noall +answer "@$1" "$domain" >> "$script_dir/result.txt"
    echo "-----------------------------------"
done < "$script_dir/domen.txt"

echo "All results saved to $script_dir/result.txt"

