FROM ubuntu:22.04 as base

RUN apt-get update && apt-get install -y curl sudo \
 && useradd -ms /bin/bash dotfiles \
 && usermod -aG sudo dotfiles \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER dotfiles
WORKDIR /home/dotfiles

COPY setup.sh dotfiles/setup.sh
RUN dotfiles/setup.sh

FROM base

COPY . dotfiles
WORKDIR /home/dotfiles/dotfiles
RUN . ~/.profile && task all

CMD ["/bin/bash", "-l"]
