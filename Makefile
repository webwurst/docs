PROJECT=docs
registry=registry.giantswarm.io

default: ;

build:
	docker build -t $(registry)/$(PROJECT) .

run: build
	docker run --rm -p 8000:8000 $(registry)/$(PROJECT)

deploy: 
	swarm create swarmdocs.json
	swarm start swarmdocs
