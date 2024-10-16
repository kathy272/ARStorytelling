using UnityEngine;
using UnityEngine.XR.ARFoundation;

public class MarkerDetection : MonoBehaviour
{
    [SerializeField]
    private GameObject objectToSpawn; 

    private ARTrackedImageManager trackedImageManager;

    void Awake()
    {
        trackedImageManager = GetComponent<ARTrackedImageManager>();
    }

    void OnEnable()
    {
        trackedImageManager.trackedImagesChanged += OnTrackedImagesChanged;
    }

    void OnDisable()
    {
        trackedImageManager.trackedImagesChanged -= OnTrackedImagesChanged;
    }

    private void OnTrackedImagesChanged(ARTrackedImagesChangedEventArgs eventArgs)
    {
        // Iterate through added tracked images
        foreach (var trackedImage in eventArgs.added)
        {
            SpawnObject(trackedImage);
        }

        // Iterate through updated tracked images
        foreach (var trackedImage in eventArgs.updated)
        {
            // Update the object's position and rotation based on the tracked image's pose
            UpdateObjectPosition(trackedImage);
        }

        foreach (var trackedImage in eventArgs.removed)
        {
            Destroy(trackedImage.gameObject);
        }
    }

    private void SpawnObject(ARTrackedImage trackedImage)
    {
        // Spawn the object at the position of the tracked image
        if (objectToSpawn != null)
        {
            Instantiate(objectToSpawn, trackedImage.transform.position, trackedImage.transform.rotation);
        }
    }

    private void UpdateObjectPosition(ARTrackedImage trackedImage)
    {
        // Update the position and rotation of the object if needed
        if (trackedImage.trackingState == UnityEngine.XR.ARSubsystems.TrackingState.Tracking)
        {
        }
    }
}
