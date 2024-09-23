import requests
import time
import sys
import os

def generate_image(prompt):
    api_url = "https://api-inference.huggingface.co/models/runwayml/stable-diffusion-v1-5"
    #    api_url = "https://api-inference.huggingface.co/models/CompVis/stable-diffusion-v1-4"
    headers = {"Authorization": f"Bearer hf_xxx","Content-Type": "application/json", "x-use-cache": "false"}
#,"x-wait-for-model": "true
    # Define a base style template that will be added to every prompt
    base_prompt = "in the style of epic concept art, highly detailed, vivid colors, cinematic lighting, photorealistic textures."

    # Combine the base prompt with the user's prompt

    full_prompt = f"{prompt}, {base_prompt}"

    # Retry parameters
    max_retries = 5
    retry_delay = 10  # seconds

    for attempt in range(max_retries):
        data = {"inputs": full_prompt}

        response = requests.post(api_url, headers=headers, json=data)

        if response.status_code == 200:
            image_data = response.content
            image_path = os.path.join(os.path.dirname(__file__), "generated_image.png")
            print(f"Saving image to: {image_path}")
            with open(image_path, "wb") as img_file:
                img_file.write(image_data)
                print("Image generated successfully with prompt:", full_prompt)
            return

        elif response.status_code == 503:
            # Service unavailable, retry after delay
            error_info = response.json()
            print(f"Error: {response.status_code}, {error_info['error']}. Retrying in {retry_delay} seconds...")
            time.sleep(retry_delay)

        else:
            print(f"Error: {response.status_code}, {response.text}")
            return

    print("Failed to generate image after multiple attempts.")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        user_prompt = sys.argv[1]
        generate_image(user_prompt)

    else:
        print("Please provide a prompt.")
        # Example
        generate_image("Create a landscape with mountains and a river")

