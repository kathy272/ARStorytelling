// Example: Adjust shader material property from a script instead of in the shader
using UnityEngine;

public class CloudAnimator : MonoBehaviour
{
    public Material cloudMaterial;
    private float elapsedTime = 0f;

    void Update()
    {
        elapsedTime += Time.deltaTime;
        float cloudOpacity = Mathf.PingPong(elapsedTime, 1f); // Cycles between 0 and 1
        cloudMaterial.SetFloat("_Opacity", cloudOpacity); // Assuming _Opacity is your shader's property
    }
}
