FROM ubuntu:bionic AS builder
MAINTAINER kongroo <imjcqt@gmail.com>
WORKDIR /root

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        vim \
        git \
        curl \
        build-essential \
        cmake \
        python3-dev
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh"  ] && \. "$NVM_DIR/nvm.sh" \
    && nvm install --lts \
    && git clone --depth=1 https://github.com/Valloric/YouCompleteMe /root/.vim/plugged/YouCompleteMe \
    && npm install -g typescript \
    && cd /root/.vim/plugged/YouCompleteMe \
    && git submodule update --init --recursive

Run export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh"  ] && \. "$NVM_DIR/nvm.sh" \
    && cd /root/.vim/plugged/YouCompleteMe \
    && python3 install.py --clang-completer --js-completer \
    && rm -rf ./.git \
    && rm -rf ./third_party/ycmd/clang_archives \
    # && rm -rf ./third_party/ycmd/cpp/BoostParts \
    && rm -rf ./third_party/ycmd/third_party/OmniSharpServer

FROM ubuntu:bionic
WORKDIR /root
COPY --from=builder /root/.vim /root/.vim


