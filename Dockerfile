# 1. Use the RunPod base
FROM runpod/worker-comfyui:5.5.1-base

# 2. Reset and Clone
RUN rm -rf /comfyui && mkdir /comfyui
WORKDIR /comfyui
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# --- 🚀 CPU OPTIMIZATION (Intel IPEX) ---
RUN pip install --no-cache-dir intel_extension_for_pytorch optimum-intel openvino nncf

# 3. Create folders to be safe
RUN mkdir -p models/unet models/vae models/clip

# 4. BAKE THE UNET (6.15 GB)
RUN wget -q -O models/unet/z_image_turbo_fp8.safetensors \
    "https://huggingface.co/T5B/Z-Image-Turbo-FP8/resolve/main/z-image-turbo-fp8-e4m3fn.safetensors"

# 5. BAKE THE VAE (335 MB)
RUN wget -q -O models/vae/ae.safetensors \
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors"

# 6. BAKE THE CLIP (8.04 GB)
RUN wget -q -O models/clip/qwen_3_4b.safetensors \
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors"

# 7. Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

CMD ["/start.sh"]
