ARG CUDA_VERSION=12.1.0

FROM nvidia/cuda:${CUDA_VERSION}-cudnn8-devel-ubuntu20.04 AS base
LABEL maintainer="NVIDIA CORPORATION"

SHELL ["/bin/bash", "-c"]

#===============================================================================
# non-root username
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
	&& useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
	# Add sudo support for the non-root user
	&& apt-get update \
	&& apt-get install -y sudo \
	&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
	&& chmod 0440 /etc/sudoers.d/$USERNAME \
	&& rm -rf /var/lib/apt/lists/*

ENV USER=${USERNAME}
ENV TERM=xterm-256color
ENV HOME=/home/${USERNAME}
ENV PATH=${HOME}/.local/bin:/usr/local/bin:${PATH}
RUN echo "for f in ~/.bashrc.d/*.sh; do . \$f; done" >> ${HOME}/.bashrc
#===============================================================================

# Required to build Ubuntu 20.04 without user prompts with DLFW container
ENV DEBIAN_FRONTEND=noninteractive

# Update CUDA signing key
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub

# Install requried libraries
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update && apt-get install -y --no-install-recommends \
	libcurl4-openssl-dev \
	curl \
	wget \
	git \
	pkg-config \
	sudo \
	ssh \
	libssl-dev \
	pbzip2 \
	pv \
	bzip2 \
	unzip \
	devscripts \
	lintian \
	fakeroot \
	dh-make \
	build-essential

# Install python3
RUN apt-get install -y --no-install-recommends \
	python3 \
	python3-pip \
	python3-dev \
	python3-wheel &&\
	cd /usr/local/bin &&\
	ln -s /usr/bin/python3 python &&\
	ln -s /usr/bin/pip3 pip;

# #===============================================================================
# # INSTALL ROS
# RUN apt-get install -y curl lsb-release \
# 	&& curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add 
# RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list' \
# 	&& sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list' \
# 	&& sh -c 'echo "deb http://packages.ros.org/ros-shadow-fixed/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-shadow.list' \
# 	&& apt-get update \
# 	&& apt-get install -y ros-noetic-ros-base
#
# # INSTALL CATKIN
# RUN apt-get update \
# 	&& apt-get install -y python3-osrf-pycommon python3-rosdep \
# 	python3-catkin-tools python3-vcstool python3-pip git unzip zip wget \
# 	build-essential \
# 	&& rm -rf /var/lib/apt/lists/*

# Slam_toolbox + hector + some utils
# RUN apt-get update \
# 	&& apt-get install -y \
# 	libgflags-dev libeigen3-dev git libgoogle-glog-dev \
# 	python3-pip \
# 	&& rm -rf /var/lib/apt/lists/*
RUN apt-get update \
	&& apt-get install -y \
	python3-pip \
	ffmpeg \
	libsm6 \
	libxext6 \
	&& rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

WORKDIR /home/${USERNAME}

ENV USER=${USERNAME}
ENV TERM=xterm-256color
ENV HOME=/home/${USERNAME}
ENV PATH=${HOME}/.local/bin:/usr/local/bin:${PATH}
RUN echo "for f in ~/.bashrc.d/*.sh; do . \$f; done" >> ${HOME}/.bashrc

#===============================================================================
RUN chsh -s /usr/bin/bash
#===============================================================================
# EGG + VideoRefer requirements
USER ${USERNAME}
COPY --chown=${USERNAME}:${USERNAME} requirements.txt /tmp/requirements.txt
ADD --chown=${USERNAME}:${USERNAME} ./third_party/PixelRefer/VideoRefer ${HOME}/third_party/VideoRefer
# UV
ADD --chown=${USERNAME}:${USERNAME} https://astral.sh/uv/install.sh uv-installer.sh
RUN sh uv-installer.sh && rm uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"
RUN uv venv egg-venv --python 3.9
RUN source egg-venv/bin/activate \ 
	&& uv pip install -r /tmp/requirements.txt \
	&& uv pip install flash-attn==2.5.8 --no-build-isolation \
	&& uv pip install -e ${HOME}/third_party/VideoRefer
# MAMBA/CONDA
# ARG MINIFORGE_NAME=Miniforge3
# ARG MINIFORGE_VERSION=24.7.1-0
# ARG TARGETPLATFORM
#
# ENV CONDA_DIR=${HOME}/conda
# ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
# ENV PATH=${CONDA_DIR}/bin:${PATH}
#
# RUN apt-get update > /dev/null && \
# 	apt-get install --no-install-recommends --yes \
# 	wget bzip2 ca-certificates \
# 	git \
# 	tini \
# 	> /dev/null && \
# 	apt-get clean && \
# 	rm -rf /var/lib/apt/lists/*
# USER ${USERNAME}
# RUN wget --no-hsts --quiet https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/${MINIFORGE_NAME}-${MINIFORGE_VERSION}-Linux-$(uname -m).sh -O /tmp/miniforge.sh && \
# 	/bin/bash /tmp/miniforge.sh -b -p ${CONDA_DIR} && \
# 	rm /tmp/miniforge.sh && \
# 	conda clean --tarballs --index-cache --packages --yes && \
# 	find ${CONDA_DIR} -follow -type f -name '*.a' -delete && \
# 	find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete && \
# 	conda clean --force-pkgs-dirs --all --yes  && \
# 	echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> ~/.bashrc
# # Install PyPI packages
# USER ${USERNAME}
#
# COPY --chown=${USER}:${USER} ./egg_venv.yml ${HOME}/egg_venv.yml
# RUN unset PYTHONPATH \
# 	&& mamba env create -n egg_venv -f ${HOME}/egg_venv.yml -y
# RUN echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate egg_venv" >> ~/.bashrc
# RUN chown ${USER}:${USER} ${HOME}/.cache
#
# RUN pip3 install --upgrade pip
# RUN pip3 install virtualenv
# COPY --chown=${USERNAME}:${USERNAME} requirements.txt /tmp/requirements.txt
# ADD --chown=${USERNAME}:${USERNAME} ./third_party/VideoRefer ${HOME}/third_party/VideoRefer
# RUN . ${CONDA_DIR}/etc/profile.d/conda.sh \
# 	&& conda activate egg_venv \
# 	&& pip install torch==2.3.0 torchvision==0.18.0 numpy==1.24.4 \
# 	&& pip install flash-attn==2.5.8 --no-build-isolation
# RUN . ${CONDA_DIR}/etc/profile.d/conda.sh \
# 	&& conda activate egg_venv \
# 	&& pip install -e ${HOME}/third_party/VideoRefer
# RUN . ${CONDA_DIR}/etc/profile.d/conda.sh \
# 	&& conda activate egg_venv \
# 	&& pip3 install --ignore-installed --default-timeout=1000 --no-cache-dir -r /tmp/requirements.txt

RUN curl -fsSL https://ollama.com/install.sh | OLLAMA_VERSION=0.6.7 sh
