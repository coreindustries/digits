
ENV =
NS = nvidia
VERSION ?= latest
REPO = digits
NAME = digits
INSTANCE = default
PORTS = -p 5000:5000
VOLUMES = -v /media/corey/Storage/dataset:/dataset

.PHONY: build push shell run start stop rm release

build:
	docker build -t $(NS)/$(REPO):$(VERSION) .

push:
	docker push $(NS)/$(REPO):$(VERSION)

shell:
	#docker run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(NS)/$(REPO):$(VERSION) /bin/bash
	docker run --name $(NAME) -it $(PORTS) $(VOLUMES) --entrypoint "/bin/bash" $(NS)/$(REPO):$(VERSION)

run:
	-make stop
	-make rm
	docker run -it --name $(NAME) --restart always $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

# run as a deamon
start:
	docker run -d --restart always --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

stop:
	docker stop $(NAME)

rm:
	docker rm $(NAME)

debug:
	make build
	make run

attach:
	docker exec -it $(NAME) /bin/bash

logs:
	docker logs $(NAME)

release: build
	make push -e VERSION=$(VERSION)

test:
	make build;make run

default: build

default: build

