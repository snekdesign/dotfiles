FROM ghcr.nju.edu.cn/prefix-dev/pixi:jammy
COPY --from=ghcr.nju.edu.cn/astral-sh/uv:latest /uv /uvx /usr/local/bin/

COPY --chmod=644 src/cargo/config.toml /root/.cargo/
COPY --chmod=644 src/pixi/pixi-global_linux.toml /root/.pixi/manifests/pixi-global.toml
COPY --chmod=644 src/wsl/wsl.conf /etc/
COPY --chmod=644 .pixi/envs/default/share/agent-skills/librarian/* /root/.agents/skills/librarian/

# ADD --chmod doesn't work with directories or extracted files
COPY .pixi/envs/default/share/agent-skills/grilling /root/.agents/skills/grilling/
ADD build/wsl/tombi.tar.xz /root/.cache/tombi/
RUN chmod -R a=r,u+w,a+X /root/.agents/skills/grilling /root/.cache/tombi

RUN sed -es,http://archive.ubuntu.com,https://mirror.nju.edu.cn, -es,http://security.ubuntu.com,https://mirror.nju.edu.cn, -i.bak /etc/apt/sources.list
RUN apt-get update
