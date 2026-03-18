# =============================================================================
# GeneraContenido - ComfyUI + Wan 2.2 Video Generation
# RunPod Serverless Worker
#
# Modelo: Wan 2.2 TI2V-5B (Text+Image to Video, 5B params)
# GPU: 24GB VRAM (A5000, L40, A6000)
#
# Este Dockerfile se construye automaticamente via GitHub Actions.
# NO necesitas Docker instalado localmente.
# =============================================================================

FROM runpod/worker-comfyui:latest-base

# --- Descargar modelos Wan 2.2 (ComfyUI Repackaged) ---

# TI2V-5B: Text+Image to Video (principal)
RUN wget -q --show-progress -O /comfyui/models/diffusion_models/wan2.2_ti2v_5b_fp16.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_ti2v_5b_fp16.safetensors"

# VAE
RUN wget -q --show-progress -O /comfyui/models/vae/wan_2.2_vae.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.2_vae.safetensors"

# Text Encoder (UMT5-XXL FP8)
RUN mkdir -p /comfyui/models/text_encoders && \
    wget -q --show-progress -O /comfyui/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"

# CLIP Vision (para image-to-video)
RUN mkdir -p /comfyui/models/clip_vision && \
    wget -q --show-progress -O /comfyui/models/clip_vision/clip_vision_h.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors"

# --- Copiar workflows pre-configurados ---
COPY workflows/ /comfyui/workflows/

CMD ["/start.sh"]
