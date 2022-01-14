FROM alpine AS builder

# This may be modified by the Github Action Workflow.
ARG SPS_ALSA_EXPLORE_BRANCH=master

RUN apk -U add \
        git \
        build-base \
        autoconf \
        automake \
        alsa-lib-dev
 

RUN 	git clone https://github.com/mikebrady/sps-alsa-explore
WORKDIR sps-alsa-explore
RUN 	git checkout "$SPS_ALSA_EXPLORE_BRANCH"
RUN 	autoreconf -fi
RUN 	./configure
RUN 	make

# Runtime
FROM alpine
RUN 	apk add alsa-lib 
RUN 	rm -rf  /lib/apk/db/*

COPY 	--from=builder /sps-alsa-explore /usr/local/bin

ENTRYPOINT [ "/bin/sh" ]

