using Klak.Ndi;
using UnityEngine;
using UnityEngine.UI;

public class DebugCanvasManager : MonoBehaviour
{
    public Text debugText;  // Reference to the text component
    public NdiReceiver ndiReceiver;  // Reference to the NDI receiver

    void Start()
    {
        // Start by displaying a basic message
        debugText.text = "Starting App...";
    }

    void Update()
    {
        // Update the text with useful debugging info
        if (NDIReceiverIsConnected())  // Check the NDI connection status
        {
            debugText.text = "NDI feed connected";
        }
        else
        {
            debugText.text = "NDI feed not connected";
        }
    }

    // Check the NDI connection status by verifying the texture
    bool NDIReceiverIsConnected()
    {
        // Check if the NDI receiver is not null and if it has a valid texture
        if (ndiReceiver != null)
        {
            return ndiReceiver.texture != null; // Check if the texture is not null
        }
        return false;  // Return false if ndiReceiver is not set
    }

    // Method to log additional information
    public void LogInfo(string message)
    {
        debugText.text = message;
    }
}
