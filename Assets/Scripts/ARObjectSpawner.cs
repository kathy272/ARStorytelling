using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.Interaction.Toolkit;
using System.Collections.Generic;
using UnityEngine.XR.ARSubsystems;

public class ARObjectSpawner : MonoBehaviour
{
    public GameObject objectToSpawn; // The object to spawn
    private ARRaycastManager raycastManager;
    private List<ARRaycastHit> hits = new List<ARRaycastHit>();
    private GameObject spawnedObject;

    // Reference to shadercontroller script
    public ShaderController shaderController;

    // Height offset for spawning clouds
    public float cloudSpawnHeight = 5.0f;

    // Initial scale of the object
    public Vector3 initialScale = new Vector3(0.1f, 0.1f, 0.1f);

    // Scale increment/decrement factor
    public float scaleFactor = 0.1f;

    // Reference to the XR Ray Interactor
    public XRRayInteractor rayInteractor;

   

    // Define a button to spawn the object
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
        // Check for controller input
        HandleRayInteractorInput();

        // Check for screen taps or clicks
        HandleTouchInput();

        // Check if the spawn action is triggered
        if (spawnAction.triggered)
        {
            SpawnObjectWithController();
        }
    }

    void SpawnObjectWithController()
    {
        // Perform a raycast from the XRRayInteractor
        Vector3 rayOrigin = rayInteractor.transform.position;
        Vector3 rayDirection = rayInteractor.transform.forward;

        RaycastHit hitInfo;
        if (Physics.Raycast(rayOrigin, rayDirection, out hitInfo))
        {
            Pose hitPose = new Pose(hitInfo.point, Quaternion.identity);

            // If no object has been spawned yet, instantiate the object
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
                if (Input.GetKey(KeyCode.UpArrow)) // Replace this with controller input if needed
                {
                    spawnedObject.transform.localScale += new Vector3(scaleFactor, scaleFactor, scaleFactor);
                }
                if (Input.GetKey(KeyCode.DownArrow)) // Replace this with controller input if needed
                {
                    spawnedObject.transform.localScale -= new Vector3(scaleFactor, scaleFactor, scaleFactor);
                }
            }
        }
    }

    void HandleTouchInput()
    {
        // Check for a touch or left mouse button click
        if ((Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Began) || Input.GetMouseButtonDown(0))
        {
            // Perform AR Raycast
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
            // Destroy the currently spawned object
            Destroy(spawnedObject);
            spawnedObject = null; // Reset the reference to allow a new object to be spawned
            shaderController.ResetClouds();
        }
    }
}
