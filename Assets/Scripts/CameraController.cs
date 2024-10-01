using UnityEngine;

public class CameraController : MonoBehaviour
{
    public Transform cameraFeedTransform; 
    public float zoomFactor = 1.0f; 

    public void UpdateZoom(float newZoomFactor)
    {
        zoomFactor = newZoomFactor;
        cameraFeedTransform.localScale = new Vector3(zoomFactor, zoomFactor, 1);
        UpdatePins();
    }

    public void UpdatePan(Vector2 panOffset)
    {
        cameraFeedTransform.localPosition += new Vector3(panOffset.x, panOffset.y, 0);
        UpdatePins();
    }

    void UpdatePins()
    {
    }
}
