using UnityEngine;

public class PinMarkerController : MonoBehaviour
{
    //unneccessary
    public GameObject pinUIPrefab;  // Ensure this is declared only once and no conflicts with other scripts
    public RectTransform cameraFeedRect;
    public Camera mainCamera;
    public Transform terrain;

    public void PlacePin(Vector2 screenPosition)
    {
        Vector3 worldPosition = ScreenToWorld(screenPosition);

        GameObject pin = Instantiate(pinUIPrefab, worldPosition, Quaternion.identity, terrain);
        AdjustPinForZoomAndPan(pin);
    }

    Vector3 ScreenToWorld(Vector2 screenPosition)
    {
        Vector3 localPos = cameraFeedRect.InverseTransformPoint(screenPosition);
        Vector3 worldPos = terrain.TransformPoint(localPos);
        return worldPos;
    }

    void AdjustPinForZoomAndPan(GameObject pin)
    {

        // Logic to adjust pin placement based on zoom/pan
    }
}
