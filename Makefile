.PHONY: clean install release docker-build docker-run

IMAGE?=lagged/apt-spy2:dev

container:=apt-spy2

clean:
	docker rm -f $(container) || true
	rm -rf vendor

install:
	bundle config set --local path './vendor/bundle'
	bundle install

release:
	bundle exec rake release

lint:
	bundle exec rubocop .

test: install
	bundle exec rake test

docker-build:
	docker build -t $(IMAGE) .

docker-run: clean docker-build
	docker run --rm -it \
		--name $(container) \
		-v $(CURDIR):/work \
		$(IMAGE) bash
