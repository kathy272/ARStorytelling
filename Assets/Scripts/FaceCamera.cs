using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FaceCamera : MonoBehaviour
{
    public Camera cameraToLookAt; // The camera to face

    void Update()
    {
        if (cameraToLookAt != null)
        {
            // Rotate the UI to face the camera
            Vector3 direction = (cameraToLookAt.transform.position - transform.position).normalized;
            Quaternion lookRotation = Quaternion.LookRotation(-direction);
            transform.rotation = Quaternion.Euler(0, lookRotation.eulerAngles.y, 0); // Rotate only around Y axis
        }
    }
}
