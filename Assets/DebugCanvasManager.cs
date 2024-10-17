using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.UI;

public class DebugCanvasManager : MonoBehaviour
{
    public Text debugText;  // Reference to the text component
    private ARTrackedImageManager trackedImageManager;

    void Start()
    {
        // Get the ARTrackedImageManager component
        trackedImageManager = FindObjectOfType<ARTrackedImageManager>();
        debugText.text = "Starting AR Tracking...";
    }

    void OnEnable()
    {
        if (trackedImageManager != null)
        {
            trackedImageManager.trackedImagesChanged += OnTrackedImagesChanged;
            debugText.text = "AR Tracking enabled.";
        }
    }

    void OnDisable()
    {
        if (trackedImageManager != null)
        {
            trackedImageManager.trackedImagesChanged -= OnTrackedImagesChanged;
            debugText.text = "AR Tracking disabled.";
        }
    }

    // Handle changes in tracked images
    private void OnTrackedImagesChanged(ARTrackedImagesChangedEventArgs eventArgs)
    {
        foreach (var trackedImage in eventArgs.added)
        {
            debugText.text = $"Image {trackedImage.referenceImage.name} detected.";
        }

        foreach (var trackedImage in eventArgs.updated)
        {
            if (trackedImage.trackingState == UnityEngine.XR.ARSubsystems.TrackingState.Tracking)
            {
                debugText.text = $"Tracking {trackedImage.referenceImage.name}.";
            }
            else
            {
                debugText.text = $"Lost tracking of {trackedImage.referenceImage.name}.";
            }
        }

        foreach (var trackedImage in eventArgs.removed)
        {
            debugText.text = $"Image {trackedImage.referenceImage.name} removed.";
        }
    }

    // Method to log additional information
    public void LogInfo(string message)
    {
        debugText.text = message;
    }
}
