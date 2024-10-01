using UnityEngine;

public class ScreenshotHandler : MonoBehaviour
{
    public VirtualWebcamHandler webcamHandler;  // Assign in the Inspector
    private Texture2D screenshot; // Store the screenshot

    public void TakeScreenshot()
    {
        screenshot = webcamHandler.CaptureScreenshot();
        if (screenshot != null)
        {
            // Save the screenshot as a file
            byte[] bytes = screenshot.EncodeToPNG();
            System.IO.File.WriteAllBytes(Application.persistentDataPath + "/screenshot.png", bytes);
            Debug.Log("Screenshot saved to: " + Application.persistentDataPath + "/screenshot.png");
        }
    }

    public Texture2D GetScreenshot()
    {
        if (screenshot == null)
        {
            Debug.LogError("Screenshot has not been captured yet.");
        }
        return screenshot;

    }
}
