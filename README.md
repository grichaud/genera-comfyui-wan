# genera-comfyui-wan

Docker image for RunPod Serverless: ComfyUI + Wan 2.2 TI2V-5B (Text+Image to Video).

Used by [GeneraContenido](https://github.com/grichaud/GeneraContenido) for AI video generation.

## Setup

1. Create a Docker Hub account and access token
2. Add GitHub repo secrets: `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`
3. Push to `main` branch to trigger automatic build
4. Use the image in RunPod: `<username>/genera-comfyui-wan:latest`

## Model included

- **Wan 2.2 TI2V-5B**: Text+Image to Video (5B params, FP16)
- **GPU required**: 24GB VRAM (A5000, L40, A6000)
