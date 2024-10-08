using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.Interaction.Toolkit;
using System.Collections.Generic;
using UnityEngine.XR.ARSubsystems;

public class ARObjectSpawner : MonoBehaviour
{
    public GameObject objectToSpawn; 
    private ARRaycastManager raycastManager;
    private List<ARRaycastHit> hits = new List<ARRaycastHit>();
    private GameObject spawnedObject;

   
    public ShaderController shaderController;
    public float cloudSpawnHeight = 5.0f;
    public Vector3 initialScale = new Vector3(0.1f, 0.1f, 0.1f);
    public float scaleFactor = 0.1f;
    public XRRayInteractor rayInteractor;


    public UnityEngine.InputSystem.InputAction spawnAction;

    void Start()
    {
        raycastManager = GetComponent<ARRaycastManager>();
        if (rayInteractor == null)
        {
            Debug.LogError("XRRayInteractor is not assigned.");
        }
        // Enable the input action
        spawnAction.Enable();
    }

    void Update()
    {
        HandleRayInteractorInput();
        HandleTouchInput();
        if (spawnAction.triggered)
        {
            SpawnObjectWithController();
        }
    }

    void SpawnObjectWithController()
    {
        Vector3 rayOrigin = rayInteractor.transform.position;
        Vector3 rayDirection = rayInteractor.transform.forward;

        RaycastHit hitInfo;
        if (Physics.Raycast(rayOrigin, rayDirection, out hitInfo))
        {
            Pose hitPose = new Pose(hitInfo.point, Quaternion.identity);

            if (spawnedObject == null)
            {
                spawnedObject = Instantiate(objectToSpawn, hitPose.position, hitPose.rotation);
                spawnedObject.transform.localScale = initialScale; // Set the initial scale
            }
            else
            {
                // Move the existing object to the new position
                spawnedObject.transform.position = hitPose.position;
                spawnedObject.transform.rotation = hitPose.rotation;
            }
        }
    }

    void HandleRayInteractorInput()
    {
        if (rayInteractor != null)
        {
            // Resizing the object with controller input
            if (spawnedObject != null)
            {
                if (Input.GetKey(KeyCode.UpArrow)) 
                {
                    spawnedObject.transform.localScale += new Vector3(scaleFactor, scaleFactor, scaleFactor);
                }
                if (Input.GetKey(KeyCode.DownArrow)) 
                {
                    spawnedObject.transform.localScale -= new Vector3(scaleFactor, scaleFactor, scaleFactor);
                }
            }
        }
    }

    void HandleTouchInput()
    {
        if ((Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Began) || Input.GetMouseButtonDown(0))
        {
            // Perform AR Raycast
            Vector2 touchPosition;
                touchPosition = Input.mousePosition;
            

            if (raycastManager.Raycast(touchPosition, hits, TrackableType.Planes))
            {
                // Get the hit position and rotation
                Pose hitPose = hits[0].pose;

                if (spawnedObject == null)
                {
                    // Instantiate the object if it hasn't been spawned
                    spawnedObject = Instantiate(objectToSpawn, hitPose.position, hitPose.rotation);
                    spawnedObject.transform.localScale = initialScale;
                }
                else
                {
                    // Move the object to the new hit position
                    spawnedObject.transform.position = hitPose.position;
                    spawnedObject.transform.rotation = hitPose.rotation;
                }
            }
        }
    }

    public void Reset()
    {
        if (spawnedObject != null)
        {
            Destroy(spawnedObject);
            spawnedObject = null; 
            shaderController.ResetClouds();
        }
    }
}
