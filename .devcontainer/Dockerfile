# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/universal:2

# Install NodeJS repository
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -

# Install additional OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    postgresql-client \
    redis-tools \
    iputils-ping \
    dnsutils \
    curl \
    git \
    zsh \
    vim \
    htop \
    jq \
    gh \
    python3 \
    python3-venv \
    python3-pip \
    nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install mise
RUN curl https://mise.run | sh
ENV PATH="/root/.local/bin:/root/.local/share/mise/shims:$PATH"

# Copy mise config and install CLI tools
COPY mise.toml /root/.config/mise/config.toml
RUN mise trust /root/.config/mise/config.toml \
    && mise install --yes

# Copy dotfiles submodule for later initialization
COPY .devcontainer/dotfiles /tmp/dotfiles

# Install Powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /usr/share/powerlevel10k

# Install CUDA and LLM tools
# RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb \
#     && dpkg -i cuda-keyring_1.1-1_all.deb \
#     && apt-get update \
#     && apt-get install -y --no-install-recommends cuda-nvcc-12-3 cuda-libraries-dev-12-3 nvtop git-lfs \
#     && apt-get clean && rm -rf /var/lib/apt/lists/* \
#     && rm cuda-keyring_1.1-1_all.deb

# Install Python LLM libraries
# RUN pip install --no-cache-dir torch torchvision torchaudio transformers accelerate bitsandbytes

# Clean up
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
