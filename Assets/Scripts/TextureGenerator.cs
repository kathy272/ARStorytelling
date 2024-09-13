using UnityEngine;
using System.Collections;

public class TextureGenerator : MonoBehaviour
{
    public Texture2D heightmapTexture; // Your heightmap texture
    public Material targetMaterial; // Material to apply the generated texture
    public string[] stylePrompts; // Array of style prompts for different variations

    private string stableDiffusionEndpoint = "YOUR_STABLE_DIFFUSION_API_ENDPOINT"; // Replace with your endpoint

    void Start()
    {
        if (heightmapTexture == null || targetMaterial == null)
        {
            Debug.LogError("Heightmap texture or target material is not assigned.");
            return;
        }

        StartCoroutine(GenerateTextures());
    }

    IEnumerator GenerateTextures()
    {
        foreach (string prompt in stylePrompts)
        {
            // Convert heightmap texture to a format suitable for the API
            byte[] heightmapData = heightmapTexture.EncodeToPNG();
            WWWForm form = new WWWForm();
            form.AddBinaryData("image", heightmapData, "heightmap.png", "image/png");
            form.AddField("prompt", prompt);

            using (var www = new WWW(stableDiffusionEndpoint, form))
            {
                yield return www;

                if (www.error != null)
                {
                    Debug.LogError($"Error generating texture: {www.error}");
                }
                else
                {
                    Texture2D generatedTexture = new Texture2D(2, 2);
                    generatedTexture.LoadImage(www.bytes);
                    ApplyTexture(generatedTexture);
                }
            }
        }
    }

    void ApplyTexture(Texture2D texture)
    {
        // Apply the generated texture to the target material
        if (texture != null && targetMaterial != null)
        {
            targetMaterial.mainTexture = texture;
            Debug.Log("Texture applied successfully.");
        }
        else
        {
            Debug.LogError("Generated texture or target material is null.");
        }
    }
}
