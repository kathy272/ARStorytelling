using System.Collections.Generic;
using UnityEngine;

public class PinFollowMesh : MonoBehaviour
{
    public Transform terrainPlane; // The plane representing the terrain or the 3D mesh
    public GameObject pinPrefab;   // Prefab for the pins/markers
    public List<Vector2> pinPositions; // List of 2D positions where pins need to be placed (UV coordinates)

    private List<GameObject> pinMeshes = new List<GameObject>(); // List to hold instantiated pin meshes
    Vector3 GetWorldPositionFromUV(Vector2 uv)
    {
        // Get the terrain plane's bounds
        Renderer terrainRenderer = terrainPlane.GetComponent<Renderer>();
        Bounds terrainBounds = terrainRenderer.bounds;

        // Convert UV coordinates to world position on the terrain plane
        float xPosition = Mathf.Lerp(terrainBounds.min.x, terrainBounds.max.x, uv.x);
        float zPosition = Mathf.Lerp(terrainBounds.min.z, terrainBounds.max.z, uv.y);

        // Keep the y position at the terrain's surface level
        float yPosition = terrainBounds.center.y;

        return new Vector3(xPosition, yPosition, zPosition);
    }
    void Update()
    {
        if (terrainPlane.hasChanged) // Only update if the terrain moves or transforms
        {
            UpdatePinPositions();
            terrainPlane.hasChanged = false;
        }
    }

    // Method to update the pin positions based on terrain movement
    void UpdatePinPositions()
    {
        for (int i = 0; i < pinPositions.Count; i++)
        {
            Vector3 newWorldPosition = GetWorldPositionFromUV(pinPositions[i]);
            pinMeshes[i].transform.position = newWorldPosition;
        }
    }
}