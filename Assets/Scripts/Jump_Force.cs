using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Jump_Force : MonoBehaviour
{
    public int force = 30;
    public int yz_drive = 0;
    private Rigidbody rd;
    private Rigidbody con_rd;
    Transform tf_ground;
    ConfigurableJoint jt;
    public Transform tf_jt_up_begin;
    public Transform tf_jt_up_end;
    public Transform tf_jt_down_begin;
    public Transform tf_jt_down_end;
    //ConfigurableJointMotion jt_motion; //lock free limit
    // Start is called before the first frame update
    void Start()
    {
        rd = this.GetComponent<Rigidbody>();
        con_rd = this.GetComponent<ConfigurableJoint>().connectedBody;
        jt = this.GetComponent<ConfigurableJoint>();

        
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.DrawLine(worldPos1, worldPos2, Color.yellow);
    }

    private void FixedUpdate()
    {
        if (Input.GetKey(KeyCode.W))
        {
            float v = force * Time.deltaTime;
            //GetComponent<Rigidbody>().AddTorque(transform.right * v);
            Debug.Log("wwwwwwwwwwwwww v:" + v + " " + con_rd.useGravity);
            //rd.AddRelativeForce(new Vector3(0, force, 0));
            //con_rd.AddRelativeForce(new Vector3(0, -force, 0));

            yz_drive = 300;
        }
        else if (Input.GetKey(KeyCode.S))
        {
            //rd.AddRelativeForce(new Vector3(0, -force, 0));
            //con_rd.AddRelativeForce(new Vector3(0, force, 0));

            yz_drive = 0;        
        }
        //float h = Input.GetAxis("Horizontal") * amount * Time.deltaTime;
        //GetComponent<Rigidbody>().AddTorque(transform.up * h);

        JointDrive jt_tmp = new JointDrive();
        jt_tmp.maximumForce = jt.angularYZDrive.maximumForce;
        //jt_tmp.mode = jt.angularYZDrive.mode;
        jt_tmp.positionSpring = jt.angularYZDrive.positionSpring;
        jt_tmp.positionSpring = yz_drive;
        jt_tmp.positionDamper = jt.angularYZDrive.positionDamper;

        jt.angularYZDrive = jt_tmp;
    }

    public void OnDrawGizmosSelected()
    {
        Vector3 lineBegin = new Vector3(tf_jt_up_begin.position.x, tf_jt_up_begin.position.y, tf_jt_up_begin.position.z);
        Vector3 lineEnd = new Vector3(tf_jt_up_end.position.x, tf_jt_up_end.position.y, tf_jt_up_end.position.z);
        //Gizmos.DrawLine(lineBegin, lineEnd);
        Gizmos.DrawLine(Vector3.zero, lineBegin);
        Gizmos.DrawLine(Vector3.zero, lineEnd);
        Gizmos.DrawLine(Vector3.zero, new Vector3(0, 3f, 0));
    }
}
