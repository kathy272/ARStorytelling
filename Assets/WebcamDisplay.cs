using UnityEngine;

public class WebcamDisplay : MonoBehaviour
{
    public RenderTexture renderTexture; // Assign this in the Inspector
    public int webcamIndex = 1; // Index of the desired webcam
    public float updateInterval = 1f; // Time between updates

    private WebCamTexture webcamTexture;
    private Texture2D texture2D;
    private Color[] pixelData;
    private float timer;

    void Start()
    {
        WebCamDevice[] devices = WebCamTexture.devices;

   
               // webcamTexture = new WebCamTexture(devices[webcamIndex].name);
                //webcamTexture.Play();
               // texture2D = new Texture2D(webcamTexture.width, webcamTexture.height);

    }

    void Update()
    {
    
       

        timer += Time.deltaTime;
        if (timer >= updateInterval)
        {
            timer = 0f;

            // Read pixels from the webcam texture
            texture2D.SetPixels(webcamTexture.GetPixels());
            texture2D.Apply();

            // Copy texture data to render texture
            Graphics.Blit(texture2D, renderTexture);

            // Optionally: Save pixel data for averaging
            pixelData = texture2D.GetPixels();
        }
    }

    public Color[] GetPixelData()
    {
        return pixelData;
    }
}
