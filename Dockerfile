# 1. Base Image NQIYA (Zero Nvidia)
FROM python:3.10-slim

# 2. Installi l'adawat d Linux
RUN apt-get update && apt-get install -y git wget libgl1 libglib2.0-0 && rm -rf /var/lib/apt/lists/*

WORKDIR /comfyui

# 3. Jbed ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# 4. 🔥 L'QALEB HNA: Installi PyTorch d l'CPU BO7DO!
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# 5. Installi l'Libraries d ComfyUI
RUN pip install --no-cache-dir -r requirements.txt

# 6. 🚀 OPENVINO & INTEL OPTIMIZATION (Hna fin katzreb)
RUN pip install --no-cache-dir intel_extension_for_pytorch optimum-intel openvino nncf

# 7. Wjed Dousiyat l'Models
RUN mkdir -p models/unet models/vae models/clip

# 8. Jbed L'Models (Z-Image-Turbo)
RUN wget -q -O models/unet/z_image_turbo_fp8.safetensors "https://huggingface.co/T5B/Z-Image-Turbo-FP8/resolve/main/z-image-turbo-fp8-e4m3fn.safetensors"
RUN wget -q -O models/vae/ae.safetensors "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors"
RUN wget -q -O models/clip/qwen_3_4b.safetensors "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors"

# 9. Ch3el l'Moteur b CPU
EXPOSE 8080
CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8080", "--cpu"]
