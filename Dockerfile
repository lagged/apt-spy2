FROM ruby:2.6-slim

WORKDIR /work
COPY . /work

CMD ["ruby", "-v"]
