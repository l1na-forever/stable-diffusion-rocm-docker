FROM alpine/git:latest AS builder
WORKDIR /opt
RUN git clone --depth 1 https://github.com/AUTOMATIC1111/stable-diffusion-webui
WORKDIR /opt/stable-diffusion-webui
#rogue torch version
RUN sed -i -e '/^torch\r/d' requirements.txt
RUN sed -i -e '/^torch\r/d' requirements_versions.txt


FROM rocm/pytorch:latest
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    REQS_FILE='requirements.txt'

COPY --from=builder /opt/stable-diffusion-webui /sd
WORKDIR /sd

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y libglib2.0-0 wget && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    python -m venv venv && \
    source venv/bin/activate && \
    python -m pip install --upgrade pip wheel && \
    python -m pip install --force-reinstall httpcore==0.15

RUN python -m pip install --force-reinstall numpy==1.21.6

EXPOSE 7860

ENTRYPOINT python launch.py --precision full --no-half --listen
