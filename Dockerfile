ARG BASE_CONTAINER=ubuntu:16.04
FROM $BASE_CONTAINER

RUN apt-get update && apt-get -yq dist-upgrade \
&& apt-get install -yq --no-install-recommends \
   wget \
   bzip2 \
   ca-certificates \
   sudo \
   locales \
   fonts-liberation \
&& rm -rf /var/lib/apt/lists/*

CMD ["echo", "FIM DA LINHA"]
