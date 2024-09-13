using UnityEngine;

public class CameraStabilizer : MonoBehaviour
{
    public float smoothTime = 0.1f; // Time to smooth out
    private Vector3 velocity = Vector3.zero; // Velocity of smoothing

    public Transform cameraTransform; // Reference to the camera's transform

    void Update()
    {
        // Smooth the position of the camera
        if (cameraTransform != null)
        {
            cameraTransform.position = Vector3.SmoothDamp(cameraTransform.position, cameraTransform.position, ref velocity, smoothTime);
        }
    }
}
