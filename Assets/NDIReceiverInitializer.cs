using UnityEngine;
using Klak.Ndi;

public class NDIReceiverInitializer : MonoBehaviour
{
    public NdiReceiver ndiReceiver;

    void Start()
    {
        if (ndiReceiver != null)
        {
            Debug.Log("NDI Receiver initialized.");
            if (string.IsNullOrEmpty(ndiReceiver.ndiName))
            {
                Debug.LogError("NDI source not assigned.");
            }
            else
            {
                Debug.Log("Using NDI source: " + ndiReceiver.ndiName);
            }

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

            Renderer renderer = ndiReceiver.GetComponent<Renderer>(); // Get the Renderer component
            if (renderer != null)
            {
                renderer.material.mainTexture = ndiReceiver.texture; // Assign the NDI texture to the material
            }
            else
            {
                Debug.LogError("Renderer component not found on NDI Receiver GameObject.");
            }
        }
        else
        {
            Debug.Log("NDI texture is null.");
        }
    }
}
