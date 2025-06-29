FROM opensuse/tumbleweed:latest
LABEL org.opencontainers.image.source=https://github.com/fish-shell/fish-shell

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN zypper --non-interactive install \
  bash \
  diffutils \
  gcc-c++ \
  git-core \
  pcre2-devel \
  python311 \
  python311-pip \
  python311-pexpect \
  openssl \
  procps \
  tmux \
  sudo \
  rust \
  cargo

RUN usermod -p $(openssl passwd -1 fish) root

RUN groupadd -g 1000 fishuser \
  && useradd  -p $(openssl passwd -1 fish) -d /home/fishuser -m -u 1000 -g 1000 fishuser \
  && mkdir -p /home/fishuser/fish-build \
  && mkdir /fish-source \
  && chown -R fishuser:fishuser /home/fishuser /fish-source

USER fishuser
WORKDIR /home/fishuser

COPY fish_run_tests.sh /

ENV FISH_CHECK_LINT=false

CMD /fish_run_tests.sh
