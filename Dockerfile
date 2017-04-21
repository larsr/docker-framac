FROM ubuntu:latest
MAINTAINER Lars Rasmusson <Lars Rasmusson@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update

RUN apt install -y wget build-essential


RUN apt install -y opam

RUN apt install -y sudo

# create a user account called 'user'
RUN adduser --disabled-password --gecos '' user

# allow 'user' to do a passwordless sudo
RUN sed -ie 's@%sudo.ALL=(ALL:ALL) ALL@%sudo   ALL=(ALL:ALL) NOPASSWD:ALL@' /etc/sudoers
RUN usermod -a -G sudo user

USER user
RUN opam init -a
RUN opam install depext
RUN opam depext --yes frama-c
RUN opam install --yes frama-c

CMD bash -l -c frama-c-gui


