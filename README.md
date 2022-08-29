Stable Diffusion ROCm (Radeon OpenCompute) Dockerfile
==
Go from `docker pull; docker run; txt2img` on a Radeon ✨.

Provides a Dockerfile that packages the [basujindal optimized Stable Diffusion](https://github.com/basujindal/stable-diffusion) repository, preconfigured with dependencies to run on AMD Radeon GPUs (particularly 5xxx/6xxx desktop-class GPUs) via [AMD's ROCm platform](https://docs.amd.com/category/ROCm%E2%84%A2%20v5.x).

<img alt="sample of the provided sample prompt, an autumn forest" src="https://raw.githubusercontent.com/l1na-forever/stable-diffusion-rocm-docker/mainline/sample.png" />

Requirements
--
- A compatible Radeon card (VEGA 56/64, Radeon RX 67XX/68XX/69XX). Other cards may also function at some capacity.
- Modern Linux kernel with ROCM module (Kernel 5.10+)
- Docker

Usage
--

First, pull the Docker image locally:

```
    docker pull l1naforever/stable-diffusion-rocm:latest
```

Now, create an alias which will be used to run the Docker container. This normally goes in your `~/.zshrc` or `~/.bashrc`:

```
    alias drun='sudo docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v $(pwd):/pwd' ​
```

Finally, run the container: 

```
    drun --name stable-diffusion l1naforever/stable-diffusion-rocm:latest
```

This will place you in a shell that can immediately be used to invoke the `optimizedSD/optimized_txt2img.py` and `optimizedSD/optimized_img2img.py` scripts, generating outputs within the output directory: 

```
    python optimizedSD/optimized_txt2img.py --prompt "a beautiful landscape with sugar trees in autumn colors by studio ghibli, highly detailed, photorealistic forest, with orange and red leaves falling, fall colors, dynamic lighting, beautif_ul, trending on artstation artgerm pixiv twitter, dream" --ddim_steps 50 
```


If the provided `drun` alias above was used, the container will have your current working directory mounted at `/pwd`, which you can use to copy inputs and outputs from the container. For example, to copy the outputs generated within the container to your host's working directory:

```
    # Run from within the container:
    cp -r outputs /pwd
```
