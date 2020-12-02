FROM ubuntu:20.04

ARG IN_FILE="Program.cs"
ARG OUT_FILE="Program.exe"

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      apt-transport-https \
      dirmngr \
      gpg-agent \
      software-properties-common

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && apt update \
    && apt-get install -y mono-complete \
      sqlite3

WORKDIR /usr/local

COPY bin/ .

RUN chmod +x ${IN_FILE} \
    && mcs -o:${OUT_FILE} ${IN_FILE} -r:System.Data -r:Mono.Data.Sqlite\
    && chmod +x ${OUT_FILE}

CMD ["mono", "Program.exe"]
