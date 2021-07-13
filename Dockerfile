FROM aflplusplus/aflplusplus
ARG DEBIAN_FRONTEND=noninteractive
RUN useradd -ms /bin/bash user
RUN apt-get update && apt-get install -yq build-essential gcc-multilib debootstrap debian-archive-keyring libtool-bin bison python3 python3-pip virtualenv git python3-dev automake lsb-release xxd
RUN virtualenv -ppython3 /opt/venv
RUN /opt/venv/bin/pip install git+https://github.com/angr/archinfo
RUN /opt/venv/bin/pip install cle
RUN /opt/venv/bin/pip install git+https://github.com/angr/claripy
RUN /opt/venv/bin/pip install angr
RUN /opt/venv/bin/pip install git+https://github.com/angr/tracer
RUN /opt/venv/bin/pip install git+https://github.com/shellphish/driller
RUN cd / && git clone https://github.com/SpaceMoehre/sudofuzz
WORKDIR /sudofuzz
RUN make clean && ./configure --disable-shared && make && make install
RUN mkdir /tmp/in && mkdir /tmp/out && echo 'init' > /tmp/in/seed
CMD afl-fuzz -Q -i /tmp/in -o /tmp/out -M fuzzer-master ./src/sudo
