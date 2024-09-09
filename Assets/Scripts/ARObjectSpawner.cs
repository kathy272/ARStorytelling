using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;
using System.Collections.Generic;

public class ARObjectSpawner : MonoBehaviour
{
    public GameObject objectToSpawn; // The object to spawn
    private ARRaycastManager raycastManager;
    private List<ARRaycastHit> hits = new List<ARRaycastHit>();
    private GameObject spawnedObject;
    // Height offset for spawning clouds
    public float cloudSpawnHeight = 5.0f;
    // Initial scale of the object
    public Vector3 initialScale = new Vector3(0.1f, 0.1f, 0.1f);

    // Scale increment/decrement factor
    public float scaleFactor = 0.1f;
    public Vector3 cloudinitialScale = new Vector3(0.1f, 0.1f, 0.1f);

    void Start()
    {
        raycastManager = GetComponent<ARRaycastManager>();
    }

    void Update()
    {
        // Handle touch input on mobile or click input on desktop
        if (Input.touchCount > 0 || Input.GetMouseButtonDown(0))
        {
            Vector2 touchPosition;

            // Check if the input is touch or mouse click
            if (Input.touchCount > 0)
            {
                touchPosition = Input.GetTouch(0).position;
            }
            else
            {
                touchPosition = Input.mousePosition;
            }

            // Perform a raycast from the input position
            if (raycastManager.Raycast(touchPosition, hits, TrackableType.PlaneWithinPolygon))
            {
                Pose hitPose = hits[0].pose;

                // If no object has been spawned yet, instantiate the object
                if (spawnedObject == null)
                {
                    spawnedObject = Instantiate(objectToSpawn, hitPose.position, hitPose.rotation);
                    spawnedObject.transform.localScale = initialScale; // Set the initial scale
                }
                else
                {
                    // If an object has already been spawned, move it to the new position
                    spawnedObject.transform.position = hitPose.position;
                    spawnedObject.transform.rotation = hitPose.rotation;
                }
            }
        }

        // Resizing the object with keyboard input (for testing in the Editor)
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
    // Get the position for spawning clouds above the environment
    public Vector3 GetCloudSpawnPosition()
    {
        if (spawnedObject != null)
        {
            return spawnedObject.transform.position + Vector3.up * cloudSpawnHeight;
            

        }
        return Vector3.zero; // Default position if no object has been spawned
    }
}

