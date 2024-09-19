import cv2
import json
import numpy as np

# Path to the JSON file
json_file = "C:/Users/kendl/OneDrive/Documents/UnityProjects/ProjectBA/BaProject/Assets/Scripts/pink_areas.json"

# Open the webcam (1 might refer to an external camera, adjust as necessary)
webcam = cv2.VideoCapture(1)

if not webcam.isOpened():
    print("Error: Camera not found or failed to open.")
    exit()

# Capture a frame from the webcam
ret, img = webcam.read()

# Release the camera
webcam.release()

# Check if the frame was captured successfully
if not ret:
    print("Error: Failed to capture image from the camera.")
    exit()

# Convert the image from BGR to RGB
img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

# Resize the image (if needed)
img_resized = cv2.resize(img_rgb, (500, 500))

# Convert the image to HSV for better color detection
img_hsv = cv2.cvtColor(img_resized, cv2.COLOR_RGB2HSV)

# Define the lower and upper bounds for neon pink in HSV color space
lower_neon_pink = np.array([160, 100, 100])  # Adjust these values as needed
upper_neon_pink = np.array([170, 255, 255])

# Create a mask to detect neon pink areas
mask = cv2.inRange(img_hsv, lower_neon_pink, upper_neon_pink)

# Find contours in the mask
contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

# Check if contours were detected
print(f"Number of neon pink areas detected: {len(contours)}")

# Prepare data to store in JSON
contours_data = []
for contour in contours:
    # Approximate contours to reduce the number of points
    epsilon = 0.01 * cv2.arcLength(contour, True)
    approx = cv2.approxPolyDP(contour, epsilon, True)

    for point in approx:
        x, y = point[0]
        # Convert 2D to 3D by using y as height (z) and x as width (x)
        contours_data.append({"x": int(x), "y": int(y), "z": 0.0})  # Assuming z = 0 or use a constant value

# Save the detected areas in JSON
if contours_data:
    with open(json_file, 'w') as f:
        print("Saving neon pink areas to pink_areas.json")
        json.dump({"positions": contours_data}, f)
else:
    print("No neon pink areas detected.")
