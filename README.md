Stable Diffusion ROCm (Radeon OpenCompute) Dockerfile
==
Go from `docker pull; docker run; txt2img` on a Radeon ✨.

Provides a Dockerfile that packages the [AUTOMATIC1111 fork Stable Diffusion WebUI](https://github.com/AUTOMATIC1111/stable-diffusion-webui) repository, preconfigured with dependencies to run on AMD Radeon GPUs (particularly 5xxx/6xxx desktop-class GPUs) via [AMD's ROCm platform](https://docs.amd.com/category/ROCm%E2%84%A2%20v5.x).

<img alt="screenshot of a Void Linux/AMD GPU machine using the Stable Diffusion WebUI" src="https://raw.githubusercontent.com/l1na-forever/stable-diffusion-rocm-docker/main/assets/void_screenshot.webp" />

Requirements
--
- A compatible Radeon card (VEGA 56/64, Radeon RX 67XX/68XX/69XX). Other cards may also function at some capacity.
- Modern Linux kernel with ROCM module (Kernel 5.10+)
- Docker
- Approximately 50GB of drive space for docker installation

Usage
--

First, pull the Docker image locally:

```
    docker pull l1naforever/stable-diffusion-rocm:latest
```

Now, create an alias which will be used to run the Docker container. This normally goes in your `~/.zshrc` or `~/.bashrc`:

```
    alias drun='docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v $(pwd):/pwd'
```

Finally, run the container: 

```
    drun --name stable-diffusion l1naforever/stable-diffusion-rocm:latest
```

After a period of downloading models and dependencies, you should see the output printed:

```
    Running on local URL:  http://localhost:7860/
```

Visit this URL in a browser to access the web UI. 


Troubleshooting
--
**Container fails to start with `hipErrorNoBinaryForGpu: Unable to find code object for all current devices!`**

See [issue #1](https://github.com/l1na-forever/stable-diffusion-rocm-docker/issues/1). HIP's libraries bundled with the docker image are failing to load the right kernel for the specific GPU being used (this is particularly true with RX6xxx mobile variants). Try setting an environment variable to force HIP to use the `gfx1030` kernel by passing the parameter `-e HSA_OVERRIDE_GFX_VERSION=10.3.0` to `docker run`, or updating the above `drun` alias. For example:

```
    alias drun='docker run -e HSA_OVERRIDE_GFX_VERSION=10.3.0 -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v $(pwd):/pwd'
```
