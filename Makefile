NAME=ftp
REPO=hendry/$(NAME)

.PHONY: start stop build sh

all: build

build:
	docker build -t $(REPO) .

push:
	docker push $(REPO)

start:
	docker run -d --name $(NAME) -p 21:21 -v /mnt/2tb/cam:/var/www/cam $(REPO)

stop:
	docker stop $(NAME)

sh:
	docker exec -it $(NAME) /bin/sh
