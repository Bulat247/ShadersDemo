using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FollowMouse : MonoBehaviour
{
    public Camera cam;

    void Update()
    {
        if (Input.GetMouseButton(0))
        {
            Vector3 pos = cam.ScreenToWorldPoint(Input.mousePosition);
            transform.position = new Vector3(pos.x, pos.y, 0);
        }
        else
            transform.position = Vector3.Lerp(transform.position, Vector2.zero, Time.deltaTime * 3);

        transform.Rotate(0, 0, Time.deltaTime*50);
    }
}
