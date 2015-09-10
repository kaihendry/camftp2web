NAME=ftp
REPO=hendry/$(NAME)

.PHONY: admin bash start build

all: build

build:
	docker build -t $(REPO) .

push:
	docker push $(REPO)

start:
	docker run -d -v /srv/ftp:/home --name $(NAME) -p 21:21 $(REPO)

stop:
	docker stop $(NAME)

sh:
	docker exec -it $(NAME) /bin/sh
