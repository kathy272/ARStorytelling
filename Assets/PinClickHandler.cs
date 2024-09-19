using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;
using UnityEngine.XR.Interaction.Toolkit;
using System.Collections.Generic;

public class PinClickHandler : MonoBehaviour
{
    public GameObject floatingUI; // Reference to the floating UI canvas
    public ARRaycastManager raycastManager; // Reference to the AR Raycast Manager
    public GameObject pinMesh; // Reference to the pin mesh
    public Camera arCamera;      // AR or main camera

    private bool isUIVisible = false;
    private List<ARRaycastHit> hits = new List<ARRaycastHit>(); // List to store raycast hits

    void Start()
    {
        floatingUI.SetActive(false);

        // Make sure the UI is initially hidden
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(0) || (Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Began))
        {
            Vector2 touchPosition;

            // For mobile touch
            if (Input.touchCount > 0)
            {
                touchPosition = Input.GetTouch(0).position;
            }
            // For mouse clicks
            else
            {
                touchPosition = Input.mousePosition;
            }

            Ray ray = Camera.main.ScreenPointToRay(touchPosition);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit))
            {
                // Check if the raycast hit the pin mesh
                if (hit.transform == pinMesh.transform)
                {
                    Transform uiTransform = hit.transform.Find("FloatingUI");
                    floatingUI.SetActive(true);
                    floatingUI.transform.localScale = new Vector3(0.005f, 0.005f, 0.005f);
                    floatingUI.transform.position = hit.transform.position + Vector3.up * 0.5f;
                    FaceCamera faceCamera = floatingUI.AddComponent<FaceCamera>();
                    faceCamera.cameraToLookAt = arCamera;
                                 }
            }
        }
    }
    public void HideUI()
    {
        floatingUI.SetActive(false);
    }
}
