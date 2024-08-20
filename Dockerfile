FROM docker.io/library/rust:1.73-bullseye

# NB: We actually do run eevrything as root in the container,
# because it saves useradd steps and so on and also with a rootless
# container it doesn't do us any harm.

RUN echo 'export PATH=$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/cargo/bin:/usr/local/rustup/toolchains/beta-x86_64-unknown-linux-gnu/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' >> /etc/profile

# Put things in the normal places
RUN rm -rf ~/.rustup ; ln -s /usr/local/rustup ~/.rustup
RUN mkdir ~/src

# Mount this instead; makes for less recompilation
# RUN rm -rf ~/.cargo ; ln -s /usr/local/cargo ~/.cargo

# lld clang: Faster linking; see "1.4.1 Faster Linking" of Zero To Production In Rust
# git make python3-pip npm nodejs less: lunarvim dependencies
RUN apt-get update && apt-get install -y less vim openssh-server lld clang git make python3-pip npm nodejs locales locales-all

# No reason not to stay on beta for normal hacking; this takes a bit
# but there's no Docker that's on beta so :shrug:
RUN rustup toolchain install beta
RUN rustup default beta
RUN rustup toolchain list | grep -v beta | xargs rustup toolchain uninstall
RUN rustup set auto-self-update enable
RUN rustup update
RUN rustup component add rust-src
RUN rustup component add rustfmt
RUN rustup component add clippy
RUN rustup component add rust-analyzer
RUN cargo install cargo-watch
RUN cargo install cargo-tarpaulin
RUN cargo install cargo-audit

# Install lunarvim
RUN cd /tmp/ && wget https://github.com/neovim/neovim/releases/download/v0.8.1/nvim-linux64.deb && apt install -y ./nvim-linux64.deb
RUN find ~/
RUN bash -c "LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install.sh)"

# CARGO_HOME is set to /usr/local/cargo, which is both owned by root
# and not mounted into the container, and we want it mounted in so
# compiles are faster across container restarts
ENV CARGO_HOME=

# NB: shell config is mostly mounted

COPY bothrc-local /root/.bothrc-local
