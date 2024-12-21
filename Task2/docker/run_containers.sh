#!/bin/sh

if [ "$#" -ne 1 ]; then
	echo "Использование: $0 <количество контейнеров>"
	exit 1
fi

docker volume create shared_data

for i in $(seq 1 $1); do
	docker run -d --name container$i -v shared_data:/data file_manager_image
done

