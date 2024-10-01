using UnityEngine;
using UnityEngine.UI;
using System.Diagnostics;
using System.IO;
using System.Collections;
using System;

public class GenerateImage : MonoBehaviour
{
    public InputField promptInputField;
    public RawImage generatedImageDisplay;
    private string imagePath = "C:/Users/kendl/OneDrive/Documents/UnityProjects/ProjectBA/BaProject/Assets/Scripts/Python/generated_image.png";
    private string pythonScriptPath = "C:/Users/kendl/OneDrive/Documents/UnityProjects/ProjectBA/BaProject/Assets/Scripts/Python/image_creation.py";
    public RawImage savedImage;
    public GameObject previewUI;
    public GameObject generatedImageUI;
    public GameObject savedImageUI;
    private string pythonApplication = "C:/Users/kendl/AppData/Local/Microsoft/WindowsApps/python.exe";


    public void GenerateWithPrompt()
    {
        UnityEngine.Debug.Log("Generate Button Clicked");
        string prompt = promptInputField.text; // Get the user input prompt
        StartCoroutine(GenerateImageFromPrompt(prompt)); // Call the Python script to generate the image
    }

    private IEnumerator GenerateImageFromPrompt(string prompt)
    {
        UnityEngine.Debug.Log("command: powershell -Command \"python " + pythonScriptPath + " \"" + prompt + "\"\"");
        UnityEngine.Debug.Log("PowerShell path: " + Environment.GetFolderPath(Environment.SpecialFolder.System) + "/WindowsPowerShell/v1.0/powershell.exe");
        Process process = new Process();
        //process.StartInfo.FileName = "powershell";
       process.StartInfo.FileName = @"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe";

        process.StartInfo.Arguments = $"-Command \"{pythonApplication} \"{pythonScriptPath}\" \"{prompt}\"\""; // Use PowerShell to run Python script with the prompt
        process.StartInfo.RedirectStandardOutput = true;
        process.StartInfo.RedirectStandardError = true;
        process.StartInfo.UseShellExecute = false;
        process.StartInfo.CreateNoWindow = true;

        UnityEngine.Debug.Log("Starting Python script...");
        process.Start();

        // Read and log output from the Python script
        string output = process.StandardOutput.ReadToEnd();
        string error = process.StandardError.ReadToEnd();
        UnityEngine.Debug.Log("Python Output: " + output);
        if (!string.IsNullOrEmpty(error))
        {
            UnityEngine.Debug.LogError("Python Error: " + error);
            UnityEngine.Debug.LogError("Ai is busy...Try again later.");
        }

        process.WaitForExit(); // Wait for Python to finish

        // Wait for a few seconds before checking if the image exists
        yield return new WaitForSeconds(15); // Adjust the delay as needed

        // Check if the image was generated and exists
        if (File.Exists(imagePath))
        {
            UnityEngine.Debug.Log("Image found: " + imagePath);
            StartCoroutine(LoadImage());
        }
        else
        {
            UnityEngine.Debug.LogError("Image not found or failed to generate at path: " + imagePath);
        }
    }

    // Coroutine to load the image and display it in the RawImage component
    private IEnumerator LoadImage()
    {
        string fullPath = imagePath; // Full path to the image
        UnityEngine.Debug.Log("Loading image from: " + fullPath);
        byte[] fileData = File.ReadAllBytes(fullPath); // Load the image bytes
        Texture2D texture = new Texture2D(2, 2);
        texture.LoadImage(fileData); // Load the image into the texture

        //hide the preview ui and show the generated image on the generated image display
        previewUI.gameObject.SetActive(false);
        generatedImageUI.gameObject.SetActive(true);
        // Set the texture in the RawImage to display it
        generatedImageDisplay.texture = texture;
        generatedImageDisplay.SetNativeSize();
        savedImage.texture = texture;

        yield return null;
    }
    void OnApplicationQuit()
    {
        // Check if the generated image exists and delete it
        if (File.Exists(imagePath))
        {
            File.Delete(imagePath);
            UnityEngine.Debug.Log("Temporary image deleted on application quit.");
        }
    }

}
