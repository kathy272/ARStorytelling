using UnityEngine;
using UnityEngine.UI;

public class VirtualWebcamHandler : MonoBehaviour
{
    public RenderTexture renderTexture;
    public RawImage displayImage;
    public string virtualCamName = "OBS Virtual Camera";

    private WebCamTexture webcamTexture;
    private Texture2D texture2D;

    void Start()
    {
        WebCamDevice[] devices = WebCamTexture.devices;

 
        foreach (var device in devices)
        {
            Debug.Log("Device name: " + device.name);
        }

        // Look for the specific virtual camera by name
        foreach (var device in devices)
        {
            if (device.name == virtualCamName)
            {
                webcamTexture = new WebCamTexture(device.name);
                webcamTexture.Play();

                if (webcamTexture.width > 0 && webcamTexture.height > 0)
                {
                    texture2D = new Texture2D(webcamTexture.width, webcamTexture.height);
                    Debug.Log("Virtual camera dimensions: " + webcamTexture.width + "x" + webcamTexture.height);
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
            Debug.LogWarning("Webcam texture is not playing or not initialized.");
            return;
        }

        // Only proceed if texture2D was successfully initialized
        if (texture2D == null)
        {
            Debug.LogError("texture2D is not initialized.");
            return;
        }

        // Capture and apply the webcam texture to the renderTexture
        texture2D.SetPixels(webcamTexture.GetPixels());
        texture2D.Apply();

        if (renderTexture != null)
        {
            Debug.Log("Blitting texture to render texture.");
            Graphics.Blit(texture2D, renderTexture);
            displayImage.texture = renderTexture;
        }
        else
        {
            Debug.LogError("RenderTexture is not assigned.");
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
