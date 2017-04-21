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
RUN opam depext --yes coq

RUN opam install --yes altgr-ergo coq coqide why3

RUN opam install --yes frama-c

WORKDIR /home/user/files
CMD bash -l
#CMD bash -l -c "frama-c-gui"



