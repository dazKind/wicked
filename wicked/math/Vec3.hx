package wicked.math;

// check for must-have dependencies
#if !hxtypedarray
    #error "This class requires the hxtypedarray library";
#end

import typedarray.Float32Array;

abstract Vec3(Float32Array) from Float32Array to Float32Array {

    inline public function new(_x:Float, _y:Float, _z:Float):Mat44
        this = new Float32Array(null,[_x, _y, _z]);

    public var x(get, set):Float;
    inline function get_x() return this[0];
    inline function set_x(_v:Float) {this[0] = _v; return _v;}

    public var y(get, set):Float;
    inline function get_y() return this[1];
    inline function set_y(_v:Float) {this[1] = _v; return _v;}

    public var z(get, set):Float;
    inline function get_z() return this[2];
    inline function set_z(_v:Float) {this[2] = _v; return _v;}

    inline public function toString():String
        return "Vec3("+x+","+y+","+z+")";

    @:arrayAccess
    inline public function get(_i:Int) return this[_i];

    @:arrayAccess
    inline public function setAt(_i:Int, _v:Float):Float {
        this[_i] = _v;
        return _v;
    }

    inline public function setFromVec3(_rhs:Vec3):Void {
        var tmp = cast(_rhs, Float32Array);
        this.buffer.blit(0, tmp.buffer, tmp.byteOffset, tmp.buffer.length);
    }

    inline public function set(_x:Float, _y:Float, _z:Float):Void {
        this[0] = _x; this[1] = _y; this[2] = _z;
    }

    inline public function normalize():Float {
        var len:Float = length();
        x /= len;
        y /= len;
        z /= len;
        return len;
    }

    inline public function dot(rhs:Vec3):Float
        return x * rhs.x + y * rhs.y + z * rhs.z;

    inline public function length():Float 
        return Math.sqrt(dot(this));

    inline public function lengthSquared():Float 
        return dot(this);

    @:op(A == B)
    inline public static function eq(lhs:Vec3, rhs:Vec3):Bool
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z;

    @:op(A != B)
    inline public static function neq(lhs:Vec3, rhs:Vec3):Bool
        return lhs.x != rhs.x || lhs.y != rhs.y || lhs.z != rhs.z;

    @:op(A * B)
    inline public static function mult(lhs:Vec3, rhs:Vec3):Vec3 {
        var res = new Vec3(0,0,0);
        res[0] = lhs[1] * rhs[2] - lhs[2] * rhs[1];
        res[1] = lhs[2] * rhs[0] - lhs[0] * rhs[2];
        res[2] = lhs[0] * rhs[1] - lhs[1] * rhs[0];
        return res;
    }

    @:op(A *= B)
    inline public static function multIn(lhs:Vec3, rhs:Vec3):Vec3 {
        var res = lhs * rhs;
        lhs.setFromVec3(res);
        return lhs;
    }

    @:op(A * B)
    inline public static function multScalar(lhs:Vec3, scalar:Float):Vec3 {
        var res = new Vec3(0,0,0);
        res[0] =  lhs[0] * scalar;
        res[1] =  lhs[1] * scalar;
        res[2] =  lhs[2] * scalar;
        return res;
    }

    @:op(A *= B)
    inline public static function multScalarIn(lhs:Vec3, scalar:Float):Vec3 {
        lhs[0] *= scalar;
        lhs[1] *= scalar;
        lhs[2] *= scalar;
        return lhs;
    }

    @:op(A / B)
    inline public static function divideScalar(lhs:Vec3, scalar:Float):Vec3 {
        var res = new Vec3(0,0,0);
        res[0] =  lhs[0] / scalar;
        res[1] =  lhs[1] / scalar;
        res[2] =  lhs[2] / scalar;
        return res;
    }

    @:op(A /= B)
    inline public static function divideScalarIn(lhs:Vec3, scalar:Float):Vec3 {
        lhs[0] /= scalar;
        lhs[1] /= scalar;
        lhs[2] /= scalar;
        return lhs;
    }

    @:op(A + B)
    inline public static function add(lhs:Vec3, rhs:Vec3):Vec3 {
        var res = new Vec3(0,0,0);
        res[0] = lhs[0] + rhs[0];
        res[1] = lhs[1] + rhs[1];
        res[2] = lhs[2] + rhs[2];
        return res;
    }

    @:op(A += B)
    inline public static function addIn(lhs:Vec3, rhs:Vec3):Vec3 {
        lhs[0] += rhs[0];
        lhs[1] += rhs[1];
        lhs[2] += rhs[2];
        return lhs;
    }

    @:op(A - B)
    inline public static function subtract(lhs:Vec3, rhs:Vec3):Vec3 {
        var res = new Vec3(0,0,0);
        res[0] = lhs[0] - rhs[0];
        res[1] = lhs[1] - rhs[1];
        res[2] = lhs[2] - rhs[2];
        return res;
    }

    @:op(A -= B)
    inline public static function subtractIn(lhs:Vec3, rhs:Vec3):Vec3 {
        lhs[0] -= rhs[0];
        lhs[1] -= rhs[1];
        lhs[2] -= rhs[2];
        return lhs;
    }
}