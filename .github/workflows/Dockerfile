ARG K_VERSION
FROM runtimeverificationinc/kframework-k:ubuntu-noble-${K_VERSION}

ARG USER=user
ARG GROUP
ARG USER_ID
ARG GROUP_ID
RUN groupadd -g ${GROUP_ID} ${GROUP} && useradd -m -u ${USER_ID} -s /bin/sh -g ${GROUP} ${USER}

USER ${USER}:${GROUP}
RUN mkdir /home/${USER}/workspace
WORKDIR /home/${USER}/workspace

ENV PATH=/home/${USER}/.local/bin:${PATH}
