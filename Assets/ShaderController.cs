using UnityEngine;
using UnityEngine.UI;

public class ShaderController : MonoBehaviour
{
    public Slider bumpPowerSlider;  // Reference to the UI slider
    public Material shaderMaterial;  // Reference to the material that uses your shader
    public GameObject Clouds; // Reference to the cloud prefab
    public ARObjectSpawner arObjectSpawner; // Reference to ARObjectSpawner
    private GameObject spawnedClouds;

    private void Start()
    {
        bumpPowerSlider.value = shaderMaterial.GetFloat("_BumpPower");
        bumpPowerSlider.onValueChanged.AddListener(AdjustStrength);
    }

    public void AdjustStrength(float value)
    {
        shaderMaterial.SetFloat("_BumpPower", value);
        Debug.Log("Bump power set to: " + value);
    }

    public void ToggleClouds(bool value)
    {
        if (value==true)
        {
            // If the toggle is on, spawn the clouds
            if (spawnedClouds == null)
            {
                Vector3 spawnPosition = arObjectSpawner.GetCloudSpawnPosition();
                if (spawnPosition != Vector3.zero)
                {
                    spawnedClouds = Instantiate(Clouds, spawnPosition, Quaternion.identity);
                }
            }
        }
        else
        {
            // If the toggle is off, destroy the clouds
            if (spawnedClouds != null || value ==false)
            {
                Destroy(spawnedClouds);
                spawnedClouds = null; // Clear the reference
            }
        }
    }
    public void ToggleCloudsOff()
    {

        if (spawnedClouds != null)
        {
            Destroy(spawnedClouds);
            spawnedClouds = null; // Clear the reference
        }
    }
}
