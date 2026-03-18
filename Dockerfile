# =============================================================================
# GeneraContenido - ComfyUI + Wan 2.2 Video Generation
# RunPod Serverless Worker
#
# Modelo: Wan 2.2 TI2V-5B (Text+Image to Video, 5B params)
# GPU: 24GB VRAM (A5000, L40, A6000)
# =============================================================================

FROM runpod/worker-comfyui:latest-base

# --- Actualizar ComfyUI a la ultima version (incluye nodos nativos de Wan 2.2) ---
RUN cd /comfyui && git pull origin master || git pull origin main

# --- Crear directorios necesarios ---
RUN mkdir -p /comfyui/models/diffusion_models \
    /comfyui/models/vae \
    /comfyui/models/text_encoders \
    /comfyui/models/clip_vision

# --- Descargar modelos Wan 2.2 (ComfyUI Repackaged) ---

# TI2V-5B: Text+Image to Video (principal, ~10GB)
RUN wget -q -O /comfyui/models/diffusion_models/wan2.2_ti2v_5B_fp16.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_ti2v_5B_fp16.safetensors"

# VAE (~200MB)
RUN wget -q -O /comfyui/models/vae/wan2.2_vae.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan2.2_vae.safetensors"

# Text Encoder UMT5-XXL FP8 (~5GB)
RUN wget -q -O /comfyui/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"

# CLIP Vision (for image-to-video, ~1.2GB)
RUN wget -q -O /comfyui/models/clip_vision/sigclip_vision_patch14_384.safetensors \
    "https://huggingface.co/Comfy-Org/sigclip_vision_384/resolve/main/sigclip_vision_patch14_384.safetensors"

# --- Copiar workflows pre-configurados ---
COPY workflows/ /comfyui/workflows/

CMD ["/start.sh"]
