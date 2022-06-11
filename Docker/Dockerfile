FROM ubuntu:20.04

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
	python3-setuptools \
	python3.8-venv \
	git \
	wget \
	; \
	rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY start.sh .
COPY setup.sh .
RUN ./setup.sh

RUN groupadd rosuser -g 1000 && \
    useradd -m -u 1000 -g rosuser -s /bin/bash -c "ROS user" rosuser
USER rosuser
WORKDIR /home/rosuser
RUN mkdir -p .ros rosdistro meta-ros

CMD ["bash", "/build/start.sh"]
