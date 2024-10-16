using UnityEngine;
using UnityEngine.XR.ARFoundation;
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

    public UnityEngine.InputSystem.InputAction spawnAction;

    void Start()
    {
        raycastManager = GetComponent<ARRaycastManager>();

        spawnAction.Enable();
    }

    void Update()
    {
        HandleTouchInput();

        if (spawnAction.triggered)
        {
            SpawnObjectWithManualInput();
        }
    }

    void SpawnObjectWithManualInput()
    {
        Debug.Log("Manual spawn input received.");
    }

    void HandleTouchInput()
    {
        if ((Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Began) || Input.GetMouseButtonDown(0))
        {
            Vector2 touchPosition = Input.mousePosition;

            if (raycastManager.Raycast(touchPosition, hits, TrackableType.Planes))
            {
                Pose hitPose = hits[0].pose;

                if (spawnedObject == null)
                {
                    spawnedObject = Instantiate(objectToSpawn, hitPose.position, hitPose.rotation);
                    spawnedObject.transform.localScale = initialScale;
                }
                else
                {
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
