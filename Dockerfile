# 1. Use the RunPod base
FROM runpod/worker-comfyui:5.5.1-base

# 2. Reset and Clone
RUN rm -rf /comfyui && mkdir /comfyui
WORKDIR /comfyui
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# --- 🚀 CPU OPTIMIZATION (Intel IPEX & OpenVINO) ---
RUN pip install --no-cache-dir optimum-intel openvino nncf

# 3. Install ComfyUI-OpenVINO Custom Node
RUN cd /comfyui/custom_nodes && git clone https://github.com/openvino-dev-samples/comfyui-openvino.git
RUN pip install --no-cache-dir -r /comfyui/custom_nodes/comfyui-openvino/requirements.txt

# 4. Create folders to be safe
RUN mkdir -p models/unet models/vae models/clip

# 5. BAKE THE UNET (6.15 GB)
RUN wget -q -O models/unet/z_image_turbo_fp8.safetensors \
    "https://huggingface.co/T5B/Z-Image-Turbo-FP8/resolve/main/z-image-turbo-fp8-e4m3fn.safetensors"

# 6. BAKE THE VAE (335 MB)
RUN wget -q -O models/vae/ae.safetensors \
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors"

# 7. BAKE THE CLIP (8.04 GB)
RUN wget -q -O models/clip/qwen_3_4b.safetensors \
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors"

# 8. Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

CMD ["/start.sh"]
