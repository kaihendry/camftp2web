NAME=ftp
REPO=hendry/$(NAME)

.PHONY: start stop build sh

all: build

build:
	docker build -t $(REPO) .

push:
	docker push $(REPO)

start:
	docker run -d -p 21:21 -v /mnt/2tb/cam:/var/www/cam -v $(PWD)/ftp-users.txt:/etc/ftp-users.txt $(REPO)

stop:
	docker stop $(NAME)

sh:
	docker exec -it $(NAME) /bin/sh
