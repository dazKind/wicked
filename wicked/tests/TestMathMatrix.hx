package wicked.tests;

import wicked.math.Mat44;
import wicked.math.Vec3;

class TestMathMatrix extends haxe.unit.TestCase {
    
    public function testIdentity():Void {
        var m = new Mat44();
        this.assertTrue(m[0] == 1);
        this.assertTrue(m[1] == 0);
        this.assertTrue(m[2] == 0);
        this.assertTrue(m[3] == 0);

        this.assertTrue(m[4] == 0);
        this.assertTrue(m[5] == 1);
        this.assertTrue(m[6] == 0);
        this.assertTrue(m[7] == 0);

        this.assertTrue(m[8] == 0);
        this.assertTrue(m[9] == 0);
        this.assertTrue(m[10] == 1);
        this.assertTrue(m[11] == 0);

        this.assertTrue(m[12] == 0);
        this.assertTrue(m[13] == 0);
        this.assertTrue(m[14] == 0);
        this.assertTrue(m[15] == 1);
    }

    public function testProperties():Void {
        var m = new Mat44();
        
        m.tx = 1.0;
        m.ty = 2.0;
        m.tz = 3.0;

        this.assertTrue(m.m00 == 1);
        this.assertTrue(m.m11 == 1);
        this.assertTrue(m.m22 == 1);
        this.assertTrue(m.m33 == 1);

        this.assertTrue(m.tx == 1);
        this.assertTrue(m.ty == 2);
        this.assertTrue(m.tz == 3);
    }

    public function testSet():Void {
        var m0 = new Mat44();
        var m1 = new Mat44();

        m1.tx = 1.0;
        m1.ty = 2.0;
        m1.tz = 3.0;

        m0.setFromMat44(m1);

        this.assertTrue(m0.tx == 1);
        this.assertTrue(m0.ty == 2);
        this.assertTrue(m0.tz == 3);
    }

    public function testTransform():Void {
        var v = new Vec3(1,2,3);
        var m1 = new Mat44();
        m1.tx = 1;
        m1.ty = 2;
        m1.tz = 3;

        var m0 = new Mat44();
        
        var res0:Vec3 = m0 * v;
        var res1:Mat44 = m0 * m1;

        this.assertTrue(res1.tx == res0.x);
        this.assertTrue(res1.ty == res0.y);
        this.assertTrue(res1.tz == res0.z);
    }
}