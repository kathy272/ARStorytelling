using UnityEngine;

public class PinFollowMesh : MonoBehaviour
{
    public Mesh terrainMesh; // Reference to the mesh used for the terrain
    public Transform terrainTransform; // Transform of the terrain object

    private MeshFilter meshFilter;
    private Vector3[] vertices;

    void Start()
    {
        meshFilter = terrainTransform.GetComponent<MeshFilter>();
        vertices = meshFilter.mesh.vertices;
    }

    void Update()
    {
        UpdatePinPosition();
    }

    void UpdatePinPosition()
    {
        if (terrainMesh == null || meshFilter == null)
            return;

        // Convert world position to local position
        Vector3 localPosition = terrainTransform.InverseTransformPoint(transform.position);
        float x = localPosition.x;
        float z = localPosition.z;

        // Calculate the index in the mesh vertices array
        int xIndex = Mathf.FloorToInt(x);
        int zIndex = Mathf.FloorToInt(z);

        // Ensure indices are within bounds
        xIndex = Mathf.Clamp(xIndex, 0, terrainMesh.vertexCount - 1);
        zIndex = Mathf.Clamp(zIndex, 0, terrainMesh.vertexCount - 1);

        // Get the height at the given (x, z) position
        float terrainHeight = vertices[xIndex + zIndex * (int)Mathf.Sqrt(terrainMesh.vertexCount)].y;

        // Update the pin position
        Vector3 newPosition = transform.position;
        newPosition.y = terrainHeight;
        transform.position = newPosition;
    }
}
