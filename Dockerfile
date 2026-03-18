# =============================================================================
# GeneraContenido - ComfyUI + Wan 2.2 + InstantID
# RunPod Serverless Worker
#
# Video: Wan 2.2 TI2V-5B (Text+Image to Video)
# Images: InstantID (face-consistent identity pack from reference photos)
# GPU: 24GB VRAM (A5000, L40, A6000)
# =============================================================================

FROM runpod/worker-comfyui:latest-base

# --- Actualizar ComfyUI a la ultima version ---
RUN cd /comfyui && \
    git fetch origin && \
    git reset --hard origin/master 2>/dev/null || git reset --hard origin/main && \
    pip install -r requirements.txt 2>/dev/null || true

# --- Instalar dependencias de InstantID ---
# insightface 0.7.3 is compatible with ComfyUI_InstantID (supports providers param)
RUN pip install insightface==0.7.3 onnxruntime-gpu albumentations

# --- Instalar nodos custom: InstantID ---
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/cubiq/ComfyUI_InstantID.git && \
    cd ComfyUI_InstantID && \
    pip install -r requirements.txt 2>/dev/null || true

# --- Crear directorios ---
RUN mkdir -p /comfyui/models/diffusion_models \
    /comfyui/models/vae \
    /comfyui/models/text_encoders \
    /comfyui/models/clip_vision \
    /comfyui/models/instantid \
    /comfyui/models/controlnet \
    /comfyui/models/insightface/models/antelopev2 \
    /comfyui/models/checkpoints

# ============================
# MODELOS WAN 2.2 (VIDEO)
# ============================

# TI2V-5B: Text+Image to Video (~10GB)
RUN wget -q -O /comfyui/models/diffusion_models/wan2.2_ti2v_5B_fp16.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_ti2v_5B_fp16.safetensors"

# VAE (~200MB)
RUN wget -q -O /comfyui/models/vae/wan2.2_vae.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan2.2_vae.safetensors"

# Text Encoder UMT5-XXL FP8 (~5GB)
RUN wget -q -O /comfyui/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"

# CLIP Vision (~1.2GB)
RUN wget -q -O /comfyui/models/clip_vision/sigclip_vision_patch14_384.safetensors \
    "https://huggingface.co/Comfy-Org/sigclip_vision_384/resolve/main/sigclip_vision_patch14_384.safetensors"

# ============================
# MODELOS INSTANTID (IMAGENES)
# ============================

# SDXL Base checkpoint - RealVisXL V4.0 (photorealistic, ~6.5GB)
RUN wget -q -O /comfyui/models/checkpoints/realvisxl_v40.safetensors \
    "https://huggingface.co/SG161222/RealVisXL_V4.0/resolve/main/RealVisXL_V4.0.safetensors"

# InstantID model (~1.7GB)
RUN wget -q -O /comfyui/models/instantid/ip-adapter.bin \
    "https://huggingface.co/InstantX/InstantID/resolve/main/ip-adapter.bin"

# InstantID ControlNet (~2.5GB)
RUN wget -q -O /comfyui/models/controlnet/diffusion_pytorch_model.safetensors \
    "https://huggingface.co/InstantX/InstantID/resolve/main/ControlNetModel/diffusion_pytorch_model.safetensors"

# Antelopev2 face analysis models (~100MB total)
RUN wget -q -O /comfyui/models/insightface/models/antelopev2/1k3d68.onnx \
    "https://huggingface.co/MonsterMMORPG/tools/resolve/main/1k3d68.onnx" && \
    wget -q -O /comfyui/models/insightface/models/antelopev2/2d106det.onnx \
    "https://huggingface.co/MonsterMMORPG/tools/resolve/main/2d106det.onnx" && \
    wget -q -O /comfyui/models/insightface/models/antelopev2/genderage.onnx \
    "https://huggingface.co/MonsterMMORPG/tools/resolve/main/genderage.onnx" && \
    wget -q -O /comfyui/models/insightface/models/antelopev2/glintr100.onnx \
    "https://huggingface.co/MonsterMMORPG/tools/resolve/main/glintr100.onnx" && \
    wget -q -O /comfyui/models/insightface/models/antelopev2/scrfd_10g_bnkps.onnx \
    "https://huggingface.co/MonsterMMORPG/tools/resolve/main/scrfd_10g_bnkps.onnx"

# --- Copiar workflows ---
COPY workflows/ /comfyui/workflows/

CMD ["/start.sh"]
