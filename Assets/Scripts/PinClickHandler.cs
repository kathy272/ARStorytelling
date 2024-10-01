using UnityEngine;
using UnityEngine.XR.ARFoundation;
using System.Collections.Generic;



public class PinClickHandler : MonoBehaviour
{
    public GameObject floatingUI; 
    public ARRaycastManager raycastManager; 
    public GameObject pinMesh;
    public Camera arCamera;         

    private bool isUIVisible = false;
    private List<ARRaycastHit> hits = new List<ARRaycastHit>(); // List to store raycast hits

    void Start()
    {
        floatingUI.SetActive(false);

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
                    Debug.Log("Pin clicked");
                    floatingUI.SetActive(true);
                    floatingUI.transform.localScale = new Vector3(0.005f, 0.005f, 0.005f);
                    floatingUI.transform.position = hit.transform.position + Vector3.up * 1f;
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
