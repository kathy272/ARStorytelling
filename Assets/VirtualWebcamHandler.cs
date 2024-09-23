using UnityEngine;

public class VirtualWebcamHandler : MonoBehaviour
{
    public RenderTexture renderTexture;  // Assign this in the Inspector
    public string virtualCamName = "OBS Virtual Camera";  // Name of the virtual camera (e.g., OBS VirtualCam)

    private WebCamTexture webcamTexture;
    private Texture2D texture2D;
    private Color[] pixelData;

    void Start()
    {
        WebCamDevice[] devices = WebCamTexture.devices;

        // Search for the virtual camera in the device list
        foreach (var device in devices)
        {
            Debug.Log("Available Webcam: " + device.name);
            if (device.name == virtualCamName)
            {
                // Initialize the virtual camera texture
                webcamTexture = new WebCamTexture(device.name);
                webcamTexture.Play();

                if (webcamTexture.width > 0 && webcamTexture.height > 0)
                {
                    texture2D = new Texture2D(webcamTexture.width, webcamTexture.height);
                }
                else
                {
                    Debug.LogError("Failed to get virtual camera dimensions.");
                }

                break;  // Exit the loop once the camera is found
            }
        }

        if (webcamTexture == null)
        {
            Debug.LogError("Virtual camera not found! Make sure the name is correct and the virtual camera is active.");
        }
    }

    void Update()
    {
        // Skip the update if no valid webcam texture or it's not playing
        if (webcamTexture == null || !webcamTexture.isPlaying)
        {
            return;
        }

        // Update the texture from the webcam feed
        if (texture2D != null)
        {
            texture2D.SetPixels(webcamTexture.GetPixels());
            texture2D.Apply();

            // Copy texture data to render texture
            Graphics.Blit(texture2D, renderTexture);

            // Optionally: Save pixel data for later use
            pixelData = texture2D.GetPixels();
        }
    }

    public Color[] GetPixelData()
    {
        return pixelData;
    }
}
