using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.Interaction.Toolkit.Samples.StarterAssets;

public class SwitchToggle : MonoBehaviour
{
    [SerializeField] RectTransform uiHandleRectTransform;

    Toggle toggle;
    Vector2 handlePosititon;
    private GameObject spawnedClouds;
    public ARObjectSpawner arObjectSpawner;
    public GameObject Clouds;
    public GameObject spawnedObject;
    public float cloudSpawnHeight = 5.0f;
    public float spawnHeight = 5.0f;



    private void Awake()
    {
        toggle = GetComponent<Toggle>();
        handlePosititon = uiHandleRectTransform.anchoredPosition;
        toggle.onValueChanged.AddListener(OnToggleValueChanged);

        if (toggle.isOn)
        {
            OnToggleValueChanged(true);
        }
    }
    void OnToggleValueChanged(bool on)
    {
        Debug.Log("OnToggleValueChanged");

        if (on)
        {
            uiHandleRectTransform.anchoredPosition = handlePosititon*-1;
            Debug.Log("Clouds toggled on");
            // If the toggle is on, spawn the clouds
            if (spawnedClouds == null)
            {
                Vector3 spawnPosition = GetCloudSpawnPosition();
                spawnPosition.y -= spawnHeight;
                if (spawnPosition != Vector3.zero)
                {
                    spawnedClouds = Instantiate(Clouds, spawnPosition, Quaternion.identity);
                   // spawnedClouds.transform.SetParent(GameObject.Find("Terrain").transform);
                   spawnedClouds.transform.SetParent(spawnedObject.transform);

                }
            }
        }
        else
        {
            uiHandleRectTransform.anchoredPosition = handlePosititon;
            // If the toggle is off, destroy the clouds
            if (spawnedClouds != null)
            {
                Debug.Log("Clouds toggled off");
                Destroy(spawnedClouds);
                spawnedClouds = null; // Clear the reference
            }
        }
      

    }
    // Get the position for spawning clouds above the environment
    public Vector3 GetCloudSpawnPosition()
    {
        if (spawnedObject != null)
        {
            return spawnedObject.transform.position + Vector3.up * cloudSpawnHeight;
        }
        return Vector3.zero; // Default position if no object has been spawned
    }

    public void ResetClouds()
    {
        if (spawnedClouds != null)
        { Destroy(spawnedClouds); }
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
