from diffusers import StableDiffusionPipeline
import os


def download_model():
    HF_AUTH_TOKEN = os.getenv("HF_AUTH_TOKEN")

    StableDiffusionPipeline.from_pretrained(
        "CompVis/stable-diffusion-v1-4", revision="fp16", use_auth_token=HF_AUTH_TOKEN
    )


if __name__ == "__main__":
    download_model()
