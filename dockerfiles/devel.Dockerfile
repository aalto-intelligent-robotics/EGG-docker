FROM egg:base AS devel

# non-root username
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Developmental env stuffs
USER root
RUN apt-get update \
	&& apt-get install -y unzip curl wget \
	clang cmake tmux zsh \
	python3-venv xclip xsel libxml2-utils \
	libxcb1-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev \
	iputils-ping iproute2 net-tools \
	gdb eog mpv pcl-tools libstdc++-13-dev \
	&& rm -rf /var/lib/apt/lists/*
RUN chsh -s $(which zsh)

USER ${USERNAME}
# Get Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

RUN curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
RUN source $HOME/.cargo/env \
	&& cargo binstall \
	starship \
	eza \
	bat \
	ripgrep \
	du-dust \
	zoxide \
	jless \
	yazi-build \
	zellij
RUN wget https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-musl.zip \
    && unzip yazi-x86_64-unknown-linux-musl \
    && cd yazi-x86_64-unknown-linux-musl/ \
    && mv yazi ya ${HOME}/.cargo/bin
RUN rm -rf ${HOME}/yazi-x86_64-unknown-linux-musl ${HOME}/yazi-x86_64-unknown-linux-musl.zip

RUN python3 -m pip install pynvim black flake8 cmakelang

RUN python3 -m pip install progressbar loguru

USER ${USERNAME}
SHELL ["/bin/zsh", "-c"]
COPY ./install_dev.sh ${HOME}/install_dev.sh

RUN python3 -m pip install sphinx sphinx_rtd_theme

RUN source ${HOME}/install_dev.sh


RUN mkdir -p ${HOME}/.cache/zsh \
	&& touch ${HOME}/.cache/zsh/history

RUN chown -R ${USERNAME} ${HOME}/.config
