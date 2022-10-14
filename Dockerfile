FROM alpine/git:latest AS builder
WORKDIR /opt
RUN git clone --depth 1 https://github.com/AUTOMATIC1111/stable-diffusion-webui
WORKDIR /opt/stable-diffusion-webui

FROM rocm/pytorch:latest
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    TORCH_COMMAND='pip install --upgrade torch torchvision --extra-index-url https://download.pytorch.org/whl/rocm5.1.1' \
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
    python -m $TORCH_COMMAND && \
    echo "Downloading SDv1.4 Model File.." && \
    curl -o models/Stable-diffusion/model.ckpt https://www.googleapis.com/storage/v1/b/aai-blog-files/o/sd-v1-4.ckpt?alt=media       

EXPOSE 7860

ENTRYPOINT python launch.py --precision full --no-half
