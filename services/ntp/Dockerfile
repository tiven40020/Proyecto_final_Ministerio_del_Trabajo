FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y chrony && \
    rm -rf /var/lib/apt/lists/*

COPY chrony.conf /etc/chrony/chrony.conf

EXPOSE 123/udp

CMD ["chronyd", "-d"]
