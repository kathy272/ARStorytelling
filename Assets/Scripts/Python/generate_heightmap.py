import cv2
import numpy as np

# Load image or get from camera feed
image = cv2.imread('map.png')

# Convert to HSV (easier to define color ranges)
hsv_image = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

# Define the range for pink color (adjust as needed)
lower_pink = np.array([140, 50, 50])
upper_pink = np.array([170, 255, 255])

# Create a mask for pink color
mask = cv2.inRange(hsv_image, lower_pink, upper_pink)

# Find contours in the mask (areas with pink)
contours, _ = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

# Now you have the positions of pink areas
