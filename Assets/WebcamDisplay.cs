using UnityEngine;

public class WebcamDisplay : MonoBehaviour
{
    public RenderTexture renderTexture; // Assign this in the Inspector
    public int webcamIndex = 1; // Index of the desired webcam

    private WebCamTexture webcamTexture;

    void Start()
    {
        // Get available webcams
        WebCamDevice[] devices = WebCamTexture.devices;

        if (devices.Length > 0)
        {
            // Ensure the index is within the bounds of available devices
            if (webcamIndex < devices.Length)
            {
                // Create and start the webcam texture for the chosen camera
                webcamTexture = new WebCamTexture(devices[webcamIndex].name);
                webcamTexture.Play();
            }
            else
            {
                Debug.LogError("Webcam index is out of range.");
            }
        }
        else
        {
            Debug.LogError("No webcam devices found.");
        }

        // Set the RenderTexture as the target for the webcam feed
        if (renderTexture != null && webcamTexture != null)
        {
            Graphics.Blit(webcamTexture, renderTexture);
        }
    }

    void Update()
    {
        // Continuously update the RenderTexture with the webcam feed
        if (renderTexture != null && webcamTexture != null)
        {
            Graphics.Blit(webcamTexture, renderTexture);
        }
    }
}
