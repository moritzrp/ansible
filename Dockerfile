FROM ubuntu:jammy as base
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y sudo software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS main
RUN addgroup --gid 1000 mr && \
    adduser --uid 1000 --gid 1000 --disabled-password --gecos mr mr && \
    adduser mr sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER mr
WORKDIR /home/mr

FROM main
COPY . .
CMD ["sh", "-c", "ansible-playbook setup.yml"]
