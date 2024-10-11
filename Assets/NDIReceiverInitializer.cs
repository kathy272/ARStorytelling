using UnityEngine;
using Klak.Ndi;

public class NDIReceiverInitializer : MonoBehaviour
{
    private NdiReceiver ndiReceiver;

    void Start()
    {
        // Get the NdiReceiver component 
        ndiReceiver = GetComponent<NdiReceiver>();

        // Check if the receiver is available
        if (ndiReceiver != null)
        {
            // Log initialization status
            Debug.Log("NDI Receiver initialized.");
            ndiReceiver.enabled = true; 
        }
        else
        {
            Debug.LogError("NDI Receiver component not found!");
        }
    }

    void Update()
    {
        // Check if the texture is being updated
        if (ndiReceiver.texture != null)
        {
            Debug.Log("NDI texture received.");
        }
        else
        {
            Debug.Log("NDI texture is null.");
        }
    }
}
