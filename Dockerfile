FROM ubuntu:22.04 as base

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    curl keyboard-configuration locales sudo tzdata \
 ## set locales
 && locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 \
 ## set timezone
 && ln -fs /usr/share/zoneinfo/Europe/Helsinki /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 ## add non-root user
 && useradd -ms /bin/bash dotfiles \
 && usermod -aG sudo dotfiles \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
 ## install task
 && install -d -m 0700 -o dotfiles -g dotfiles /home/dotfiles/.local \
 && install -d -m 0755 -o dotfiles -g dotfiles /home/dotfiles/.local/bin \
 && sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /home/dotfiles/.local/bin

COPY keyboard /etc/default/keyboard

FROM base

USER dotfiles
COPY --chown=dotfiles:dotfiles . /home/dotfiles/dotfiles
WORKDIR /home/dotfiles/dotfiles
RUN . ~/.profile && task all

CMD ["/bin/bash", "-l"]
