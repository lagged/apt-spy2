FROM ubuntu:22.10

RUN apt update -y \
	&& apt install -y \
		ruby3.0 \
		ruby-dev \
		ruby-bundler \
		git \
		lsb-release \
		build-essential

WORKDIR /work
COPY . /work

CMD ["ruby", "-v"]
