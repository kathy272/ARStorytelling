using UnityEngine;
using UnityEngine.UI;

public class VirtualWebcamHandler : MonoBehaviour
{
    public RenderTexture renderTexture;  // Assign this in the Inspector
    public RawImage displayImage;         // Assign the RawImage in the Inspector
    public string virtualCamName = "OBS Virtual Camera";  // Name of the virtual camera (e.g., OBS VirtualCam)

    private WebCamTexture webcamTexture;
    private Texture2D texture2D;
    private Color[] pixelData;

    void Start()
    {
        // Set up the webcam texture
        WebCamDevice[] devices = WebCamTexture.devices;

        foreach (var device in devices)
        {
            if (device.name == virtualCamName)
            {
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
        if (webcamTexture == null || !webcamTexture.isPlaying)
        {
            return;
        }

        if (texture2D != null)
        {
            texture2D.SetPixels(webcamTexture.GetPixels());
            texture2D.Apply();
            Graphics.Blit(texture2D, renderTexture);
            displayImage.texture = renderTexture;
        }
    }

    public Texture2D CaptureScreenshot()
    {
        if (webcamTexture != null && webcamTexture.isPlaying)
        {
            Texture2D screenshot = new Texture2D(webcamTexture.width, webcamTexture.height);
            screenshot.SetPixels(webcamTexture.GetPixels());
            screenshot.Apply();
            return screenshot;  // Returns the captured screenshot
        }

        Debug.LogError("Webcam texture is not available or not playing.");
        return null;
    }
}
