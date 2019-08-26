FROM ubuntu:18.04

RUN apt-get update -y \
	&& apt-get install -y ruby ruby-dev git gcc g++ make zlib1g-dev lsb-release \
	&& gem install bundler \
	&& mkdir -p /work

WORKDIR /work
COPY . /work

CMD ["ruby", "-v"]
