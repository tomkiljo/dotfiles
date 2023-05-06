FROM ubuntu:22.04 as base

RUN apt-get update && apt-get install -y curl sudo \
 && useradd -ms /bin/bash dotfiles \
 && usermod -aG sudo dotfiles \
 && install -d -m 0700 -o dotfiles -g dotfiles /home/dotfiles/.local \
 && install -d -m 0755 -o dotfiles -g dotfiles /home/dotfiles/.local/bin \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
 && sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /home/dotfiles/.local/bin

FROM base

USER dotfiles
COPY --chown=dotfiles:dotfiles . /home/dotfiles/dotfiles
WORKDIR /home/dotfiles/dotfiles
RUN . ~/.profile && task all

CMD ["/bin/bash", "-l"]
