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
    python3 \
    python3-venv \
    python3-pip \
    nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install uv for Python package management
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="$PATH:/root/.local/bin"

# Install Supabase CLI
RUN curl -sSf https://raw.githubusercontent.com/supabase/cli/main/install.sh | sh

# Install Zellij
RUN curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz -C /usr/local/bin \
    && chmod +x /usr/local/bin/zellij

# Install chezmoi
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

# Install Rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Copy dotfiles submodule for later initialization
COPY dotfiles /tmp/dotfiles

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

# Install Bun
ENV BUN_INSTALL=/usr/local/bun
ENV PATH=$BUN_INSTALL/bin:$PATH
RUN curl -fsSL https://bun.sh/install | bash

# Clean up
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
