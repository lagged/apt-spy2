install:
	bundle install --path ./vendor/bundle

release:
	bundle exec rake release

docker-build:
	docker build -t lagged/apt-spy2:dev .

docker-run: docker-build
	docker run -it lagged/apt-spy2:dev bash
