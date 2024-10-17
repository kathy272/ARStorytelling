using Meta.XR.ImmersiveDebugger.UserInterface.Generic;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Button = UnityEngine.UI.Button;

public class TerrainManager : MonoBehaviour
{
    public GameObject terrain;
    public Button MoveButton;
    public Button SetButton;
    public GameObject HandGrab;
    public GameObject Pinching;



    // Start is called before the first frame update
    void Start()
    {
        //hide set button
        SetButton.gameObject.SetActive(false);
        //disable Handgrab GameObject
        HandGrab.SetActive(false);
        MoveButton.onClick.AddListener(MoveButtonClicked);
        SetButton.onClick.AddListener(SetButtonClicked);

    }

    private void MoveButtonClicked()
    {
        Pinching.SetActive(false);
        //hide move button
        MoveButton.gameObject.SetActive(false);
        //show set button
        SetButton.gameObject.SetActive(true);
        //enable Handgrab GameObject
        HandGrab.SetActive(true);
    }
    private void SetButtonClicked()
    {
        Pinching.SetActive(true);
        //set rotation of terrain to 0

        terrain.transform.rotation = Quaternion.Euler(0, 0, 0);
        //hide set button
        SetButton.gameObject.SetActive(false);
        //show move button
        MoveButton.gameObject.SetActive(true);
        //disable Handgrab GameObject
        HandGrab.SetActive(false);
    }



}
