using UnityEngine;
using UnityEngine.UI;

public class ShaderController : MonoBehaviour
{
    public Slider bumpPowerSlider;  // Reference to the UI slider
    public Material shaderMaterial;  // Reference to the material that uses your shader
    public GameObject Clouds; // Reference to the cloud prefab
    public ARObjectSpawner arObjectSpawner; // Reference to ARObjectSpawner
    private GameObject spawnedClouds;
    private GameObject Plane;


    private void Start()
    {
        bumpPowerSlider.value = shaderMaterial.GetFloat("_BumpPower");
        bumpPowerSlider.onValueChanged.AddListener(AdjustStrength);
    }

    public void AdjustStrength(float value)
    {
        shaderMaterial.SetFloat("_BumpPower", value);
      
    }

    public void ResetClouds()
    {
        if (spawnedClouds != null)
        { Destroy(spawnedClouds); }
    }
}
