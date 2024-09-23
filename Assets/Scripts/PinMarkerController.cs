using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.InputSystem; // For touch support in Unity's new Input system
using System.Collections.Generic;
using UnityEngine.UI;


public class PinMarkerController : MonoBehaviour
{
    public GameObject pinPrefab;  // Prefab of the pin mesh
    public Camera arCamera;  // Reference to the AR or scene camera
    public LayerMask mapLayer;  // Layer of the terrain or map
    private ARRaycastManager raycastManager;
    public Button placePinButton; // Button to enable pin placement mode
    private bool isPinPlacementMode = false;

    void Start()
    {
        placePinButton.onClick.AddListener(EnablePinPlacementMode);

        raycastManager = FindObjectOfType<ARRaycastManager>();
    }
    void EnablePinPlacementMode()
    {
        isPinPlacementMode = true; // Enable pin placement mode
    }
    void Update()
    {
        // For AR (Touch or marker-based placement)
        if (isPinPlacementMode && Input.touchCount > 0)
        {
            Touch touch = Input.GetTouch(0);
            if (touch.phase == UnityEngine.TouchPhase.Began)
            {
                TryPlacePin(touch.position);
                isPinPlacementMode = false;
            }
        }

        // For 3D scene or PC (Mouse-based placement)
        if (isPinPlacementMode && Input.GetMouseButtonDown(0))
        {
            TryPlacePin(Input.mousePosition);
            isPinPlacementMode = false;
        }
    }

    // Function to place a pin based on a screen position
    void TryPlacePin(Vector2 screenPosition)
    {
        // AR: Raycast in the AR environment to detect planes/markers
        List<ARRaycastHit> hits = new List<ARRaycastHit>();
        if (raycastManager.Raycast(screenPosition, hits, UnityEngine.XR.ARSubsystems.TrackableType.Planes))
        {
            // Get the position where the raycast hit the AR plane/marker
            Pose hitPose = hits[0].pose;

            // Instantiate the pin mesh at that position
            Instantiate(pinPrefab, hitPose.position, hitPose.rotation);
        }
        else
        {
            // 3D Scene: Raycast into the 3D world (e.g., terrain or map)
            Ray ray = arCamera.ScreenPointToRay(screenPosition);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit, Mathf.Infinity, mapLayer))
            {
                // Instantiate the pin mesh at the position where the ray hit the terrain/map
                Instantiate(pinPrefab, hit.point, Quaternion.identity);
            }
        }
    }
}
