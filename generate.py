from diffusers import StableDiffusionPipeline
import torch

# Load the Stable Diffusion model
print("Loading model...")
pipe = StableDiffusionPipeline.from_pretrained(
    "stabilityai/stable-diffusion-2-1",
    torch_dtype=torch.float16
)
pipe = pipe.to("mps")  # Use Apple Silicon GPU
print("Model loaded!")

# Prompt 1
prompt = "iOS app icon, minimalist running figure silhouette in dynamic forward motion, vibrant orange to coral gradient background, small stopwatch element in corner, geometric clean design, flat illustration style, no text, 1024x1024, professional app store quality"
print(f"Generating image 1...")
image = pipe(prompt, num_inference_steps=30, guidance_scale=7.5).images[0]
image.save("pace_icon_1.png")
print("✓ Saved pace_icon_1.png")

# Prompt 2
prompt = "modern app icon design, abstract speed lines and motion blur effect, bold orange and white color scheme, simplified runner shape made of geometric circles and curves, digital clock numbers subtly integrated, minimal flat design, sharp vector style, iOS aesthetic"
print(f"Generating image 2...")
image = pipe(prompt, num_inference_steps=30, guidance_scale=7.5).images[0]
image.save("pace_icon_2.png")
print("✓ Saved pace_icon_2.png")

# Prompt 3
prompt = "fitness app icon, stylized shoe print or footstep trail forming circular pattern, energetic orange gradient background, clean white accents, timer pace indicator incorporated into design, contemporary flat illustration, geometric shapes, no typography, square format app icon"
print(f"Generating image 3...")
image = pipe(prompt, num_inference_steps=30, guidance_scale=7.5).images[0]
image.save("pace_icon_3.png")
print("✓ Saved pace_icon_3.png")

print("\n✨ All icons generated successfully!")
