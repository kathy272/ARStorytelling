using System.Diagnostics;
using System.IO;
using UnityEngine;
using System.Collections.Generic;

public class ColorDetection : MonoBehaviour
{
    // Path to the Python script
    public string pythonScriptPath = "Python/color_detection.py";

    // Path to the file where Python will save the results (JSON)
    public string outputFilePath = "Assets/Scripts/pink_areas.json";

    // Prefab to use for the cubes
    public GameObject cubePrefab;

    // Reference to the map/plane object where the cubes should be placed
    public GameObject mapPlane;
    public float gridSpacing = 1f;
    // Reference to the WebcamDisplay script
    public WebcamDisplay webcamDisplay;

    // Method to call Python script
    public void RunPythonScript()
    {
        // Create a new process to run the Python script
        ProcessStartInfo processInfo = new ProcessStartInfo();
        processInfo.FileName = "python"; // Use 'python3' if needed, depending on your environment
        processInfo.Arguments = pythonScriptPath;
        processInfo.RedirectStandardOutput = true;
        processInfo.UseShellExecute = false;
        processInfo.CreateNoWindow = true;

        try
        {
            // Refresh assets
            UnityEditor.AssetDatabase.Refresh();
            // Start the process
            using (Process process = Process.Start(processInfo))
            {
                // Wait for the script to finish
                process.WaitForExit();

                // Check if the Python script generated the expected output file
                if (File.Exists(outputFilePath))
                {
                    // Read the output data (assuming it's in JSON format)
                    string json = File.ReadAllText(outputFilePath);

                    // Parse the JSON and create cubes
                    UnityEngine.Debug.Log("Python script executed successfully. Data: " + json);
                    CreateCubesFromData(json);
                }
                else
                {
                    UnityEngine.Debug.LogError("Output file not found: " + outputFilePath);
                }
            }
        }
        catch (System.Exception e)
        {
            UnityEngine.Debug.LogError("Error running Python script: " + e.Message);
        }
    }
    private void CreateCubesFromData(string jsonData)
    {
        // Parse the JSON data into a PositionList object
        PositionList data = JsonUtility.FromJson<PositionList>(jsonData);

        // Get the dimensions of the image from the webcam texture
        int imageWidth = webcamDisplay.renderTexture.width;
        int imageHeight = webcamDisplay.renderTexture.height;

        // Get the position and size of the map/plane in the Unity world
        Vector3 mapPosition = mapPlane.transform.position;
        Vector3 mapScale = mapPlane.transform.localScale;

        // Create a set to track used positions
        HashSet<Vector3Int> usedPositions = new HashSet<Vector3Int>();

        // Iterate over each position and spawn a cube
        foreach (var pos in data.positions)
        {
            // Convert image coordinates to Unity world space
            Vector3 worldPosition = ConvertImageCoordsToWorld(pos.x, pos.y, pos.z, imageWidth, imageHeight, mapPosition, mapScale);

            // Snap position to grid
            Vector3Int gridPosition = new Vector3Int(
                Mathf.RoundToInt(worldPosition.x / gridSpacing),
                Mathf.RoundToInt(worldPosition.y / gridSpacing),
                Mathf.RoundToInt(worldPosition.z / gridSpacing)
            );

            // Check if this grid position has already been used
            if (!usedPositions.Contains(gridPosition))
            {
                // Add to used positions and spawn the cube
                usedPositions.Add(gridPosition);
                GameObject cube = Instantiate(cubePrefab, worldPosition, Quaternion.identity);
                cube.transform.parent = mapPlane.transform; // Ensure the cube moves with the map
            }
        }
    }
        // Convert 2D image coordinates to Unity world space
        private Vector3 ConvertImageCoordsToWorld(float x, float y, float z, int imageWidth, int imageHeight, Vector3 mapPosition, Vector3 mapScale)
    {

        // Normalize the image coordinates to a range between 0 and 1
        float normalizedX = x / imageWidth;
        float normalizedZ = z / imageHeight;       

        // Map normalized coordinates to the scale of the map/plane
        float worldX = mapPosition.x + (normalizedX * mapScale.x) - (mapScale.x / 2);
        float worldZ = mapPosition.z + (normalizedZ * mapScale.z) - (mapScale.z / 2);

        float worldY = mapPosition.y +1;
        UnityEngine.Debug.Log($"y: {mapPosition.y}, {mapPosition.x}, {mapPosition.z}");
        UnityEngine.Debug.Log($"Normalized Coordinates: ({normalizedX}, {normalizedZ})");
        UnityEngine.Debug.Log($"World Coordinates: ({worldX}, {worldY}, {worldZ})");

        // Return the calculated world position
        return new Vector3(worldX, worldY, worldZ);

    }



    // Class to represent a single position (x, y, z)
    [System.Serializable]
    public class PositionData
    {
        public float x;
        public float y;
        public float z; // Add z
    }
    // Class to represent a list of positions
    [System.Serializable]
    public class PositionList
    {
        public List<PositionData> positions;
    }

    // Call this method to test running the Python script
    void SpawnObj()
    {
        if (webcamDisplay != null)
        {
            RunPythonScript();
        }
        else
        {
            UnityEngine.Debug.LogError("WebcamDisplay script is not assigned.");
        }
    }
}
