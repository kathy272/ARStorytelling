using UnityEngine;
using UnityEngine.UI;

public class PinPlacement : MonoBehaviour
{
    public GameObject pinPrefab;
    public Camera arCamera;
    public Button takeScreenshotButton;
    public ScreenshotHandler screenshotHandler;

   
    public Button placePinBtn;
    private bool isPlacingPin = false;
    private Transform terrain;
    public GameObject terrainObject;
    private Texture2D screenshot;
    private GameObject terrainClone;

    void Start()
    {
        placePinBtn.onClick.AddListener(EnablePinPlacementMode);
        takeScreenshotButton.onClick.AddListener(OnTakeScreenshot);
    }

    public void EnablePinPlacementMode()
    {
        Debug.Log("Pin placement mode enabled.");
        isPlacingPin = true;
    }

    void Update()
    {
        if (isPlacingPin && Input.GetMouseButtonDown(0))
        {
            screenshot = screenshotHandler.GetScreenshot();
            Debug.Log("The screenshot is: " + screenshot);

            Debug.Log("Mouse button clicked");
            if (screenshot != null)
            {
                Vector2 screenPosition = Input.mousePosition;
                TryPlacePin(screenPosition);
            }
            else
            {
                Debug.LogWarning("Screenshot not captured or retrieved.");
                Vector2 screenPosition = Input.mousePosition;
                TryPlacePin(screenPosition);
            }
        }
    }

    private void OnTakeScreenshot()
    {
        screenshotHandler.TakeScreenshot();
        screenshot = screenshotHandler.GetScreenshot();

        if (screenshot == null)
        {
            Debug.LogError("Failed to capture or retrieve screenshot.");
        }
    }

    private void TryPlacePin(Vector2 screenPosition)
    {
        Debug.Log("Trying to place pin at screen position: " + screenPosition);
        // Find the terrain object named "Terrain(Clone)"
        // GameObject terrainObject = GameObject.Find("Terrain(Clone)");
        terrainClone = GameObject.Find("MenuAndTerrain(Clone)");
        if (terrainClone != null)
        {
            terrain = terrainClone.transform;
            Debug.Log("Terrain found: " + terrain.name);
        }
        else
        {
            Debug.LogError("Terrain(Clone) not found!");
            return;
        }

        // Convert screen position to a ray
        Ray ray = arCamera.ScreenPointToRay(screenPosition);
        RaycastHit hit;

        // Perform raycast to check if the click is on the terrain
        if (Physics.Raycast(ray, out hit))
        {

            // Check if the hit object is the terrain
            if (hit.collider.CompareTag("Terrain"))
            {
                PlacePin(hit.point);
            }
            else
            {
                Debug.LogWarning("Click was not on the terrain.");
                PlacePin(hit.point);

            }
        }
        else
        {
            Debug.LogWarning("Raycast did not hit any object.");
        }
    }

    private void PlacePin(Vector3 position)
    {
        GameObject pin = Instantiate(pinPrefab, position, Quaternion.identity);
        Debug.Log("Pin placed at: " + position);
        isPlacingPin = false; // Disable pin placement mode after placing
    }
}
