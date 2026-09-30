FROM ghcr.nju.edu.cn/prefix-dev/pixi:jammy
COPY --from=ghcr.nju.edu.cn/astral-sh/uv:0.12.10 /uv /uvx /usr/local/bin/

COPY --chmod=644 src/cargo/config.toml /root/.cargo/
COPY --chmod=644 src/pixi/pixi-global_linux.toml /root/.pixi/manifests/pixi-global.toml
COPY --chmod=644 src/wsl/wsl.conf /etc/

# ADD --chmod doesn't work with extracted files
ADD build/wsl/tombi.tar.xz /root/.cache/tombi/
RUN chmod -R a=r,u+w,a+X /root/.cache/tombi

RUN sed -es,http://archive.ubuntu.com,https://mirror.nju.edu.cn, -es,http://security.ubuntu.com,https://mirror.nju.edu.cn, -i.bak /etc/apt/sources.list
RUN apt-get update
