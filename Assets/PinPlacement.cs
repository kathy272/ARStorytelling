using UnityEngine;
using UnityEngine.UI;

public class PinPlacement : MonoBehaviour
{
    public GameObject pinPrefab; // Pin prefab
    public Camera arCamera;      // AR or main camera
    public Button placePinButton; // Button to enable pin placement mode
    private bool isPinPlacementMode = false;

    void Start()
    {
        placePinButton.onClick.AddListener(EnablePinPlacementMode);
    }

    void Update()
    {
        if (isPinPlacementMode && Input.GetMouseButtonDown(0))
        {
            Ray ray = arCamera.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit))
            {
                GameObject pin = Instantiate(pinPrefab, hit.point, Quaternion.identity);

                isPinPlacementMode = false; // Exit pin placement mode
            }
        }

    }

    void EnablePinPlacementMode()
    {
        isPinPlacementMode = true; // Enable pin placement mode
    }
}

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
