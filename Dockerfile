FROM alpine/git:latest AS builder
WORKDIR /opt
RUN git clone --depth 1 https://github.com/basujindal/stable-diffusion
RUN mkdir -p /opt/stable-diffusion/models/ldm/stable-diffusion-v1/
ADD sd-v1-4.ckpt /opt/stable-diffusion/models/ldm/stable-diffusion-v1/model.ckpt

FROM rocm/pytorch:rocm5.2_ubuntu20.04_py3.7_pytorch_1.11.0_navi21
COPY --from=builder /opt/stable-diffusion /opt/stable-diffusion
WORKDIR /opt/stable-diffusion
RUN conda init 
RUN conda env create -f environment.yaml
ENV PATH /opt/conda/envs/ldm/bin:$PATH
RUN echo "source activate ldm" >> ~/.bashrc
RUN pip3 install --upgrade torch torchvision --extra-index-url https://download.pytorch.org/whl/rocm5.1.1



