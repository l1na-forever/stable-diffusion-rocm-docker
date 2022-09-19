FROM alpine/git:latest AS builder
WORKDIR /opt
RUN git clone --depth 1 https://github.com/sd-webui/stable-diffusion-webui.git
WORKDIR /opt/stable-diffusion-webui
RUN wget https://gist.githubusercontent.com/l1na-forever/bb2b495b664c10ed4b2882afd4543eb6/raw/f27c9f08a6551cc15e4138b311fbaf1431affe54/0001-minor-tweaks-install-AMD-ROCM-PyTorch-5.1.1.patch
RUN git apply 0001-minor-tweaks-install-AMD-ROCM-PyTorch-5.1.1.patch

FROM rocm/pytorch:rocm5.2_ubuntu20.04_py3.7_pytorch_1.11.0_navi21
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    CONDA_DIR=/opt/conda

COPY --from=builder /opt/stable-diffusion-webui /sd
WORKDIR /sd

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y libglib2.0-0 wget && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Install font for prompt matrix
COPY --from=builder /opt/stable-diffusion-webui/data/DejaVuSans.ttf /usr/share/fonts/truetype/

EXPOSE 7860 8501

COPY --from=builder /opt/stable-diffusion-webui//entrypoint.sh /sd/
ENTRYPOINT /sd/entrypoint.sh
