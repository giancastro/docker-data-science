FROM ubuntu:16.04

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
