using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

public class UpdateTex : MonoBehaviour
{
    public Material targetMaterial; 
    public string texturePropertyName = "_MainTex"; 
   // public RawImage previewImage; 

  
    public void ApplyNewTexture(Texture2D newTexture)
    {
        if (targetMaterial != null && newTexture != null)
        {
            // Update the texture in the shader
            targetMaterial.SetTexture(texturePropertyName, newTexture);

            AssetDatabase.Refresh();
        }
    }

  
    public void LoadTextureFromFile(string filePath)
    {
        byte[] fileData = System.IO.File.ReadAllBytes(filePath);
        Texture2D texture = new Texture2D(2, 2);
        texture.LoadImage(fileData); // Automatically resizes texture dimensions
        ApplyNewTexture(texture);
    }
}
