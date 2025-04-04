FROM ubuntu:noble

# Use /bin/bash as the shell
SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata \
	&& apt-get install -y python3 \
	&& apt-get install -y python3-pip \
    && apt-get install -y python3-venv \
    && rm -rf $(pip cache dir) \
    && pip3 install --break-system-packages pandas fsspec pyarrow \
    && pip3 install --break-system-packages polars[deltalake] \
	&& apt-get clean \
    && rm -rf $(pip cache dir) \
    &&	rm -rf /var/lib/apt/lists/* \
    &&	rm -f /etc/ssh/ssh_host_*

RUN pip3 install --break-system-packages python-dotenv pysftp requests \
    && apt-get clean \
    && rm -rf $(pip cache dir) \
    &&	rm -rf /var/lib/apt/lists/* \
    &&	rm -f /etc/ssh/ssh_host_*

RUN apt-get update \
    && apt-get install -y wget \
    && wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y libfuse3-dev fuse3 \
    && apt-get install -y blobfuse2 \
	&& apt-get clean \
    && rm -rf $(pip cache dir) \
    &&	rm -rf /var/lib/apt/lists/* \
    &&	rm -f /etc/ssh/ssh_host_*

# # Copy the code and environ file from the host to the container
# COPY code /code
COPY ../test /test
# RUN mkdir -p /data

