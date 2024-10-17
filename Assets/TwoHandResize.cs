using UnityEngine;
using Oculus.Interaction.HandGrab;
using Oculus.Interaction;
using Oculus.Interaction;

public class TwoHandResize : MonoBehaviour
{
    [SerializeField]
    private HandGrabInteractable _handGrabInteractable; // Reference to the HandGrabInteractable
    [SerializeField]
    public Grabbable _activeTransformer; // Reference to the Grabbable
    private ITransformer TwoGrabTransformer;
    private Vector3 _initialScale; // The initial scale of the object
    private Vector3 _initialDistance; // The initial distance between hands

    // Variables to track hand positions
    private Transform _leftHand;
    private Transform _rightHand;
    private UnityEngine.Object _twoGrabTransformer;
    private void Start()
    {
        TwoGrabTransformer = _twoGrabTransformer as ITransformer;

        if (_handGrabInteractable == null)
        {
            Debug.LogWarning("HandGrabInteractable is not assigned.");
            return;
        }
     
        // Store the initial scale of the object
        _initialScale = transform.localScale;
        // Store the initial distance between hands
        //if both hands are grabbing the object, resize the object ´- twoHandTransform

        if (_twoGrabTransformer != null)
        {
            _initialDistance = _leftHand.position - _rightHand.position;
            ResizeObject();
        }
        else
        {
            Debug.LogWarning("TwoGrabTransformer is not assigned.");
        }
   
    }
    //resizes the object based on the distance between the hands
    private void ResizeObject()
    {
        // Calculate the distance between the hands
        Vector3 distance = _leftHand.position - _rightHand.position;

        // Calculate the scale factor based on the initial distance
        float scaleFactor = distance.magnitude / _initialDistance.magnitude;

        // Apply the scale factor to the object
        transform.localScale = _initialScale * scaleFactor;
    }


}
