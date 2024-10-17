using Oculus.Interaction;
using UnityEngine;
using UnityEngine.UI;

public class PinPlacementHandler : MonoBehaviour
{
   
    public GameObject pinPrefab;           // Pin prefab to spawn
    public Button spawnPinButton;
    public Button finishBtn;
    public Transform handTransform;        // Hand transform to place the pin
    private GameObject _pinClone;          // Clone of the pin prefab
    private GameObject HandGrab;           // HandGrab GameObject (child of pinPrefab)
    private GameObject FloatingUI;         // FloatingUI GameObject (child of pinPrefab)

    public Text debugText;                 // For debugging purposes

    void Start()
    {
        finishBtn.gameObject.SetActive(false);
        spawnPinButton.onClick.AddListener(SpawnPin);
        finishBtn.onClick.AddListener(Finish);
    }

    public void SpawnPin()
    {
        finishBtn.gameObject.SetActive(true);
        spawnPinButton.gameObject.SetActive(false);

        if (_pinClone == null)
        {
            // Instantiate the pin at the hand's position
            _pinClone = Instantiate(pinPrefab, handTransform.position, handTransform.rotation);

            // Find the HandGrab GameObject within the spawned pin
            HandGrab = _pinClone.transform.Find("HandGrab").gameObject;
            FloatingUI = _pinClone.transform.Find("FloatingUI").gameObject;

            if (HandGrab != null)
            {
                HandGrab.SetActive(true);
                FloatingUI.SetActive(false);
            }
            else
            {
                Debug.LogWarning("HandGrab object not found in the pin clone!");
            }

        

            debugText.text = "Pin spawned.";
            Debug.Log("Pin spawned.");
        }
    }

    private void Finish()
    {
        finishBtn.gameObject.SetActive(false);
        spawnPinButton.gameObject.SetActive(true);

        // Disable the HandGrab GameObject when finished
        if (HandGrab != null)
        {
            HandGrab.SetActive(false);
            FloatingUI.SetActive(true);
        }
        else
        {
            Debug.LogWarning("HandGrab object is null!");
        }
    }
}
