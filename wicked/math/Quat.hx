package wicked.math;

// check for must-have dependencies
#if !hxtypedarray
    #error "This class requires the hxtypedarray library";
#end

import typedarray.Float32Array;

abstract Quat(Float32Array) from Float32Array to Float32Array {

    inline public function new(_x:Float, _y:Float, _z:Float, _w:Float):Mat44
        this = new Float32Array(null,[_x, _y, _z, _w]);

    public var x(get, set):Float;
    inline function get_x() return this[0];
    inline function set_x(_v:Float) {this[0] = _v; return _v;}

    public var y(get, set):Float;
    inline function get_y() return this[1];
    inline function set_y(_v:Float) {this[1] = _v; return _v;}

    public var z(get, set):Float;
    inline function get_z() return this[2];
    inline function set_z(_v:Float) {this[2] = _v; return _v;}

    public var w(get, set):Float;
    inline function get_w() return this[3];
    inline function set_w(_v:Float) {this[3] = _v; return _v;}

    @:arrayAccess
    inline public function get(_i:Int) return this[_i];

    @:arrayAccess
    inline public function setAt(_i:Int, _v:Float):Float {
        this[_i] = _v;
        return _v;
    }

    public function setFromQuat(_rhs:Quat):Void {
        var tmp = cast(_rhs, Float32Array);
        this.buffer.blit(0, tmp.buffer, tmp.byteOffset, tmp.buffer.length);
    }

    inline public function set(_x:Float, _y:Float, _z:Float, _w:Float):Void {
        this[0] = _x; this[1] = _y; this[2] = _z; this[3] = _w;
    }

    public static inline function createRotation(_from:Vec3, _to:Vec3):Quat {
        var m = Math.sqrt(2.0 + 2.0 * _from.dot(_to));
        var w = (_from * _to) * (1.0 / m);
        return new Quat(-w.x, -w.y, -w.z, 0.5 * m);
    }

    public static inline function createFromAxisAngle(_x:Float, _y:Float, _z:Float, _angle:Float):Quat {
        var d = new Vec3(_x, _y, _z).length();
        var hAng:Float = _angle * 0.5;
        var fSin:Float = Math.sin(hAng) / d;
        return new Quat(_x*fSin, _y*fSin, _z*fSin, Math.cos(hAng));
    }

    public static inline function createFromEulers(_eulerX:Float, _eulerY:Float, _eulerZ:Float):Quat {
        var h:Float = _eulerY * MathUtils.DEG2RAD_HALF;
        var a:Float = _eulerZ * MathUtils.DEG2RAD_HALF;
        var b:Float = _eulerX * MathUtils.DEG2RAD_HALF;
        var c1:Float = Math.cos(h);
        var s1:Float = Math.sin(h);
        var c2:Float = Math.cos(a);
        var s2:Float = Math.sin(a);
        var c3:Float = Math.cos(b);
        var s3:Float = Math.sin(b);
        var c1c2:Float = c1*c2;
        var s1s2:Float = s1*s2;
        var q:Quat = new Quat(
            c1c2*s3 + s1s2*c3,
            s1*c2*c3 + c1*s2*s3,
            c1*s2*c3 - s1*c2*s3,
            c1c2*c3 - s1s2*s3
        );
        q.normalize();
        return q;
    }

    inline public static function createFromMat44(_mat:Mat44):Quat {
        var q = new Quat(0,0,0,1);
        var froot:Float = 0;
        var ftrace:Float = _mat[0] + _mat[5] + _mat[10];

        if ( ftrace > 0.0 ) {
            // |w| > 1/2, may as well choose w > 1/2
            froot = Math.sqrt(ftrace + 1.0);  // 2w
            q.w = 0.5 * froot;
            froot = 0.5 / froot;  // 1/(4w)
            q.x = (_mat[9] - _mat[6]) * froot;
            q.y = (_mat[2] - _mat[8]) * froot;
            q.z = (_mat[4] - _mat[1]) * froot;
        } else {
            // |w| <= 1/2
            var s_iNext:Array<Int> = [1, 2, 0];
            var i:Int = 0;
            if ( _mat[5] > _mat[0] )
                i = 1;
            if ( _mat[10] > _mat[i*4 + i] )
                i = 2;
            var j:Int = s_iNext[i];
            var k:Int = s_iNext[j];

            froot = Math.sqrt(_mat[i*4 + i] - _mat[j*4 + j] - _mat[k*4 + k] + 1.0);

            var apkQuat:Array<Float> = [ 0.0, 0.0, 0.0 ];
            apkQuat[i] = 0.5 * froot;
            
            froot = 0.5 / froot;
            
            q.w = (_mat[k*4 + j]-_mat[j*4 + k]) * froot;
            apkQuat[j] = (_mat[j*4 + i]+_mat[i*4 + j]) * froot;
            apkQuat[k] = (_mat[k*4 + i] + _mat[i*4 + k]) * froot;
            q.x = apkQuat[0];
            q.y = apkQuat[1];
            q.z = apkQuat[2];
        }
        return q;
    }

    inline public function rotateX(_a:Float):Void {
        var halfA = _a*0.5;
        multIn(cast this, new Quat(Math.sin(halfA), 0, 0, Math.cos(halfA)));
    }

    inline public function rotateY(_a:Float):Void {
        var halfA = _a*0.5;
        multIn(cast this, new Quat(0, Math.sin(halfA), 0, Math.cos(halfA)));
    }

    inline public function rotateZ(_a:Float):Void {
        var halfA = _a*0.5;
        multIn(cast this, new Quat(0, 0, Math.sin(halfA), Math.cos(halfA)));
    }

    inline public function getPitch(_reprojectAxis:Bool):Float // x
    {
        var res:Float = 0;
        if (_reprojectAxis)
        {
            var fTx:Float  = x+x;
            var fTy:Float  = y+y;
            var fTz:Float  = z+z;
            var fTwx:Float = fTx*w;
            var fTxx:Float = fTx*x;
            var fTyz:Float = fTz*y;
            var fTzz:Float = fTz*z;
            res = Math.atan2(fTyz+fTwx, 1.0-(fTxx+fTzz));
        }
        else
            res = Math.atan2(2*(y*z + w*x), w*w - x*x - y*y + z*z);
        return res;
    }
    
    inline public function getYaw(_reprojectAxis:Bool):Float // y
    {
        var res:Float = 0;
        if (_reprojectAxis)
        {
            var fTx:Float  = x+x;
            var fTy:Float  = y+y;
            var fTz:Float  = z+z;
            var fTwy:Float = fTy*w;
            var fTxx:Float = fTx*x;
            var fTxz:Float = fTz*x;
            var fTyy:Float = fTy*y;
            res = Math.atan2(fTxz+fTwy, 1.0-(fTxx+fTyy));
        }
        else
            res = Math.asin(-2*(x*z - w*y));
        return res;
    }
    
    inline public function getRoll(_reprojectAxis:Bool):Float // z
    {
        var res:Float = 0;
        if (_reprojectAxis)
        {
            var fTx:Float  = x+x;
            var fTy:Float  = y+y;
            var fTz:Float  = z+z;
            var fTwz:Float = fTz*w;
            var fTxy:Float = fTy*x;
            var fTyy:Float = fTy*y;
            var fTzz:Float = fTz * z;
            res = Math.atan2(fTxy + fTwz, 1.0 - (fTyy + fTzz));
        }
        else
            res = Math.atan2(2*(x*y + w*z), w*w + x*x - y*y - z*z);
        return res;
    }

    inline public function normalize():Float {
        var norm = Math.sqrt(w*w+x*x+y*y+z*z);
        x /= norm;
        y /= norm;
        z /= norm;
        w /= norm;
        return norm;
    }

    public inline function invert():Void {
        var norm:Float = w*w+x*x+y*y+z*z;
        if ( norm > 0.0 ) {
            var invNorm:Float = 1.0/norm;
            x = -x * invNorm;
            y = -y * invNorm;
            z = -z * invNorm;
            w = w * invNorm;
        } else {
            // invalidate!!!
            x = 0;
            y = 0;
            z = 0;
            w = 0;
        }
    }

    inline public function dot(rhs:Quat):Float {
        return x * rhs.x + y * rhs.y + z * rhs.z + w * rhs.w;
    }

    inline public function length():Float 
        return Math.sqrt(dot(cast this));

    inline public function lengthSquared():Float 
        return dot(cast this);

    inline public function conjugate():Void {
        x = -x; y = -y; z = -z;
    }

    inline public function transform(_x:Float, _y:Float, _z:Float):Vec3 {
        var res = new Vec3(_x, _y, _z);
        var uv:Vec3 = new Vec3(x, y, z) * res;
        var uuv:Vec3 = new Vec3(x, y, z) * uv; 
        
        uv *= 2.0 * w;
        uuv *= 2.0;
        
        res.x = _x + uv.x + uuv.x;
        res.y = _y + uv.y + uuv.y;
        res.z = _z + uv.z + uuv.z;

        return res;
    }

    @:op(A == B)
    inline public static function eq(lhs:Quat, rhs:Quat):Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w;
    }

    @:op(A != B)
    inline public static function neq(lhs:Quat, rhs:Quat):Bool {
        return lhs.x != rhs.x || lhs.y != rhs.y || lhs.z != rhs.z || lhs.w != rhs.w;
    }

    @:op(A * B)
    inline public static function transformVec3(lhs:Quat, rhs:Vec3):Vec3 {
        var res = new Vec3(rhs.x, rhs.y, rhs.z);
        var uv:Vec3 = new Vec3(lhs.x, lhs.y, lhs.z) * res;
        var uuv:Vec3 = new Vec3(lhs.x, lhs.y, lhs.z) * uv; 
        
        uv *= 2.0 * lhs.w;
        uuv *= 2.0;
        
        res.x = rhs.x + uv.x + uuv.x;
        res.y = rhs.y + uv.y + uuv.y;
        res.z = rhs.z + uv.z + uuv.z;

        return res;
    }

    @:op(A * B)
    inline public static function mult(lhs:Quat, rhs:Quat):Quat {
        var res = new Quat(0,0,0,1);
        
        res[0] = lhs.w * rhs.x + lhs.x * rhs.w + lhs.y * rhs.z - lhs.z * rhs.y;
        res[1] = lhs.w * rhs.y + lhs.y * rhs.w + lhs.z * rhs.x - lhs.x * rhs.z;
        res[2] = lhs.w * rhs.z + lhs.z * rhs.w + lhs.x * rhs.y - lhs.y * rhs.x;
        res[3] = lhs.w * rhs.w - lhs.x * rhs.x - lhs.y * rhs.y - lhs.z * rhs.z;

        return res;
    }

    @:op(A *= B)
    inline public static function multIn(lhs:Quat, rhs:Quat):Quat {
        var res = lhs * rhs;
        lhs.setFromQuat(res);
        return lhs;
    }

    @:op(A * B)
    inline public static function multScalar(lhs:Quat, scalar:Float):Quat {
        var res = new Quat(0,0,0,1);
        res[0] =  lhs[0] * scalar;
        res[1] =  lhs[1] * scalar;
        res[2] =  lhs[2] * scalar;
        res[3] =  lhs[3] * scalar;
        return res;
    }

    @:op(A *= B)
    inline public static function multScalarIn(lhs:Quat, scalar:Float):Quat {
        lhs[0] *= scalar;
        lhs[1] *= scalar;
        lhs[2] *= scalar;
        lhs[3] *= scalar;
        return lhs;
    }

    @:op(A / B)
    inline public static function divideScalar(lhs:Quat, scalar:Float):Quat {
        var res = new Quat(0,0,0,1);
        res[0] =  lhs[0] / scalar;
        res[1] =  lhs[1] / scalar;
        res[2] =  lhs[2] / scalar;
        res[3] =  lhs[3] / scalar;
        return res;
    }

    @:op(A /= B)
    inline public static function divideScalarIn(lhs:Quat, scalar:Float):Quat {
        lhs[0] /= scalar;
        lhs[1] /= scalar;
        lhs[2] /= scalar;
        lhs[3] /= scalar;
        return lhs;
    }

    @:op(A + B)
    inline public static function add(lhs:Quat, rhs:Quat):Quat {
        var res = new Quat(0,0,0,1);
        res[0] = lhs[0] + rhs[0];
        res[1] = lhs[1] + rhs[1];
        res[2] = lhs[2] + rhs[2];
        res[3] = lhs[3] + rhs[3];
        return res;
    }

    @:op(A += B)
    inline public static function addIn(lhs:Quat, rhs:Quat):Quat {
        lhs[0] += rhs[0];
        lhs[1] += rhs[1];
        lhs[2] += rhs[2];
        lhs[3] += rhs[3];
        return lhs;
    }

    @:op(A - B)
    inline public static function subtract(lhs:Quat, rhs:Quat):Quat {
        var res = new Quat(0,0,0,1);
        res[0] = lhs[0] - rhs[0];
        res[1] = lhs[1] - rhs[1];
        res[2] = lhs[2] - rhs[2];
        res[3] = lhs[3] - rhs[3];
        return res;
    }

    @:op(A -= B)
    inline public static function subtractIn(lhs:Quat, rhs:Quat):Quat {
        lhs[0] -= rhs[0];
        lhs[1] -= rhs[1];
        lhs[2] -= rhs[2];
        lhs[3] -= rhs[3];
        return lhs;
    }
}