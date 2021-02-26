using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Jump : MonoBehaviour
{

    public int force = 3;
    private Rigidbody rd;
    // Start is called before the first frame update
    void Start()
    {
        rd = this.GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void FixedUpdate()
    {
        if (Input.GetKeyDown(KeyCode.W))
        {
            float v = force * Time.deltaTime;
            //GetComponent<Rigidbody>().AddTorque(transform.right * v);
            Debug.Log("wwwwwwwwwwwwww v:" + v);
            rd.AddForce(new Vector3(0, force, 0));
        }
        //float h = Input.GetAxis("Horizontal") * amount * Time.deltaTime;
        //GetComponent<Rigidbody>().AddTorque(transform.up * h);
        

    }
}
