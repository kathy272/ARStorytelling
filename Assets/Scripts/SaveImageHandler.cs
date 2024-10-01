using System.IO;
using UnityEngine;
using UnityEngine.UI;

public class SaveImageHandler : MonoBehaviour
{
    public string generatedImagePath; // Path to the generated image
    public string savedImagesFolderPath; // Path to the folder where saved images will be stored
    public Button saveButton; // Reference to the save button
    public GameObject previewUI;
    public GameObject generatedImageUI;
    public GameObject savedImageUI;

  
    void Start()
    {
        previewUI.gameObject.SetActive(true);
        generatedImageUI.gameObject.SetActive(false);
        savedImageUI.gameObject.SetActive(false);
        saveButton.onClick.AddListener(SaveImage);

    }
    void SaveImage()
    {
        // Ensure paths are correct
        if (string.IsNullOrEmpty(generatedImagePath) || string.IsNullOrEmpty(savedImagesFolderPath))
        {
            Debug.LogError("Paths not set.");
            return;
        }

        // Check if the generated image exists
        if (!File.Exists(generatedImagePath))
        {
            Debug.LogError("Generated image not found.");
            return;
        }

        // Create the saved images folder if it doesn't exist
        if (!Directory.Exists(savedImagesFolderPath))
        {
            Directory.CreateDirectory(savedImagesFolderPath);
        }

        // Construct the new file path
        string fileName = Path.GetFileName(generatedImagePath);
        string savedImagePath = Path.Combine(savedImagesFolderPath, fileName);

        // Copy or move the file
        File.Copy(generatedImagePath, savedImagePath, true); // Overwrite if exists

        // Optionally, delete the original file if needed
         File.Delete(generatedImagePath);

        Debug.Log($"Image saved to {savedImagePath}");
        

    }
}
