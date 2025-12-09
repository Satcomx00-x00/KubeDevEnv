FROM mcr.microsoft.com/devcontainers/universal:2

# Install additional OS packages.
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
    jq

# Install Supabase CLI
RUN curl -sSf https://raw.githubusercontent.com/supabase/cli/main/install.sh | sh

# Install Zellij
RUN curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz -C /usr/local/bin \
    && chmod +x /usr/local/bin/zellij

# Install Powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/vscode/.oh-my-zsh/custom/themes/powerlevel10k \
    && chown -R vscode:vscode /home/vscode/.oh-my-zsh/custom/themes/powerlevel10k

# Clean up
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
