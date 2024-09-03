ARG K_VERSION
FROM runtimeverificationinc/kframework-k:ubuntu-noble-${K_VERSION}

ARG USER=user
ARG GROUP
ARG USER_ID
ARG GROUP_ID
RUN groupadd -g 1001 ${GROUP} && useradd -m -u 1001 -s /bin/sh -g ${GROUP} ${USER}

USER ${USER}:${GROUP}
RUN mkdir /home/${USER}/workspace
WORKDIR /home/${USER}/workspace

ENV PATH=/home/${USER}/.local/bin:${PATH}
