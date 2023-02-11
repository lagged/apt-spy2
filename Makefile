.PHONY: clean install release docker-build docker-run

IMAGE?=lagged/apt-spy2:dev

container:=apt-spy2

clean:
	docker rm -f $(container) || true

install:
	bundle install --path ./vendor/bundle

release:
	bundle exec rake release

docker-build:
	docker build -t $(IMAGE) .

docker-run: clean docker-build
	docker run --rm -it \
		--name $(container) \
		-v $(CURDIR):/work \
		$(IMAGE) bash
