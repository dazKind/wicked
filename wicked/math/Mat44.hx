package wicked.math;

// check for must-have dependencies
#if !hxtypedarray
	#error "This class requires the hxtypedarray library";
#end

import typedarray.Float32Array;

abstract Mat44(Float32Array) from Float32Array to Float32Array {
	inline public function new():Mat44
		this = new Float32Array(null,[1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);

	public var tx(get, set):Float;
	inline function get_tx() return this[12];
	inline function set_tx(_v:Float) {this[12] = _v; return _v;}

	public var ty(get, set):Float;
	inline function get_ty() return this[13];
	inline function set_ty(_v:Float) {this[13] = _v; return _v;}

	public var tz(get, set):Float;
	inline function get_tz() return this[14];
	inline function set_tz(_v:Float) {this[14] = _v; return _v;}

	public var m00(get, set):Float;
	inline function get_m00() return this[0];
	inline function set_m00(_v:Float) {this[0] = _v; return _v;}
	public var m01(get, set):Float;
	inline function get_m01() return this[1];
	inline function set_m01(_v:Float) {this[1] = _v; return _v;}
	public var m02(get, set):Float;
	inline function get_m02() return this[2];
	inline function set_m02(_v:Float) {this[2] = _v; return _v;}
	public var m03(get, set):Float;
	inline function get_m03() return this[3];
	inline function set_m03(_v:Float) {this[3] = _v; return _v;}
	public var m10(get, set):Float;
	inline function get_m10() return this[4];
	inline function set_m10(_v:Float) {this[4] = _v; return _v;}
	public var m11(get, set):Float;
	inline function get_m11() return this[5];
	inline function set_m11(_v:Float) {this[5] = _v; return _v;}
	public var m12(get, set):Float;
	inline function get_m12() return this[6];
	inline function set_m12(_v:Float) {this[6] = _v; return _v;}
	public var m13(get, set):Float;
	inline function get_m13() return this[7];
	inline function set_m13(_v:Float) {this[7] = _v; return _v;}
	public var m20(get, set):Float;
	inline function get_m20() return this[8];
	inline function set_m20(_v:Float) {this[8] = _v; return _v;}
	public var m21(get, set):Float;
	inline function get_m21() return this[9];
	inline function set_m21(_v:Float) {this[9] = _v; return _v;}
	public var m22(get, set):Float;
	inline function get_m22() return this[10];
	inline function set_m22(_v:Float) {this[10] = _v; return _v;}
	public var m23(get, set):Float;
	inline function get_m23() return this[11];
	inline function set_m23(_v:Float) {this[11] = _v; return _v;}
	public var m30(get, set):Float;
	inline function get_m30() return this[12];
	inline function set_m30(_v:Float) {this[12] = _v; return _v;}
	public var m31(get, set):Float;
	inline function get_m31() return this[13];
	inline function set_m31(_v:Float) {this[13] = _v; return _v;}
	public var m32(get, set):Float;
	inline function get_m32() return this[14];
	inline function set_m32(_v:Float) {this[14] = _v; return _v;}
	public var m33(get, set):Float;
	inline function get_m33() return this[15];
	inline function set_m33(_v:Float) {this[15] = _v; return _v;}

	@:arrayAccess
	inline public function get(_i:Int) return this[_i];

	@:arrayAccess
	inline public function setAt(_i:Int, _v:Float):Float {
    	this[_i] = _v;
    	return _v;
	}

	inline public function setFromMat44(_rhs:Mat44):Void {
		var tmp = cast(_rhs, Float32Array);
		this.buffer.blit(0, tmp.buffer, tmp.byteOffset, tmp.buffer.length);
	}

	public static inline function createFromMat44(_m:Mat44):Mat44 {
		var m = new Mat44();
		m.setFromMat44(_m);
		return m;
	}

	public static inline function createOrthoLH(_l:Float, _r:Float, _b:Float, _t:Float, _n:Float, _f:Float):Mat44 {
		var m:Mat44 = new Mat44();
		m[0] = 2 / (_r - _l);
		m[5] = 2 / (_t - _b);
		m[10] = -2 / (_f - _n);
		m[12] = -(_r + _l) / (_r - _l);
		m[13] = -(_t + _b) / (_t - _b);
		m[14] = -(_f + _n) / (_f - _n);
		return m;
	}
	
	public static inline function createPerspLH(_fov:Float, _aspect:Float, _nz:Float, _fz:Float):Mat44 {
		var ymax:Float = _nz * Math.tan(MathUtils.DEG2RAD * _fov * 0.5);
		var xmax:Float = ymax * _aspect;		
		return createPerspOffCenterLH(xmax, ymax, _nz, _fz);
	}
	
	public static inline function createPerspOffCenterLH(_maxX:Float, _maxY:Float, _nz:Float, _fz:Float):Mat44 {
		var m:Mat44 = new Mat44();		
		m[0] = 2 * _nz / (_maxX * 2);
		m[5] = 2 * _nz / (_maxY * 2);
		m[8] = 0; // ???
		m[9] = 0; // ???
		m[10] = -(_fz + _nz) / (_fz - _nz);
		m[11] = -1;
		m[14] = -2 * _fz * _nz / (_fz - _nz);
		m[15] = 0;
		return m;
	}

	inline public function determinant():Float
	{
		return 	 (this[0] * this[5] - this[1] * this[4]) * (this[10] * this[15] - this[11] * this[14])
				-(this[0] * this[6] - this[2] * this[4]) * (this[9] * this[15] - this[11] * this[13])
				+(this[0] * this[7] - this[3] * this[4]) * (this[9] * this[14] - this[10] * this[13])
				+(this[1] * this[6] - this[2] * this[5]) * (this[8] * this[15] - this[11] * this[12])
				-(this[1] * this[7] - this[3] * this[5]) * (this[8] * this[14] - this[10] * this[12])
				+(this[2] * this[7] - this[3] * this[6]) * (this[8] * this[13] - this[9] * this[12]);
	}

	inline public function transpose():Void {
		_flipValue(4, 1);
		_flipValue(8, 2);
		_flipValue(12, 3);
		_flipValue(9, 6);
		_flipValue(13, 7);
		_flipValue(14, 11);
	}

	inline function _flipValue(_i0:Int, _i1:Int):Void {
		var tmp:Float = this[_i0];
		this[_i0] = this[_i1];
		this[_i1] = tmp;
	}

	public inline function inverted():Mat44 {
		var m = new Mat44();
		m.setFromMat44(this);
		m.invert();
		return m;
	}

	public inline function invert():Void
	{
		var v0:Float = m20 * m31 - m21 * m30;
        var v1:Float = m20 * m32 - m22 * m30;
        var v2:Float = m20 * m33 - m23 * m30;
        var v3:Float = m21 * m32 - m22 * m31;
        var v4:Float = m21 * m33 - m23 * m31;
        var v5:Float = m22 * m33 - m23 * m32;

        var t00:Float =  (v5 * m11 - v4 * m12 + v3 * m13);
        var t10:Float = - (v5 * m10 - v2 * m12 + v1 * m13);
        var t20:Float =  (v4 * m10 - v2 * m11 + v0 * m13);
        var t30:Float = - (v3 * m10 - v1 * m11 + v0 * m12);

        var invDet:Float = 1 / (t00 * m00 + t10 * m01 + t20 * m02 + t30 * m03);

        var d00:Float = t00 * invDet;
        var d10:Float = t10 * invDet;
        var d20:Float = t20 * invDet;
        var d30:Float = t30 * invDet;

        var d01:Float = - (v5 * m01 - v4 * m02 + v3 * m03) * invDet;
        var d11:Float =  (v5 * m00 - v2 * m02 + v1 * m03) * invDet;
        var d21:Float = - (v4 * m00 - v2 * m01 + v0 * m03) * invDet;
        var d31:Float =  (v3 * m00 - v1 * m01 + v0 * m02) * invDet;

        v0 = m10 * m31 - m11 * m30;
        v1 = m10 * m32 - m12 * m30;
        v2 = m10 * m33 - m13 * m30;
        v3 = m11 * m32 - m12 * m31;
        v4 = m11 * m33 - m13 * m31;
        v5 = m12 * m33 - m13 * m32;

        var d02:Float =  (v5 * m01 - v4 * m02 + v3 * m03) * invDet;
        var d12:Float = - (v5 * m00 - v2 * m02 + v1 * m03) * invDet;
        var d22:Float =  (v4 * m00 - v2 * m01 + v0 * m03) * invDet;
        var d32:Float = - (v3 * m00 - v1 * m01 + v0 * m02) * invDet;

        v0 = m21 * m10 - m20 * m11;
        v1 = m22 * m10 - m20 * m12;
        v2 = m23 * m10 - m20 * m13;
        v3 = m22 * m11 - m21 * m12;
        v4 = m23 * m11 - m21 * m13;
        v5 = m23 * m12 - m22 * m13;

        var d03:Float = - (v5 * m01 - v4 * m02 + v3 * m03) * invDet;
        var d13:Float =  (v5 * m00 - v2 * m02 + v1 * m03) * invDet;
        var d23:Float = - (v4 * m00 - v2 * m01 + v0 * m03) * invDet;
        var d33:Float =  (v3 * m00 - v1 * m01 + v0 * m02) * invDet;
		
		this[0] = d00;
		this[1] = d01;
		this[2] = d02;
		this[3] = d03;
		
		this[4] = d10;
		this[5] = d11;
		this[6] = d12;
		this[7] = d13;
		
		this[8] = d20;
		this[9] = d21;
		this[10] = d22;
		this[11] = d23;
		
		this[12] = d30;
		this[13] = d31;
		this[14] = d32;
		this[15] = d33;
	}

	inline public function setOrientation(_q:Quat):Void
	{
		var Tx:Float = _q.x+_q.x;
		var Ty:Float = _q.y+_q.y;
		var Tz:Float = _q.z+_q.z;
		
		var Twx:Float = Tx * _q.w;
		var Twy:Float = Ty * _q.w;
		var Twz:Float = Tz * _q.w;
		
		var Txx:Float = Tx * _q.x;
		var Txy:Float = Ty * _q.x;
		var Txz:Float = Tz * _q.x;
		
		var Tyy:Float = Ty * _q.y;
		var Tyz:Float = Tz * _q.y;
		var Tzz:Float = Tz * _q.z;
		
		this[0] = 1.0 - (Tyy + Tzz);
		this[1] = Txy - Twz;
		this[2] = Txz + Twy;
		this[3] = 0;

		this[4] = Txy + Twz;
		this[5] = 1.0 - (Txx + Tzz);
		this[6] = Tyz - Twx;
		this[7] = 0;
		
		this[8] = Txz - Twy;
		this[9] = Tyz + Twx;
		this[10] = 1.0 - (Txx + Tyy);
		this[11] = 0;
		
		this[12] = 0;
		this[13] = 0;
		this[14] = 0;
		this[15] = 1;
	}

	inline public function recompose(_o:Quat, _s:Vec3, _t:Vec3):Void
	{
		var rot:Mat44 = new Mat44();		
		rot.setOrientation(_o);

		this[0] = rot[0] 	* _s.x;
		this[1] = rot[1] 	* _s.x;
		this[2] = rot[2] 	* _s.x;
		this[3] = 0;
		this[4] = rot[4] 	* _s.y;
		this[5] = rot[5] 	* _s.y;
		this[6] = rot[6] 	* _s.y;
		this[7] = 0;
		this[8] = rot[8] 	* _s.z;
		this[9] = rot[9] 	* _s.z;
		this[10] = rot[10] 	* _s.z;
		this[11] = 0;
		this[12] = _t.x;
		this[13] = _t.y;
		this[14] = _t.z;
		this[15] = 1;
	}
	

	@:op(A * B)
	inline public static function mult(lhs:Mat44, rhs:Mat44):Mat44 {
		var res = new Mat44();
		res[0] = lhs[0] * rhs[0] + lhs[4] * rhs[1] + lhs[8] * rhs[2] + lhs[12] * rhs[3];
		res[1] = lhs[1] * rhs[0] + lhs[5] * rhs[1] + lhs[9] * rhs[2] + lhs[13] * rhs[3];
		res[2] = lhs[2] * rhs[0] + lhs[6] * rhs[1] + lhs[10] * rhs[2] + lhs[14] * rhs[3];
		res[3] = lhs[3] * rhs[0] + lhs[7] * rhs[1] + lhs[11] * rhs[2] + lhs[15] * rhs[3];

		res[4] = lhs[0] * rhs[4] + lhs[4] * rhs[5] + lhs[8] * rhs[6] + lhs[12] * rhs[7];
		res[5] = lhs[1] * rhs[4] + lhs[5] * rhs[5] + lhs[9] * rhs[6] + lhs[13] * rhs[7];
		res[6] = lhs[2] * rhs[4] + lhs[6] * rhs[5] + lhs[10] * rhs[6] + lhs[14] * rhs[7];
		res[7] = lhs[3] * rhs[4] + lhs[7] * rhs[5] + lhs[11] * rhs[6] + lhs[15] * rhs[7];

		res[8] = lhs[0] * rhs[8] + lhs[4] * rhs[9] + lhs[8] * rhs[10] + lhs[12] * rhs[11];
		res[9] = lhs[1] * rhs[8] + lhs[5] * rhs[9] + lhs[9] * rhs[10] + lhs[13] * rhs[11];
		res[10] = lhs[2] * rhs[8] + lhs[6] * rhs[9] + lhs[10] * rhs[10] + lhs[14] * rhs[11];
		res[11] = lhs[3] * rhs[8] + lhs[7] * rhs[9] + lhs[11] * rhs[10] + lhs[15] * rhs[11];

		res[12] = lhs[0] * rhs[12] + lhs[4] * rhs[13] + lhs[8] * rhs[14] + lhs[12] * rhs[15];
		res[13] = lhs[1] * rhs[12] + lhs[5] * rhs[13] + lhs[9] * rhs[14] + lhs[13] * rhs[15];
		res[14] = lhs[2] * rhs[12] + lhs[6] * rhs[13] + lhs[10] * rhs[14] + lhs[14] * rhs[15];
		res[15] = lhs[3] * rhs[12] + lhs[7] * rhs[13] + lhs[11] * rhs[14] + lhs[15] * rhs[15];
		return res;
	}

	@:op(A *= B)
	inline public static function multIn(lhs:Mat44, rhs:Mat44):Mat44 {
		var res = lhs * rhs;
		lhs.setFromMat44(res);
		return lhs;
	}

	@:op(A * B)
	inline public static function multScalar(lhs:Mat44, scalar:Float):Mat44 {
		var res = new Mat44();
		res[0] =  lhs[0] * scalar;
		res[1] =  lhs[1] * scalar;
		res[2] =  lhs[2] * scalar;
		res[3] =  lhs[3] * scalar;
		res[4] =  lhs[4] * scalar;
		res[5] =  lhs[5] * scalar;
		res[6] =  lhs[6] * scalar;
		res[7] =  lhs[7] * scalar;
		res[8] =  lhs[8] * scalar;
		res[9] =  lhs[9] * scalar;
		res[10] = lhs[10] * scalar;
		res[11] = lhs[11] * scalar;
		res[12] = lhs[12] * scalar;
		res[13] = lhs[13] * scalar;
		res[14] = lhs[14] * scalar;
		res[15] = lhs[15] * scalar;
		return res;
	}

	@:op(A *= B)
	inline public static function multScalarIn(lhs:Mat44, scalar:Float):Mat44 {
		lhs[0] *= scalar;
		lhs[1] *= scalar;
		lhs[2] *= scalar;
		lhs[3] *= scalar;
		lhs[4] *= scalar;
		lhs[5] *= scalar;
		lhs[6] *= scalar;
		lhs[7] *= scalar;
		lhs[8] *= scalar;
		lhs[9] *= scalar;
		lhs[10] *=scalar;
		lhs[11] *=scalar;
		lhs[12] *=scalar;
		lhs[13] *=scalar;
		lhs[14] *=scalar;
		lhs[15] *=scalar;
		return lhs;
	}

	@:op(A / B)
	inline public static function divideScalar(lhs:Mat44, scalar:Float):Mat44 {
		var res = new Mat44();
		res[0] =  lhs[0] / scalar;
		res[1] =  lhs[1] / scalar;
		res[2] =  lhs[2] / scalar;
		res[3] =  lhs[3] / scalar;
		res[4] =  lhs[4] / scalar;
		res[5] =  lhs[5] / scalar;
		res[6] =  lhs[6] / scalar;
		res[7] =  lhs[7] / scalar;
		res[8] =  lhs[8] / scalar;
		res[9] =  lhs[9] / scalar;
		res[10] = lhs[10] / scalar;
		res[11] = lhs[11] / scalar;
		res[12] = lhs[12] / scalar;
		res[13] = lhs[13] / scalar;
		res[14] = lhs[14] / scalar;
		res[15] = lhs[15] / scalar;
		return res;
	}

	@:op(A /= B)
	inline public static function divideScalarIn(lhs:Mat44, scalar:Float):Mat44 {
		lhs[0] /= scalar;
		lhs[1] /= scalar;
		lhs[2] /= scalar;
		lhs[3] /= scalar;
		lhs[4] /= scalar;
		lhs[5] /= scalar;
		lhs[6] /= scalar;
		lhs[7] /= scalar;
		lhs[8] /= scalar;
		lhs[9] /= scalar;
		lhs[10] /=scalar;
		lhs[11] /=scalar;
		lhs[12] /=scalar;
		lhs[13] /=scalar;
		lhs[14] /=scalar;
		lhs[15] /=scalar;
		return lhs;
	}

	@:op(A + B)
	inline public static function add(lhs:Mat44, rhs:Mat44):Mat44 {
		var res = new Mat44();
		res[0] = lhs[0] + rhs[0];
		res[1] = lhs[1] + rhs[1];
		res[2] = lhs[2] + rhs[2];
		res[3] = lhs[3] + rhs[3];
		res[4] = lhs[4] + rhs[4];
		res[5] = lhs[5] + rhs[5];
		res[6] = lhs[6] + rhs[6];
		res[7] = lhs[7] + rhs[7];
		res[8] = lhs[8] + rhs[8];
		res[9] = lhs[9] + rhs[9];
		res[10] = lhs[10] + rhs[10];
		res[11] = lhs[11] + rhs[11];
		res[12] = lhs[12] + rhs[12];
		res[13] = lhs[13] + rhs[13];
		res[14] = lhs[14] + rhs[14];
		res[15] = lhs[15] + rhs[15];		
		return res;
	}

	@:op(A += B)
	inline public static function addIn(lhs:Mat44, rhs:Mat44):Mat44 {
		lhs[0] += rhs[0];
		lhs[1] += rhs[1];
		lhs[2] += rhs[2];
		lhs[3] += rhs[3];
		lhs[4] += rhs[4];
		lhs[5] += rhs[5];
		lhs[6] += rhs[6];
		lhs[7] += rhs[7];
		lhs[8] += rhs[8];
		lhs[9] += rhs[9];
		lhs[10] += rhs[10];
		lhs[11] += rhs[11];
		lhs[12] += rhs[12];
		lhs[13] += rhs[13];
		lhs[14] += rhs[14];
		lhs[15] += rhs[15];
		return lhs;
	}

	@:op(A - B)
	inline public static function subtract(lhs:Mat44, rhs:Mat44):Mat44 {
		var res = new Mat44();
		res[0] = lhs[0] - rhs[0];
		res[1] = lhs[1] - rhs[1];
		res[2] = lhs[2] - rhs[2];
		res[3] = lhs[3] - rhs[3];
		res[4] = lhs[4] - rhs[4];
		res[5] = lhs[5] - rhs[5];
		res[6] = lhs[6] - rhs[6];
		res[7] = lhs[7] - rhs[7];
		res[8] = lhs[8] - rhs[8];
		res[9] = lhs[9] - rhs[9];
		res[10] = lhs[10] - rhs[10];
		res[11] = lhs[11] - rhs[11];
		res[12] = lhs[12] - rhs[12];
		res[13] = lhs[13] - rhs[13];
		res[14] = lhs[14] - rhs[14];
		res[15] = lhs[15] - rhs[15];		
		return res;
	}

	@:op(A -= B)
	inline public static function subtractIn(lhs:Mat44, rhs:Mat44):Mat44 {
		lhs[0] -= rhs[0];
		lhs[1] -= rhs[1];
		lhs[2] -= rhs[2];
		lhs[3] -= rhs[3];
		lhs[4] -= rhs[4];
		lhs[5] -= rhs[5];
		lhs[6] -= rhs[6];
		lhs[7] -= rhs[7];
		lhs[8] -= rhs[8];
		lhs[9] -= rhs[9];
		lhs[10] -= rhs[10];
		lhs[11] -= rhs[11];
		lhs[12] -= rhs[12];
		lhs[13] -= rhs[13];
		lhs[14] -= rhs[14];
		lhs[15] -= rhs[15];
		return lhs;
	}

	@:op(A * B)
	inline public static function multVec3(lhs:Mat44, v:Vec3):Vec3 {
		var d:Float = (lhs[3] * v.x + lhs[7] * v.y + lhs[11] * v.z + lhs[15]);
		var res = new Vec3(
			(v.x * lhs[0] + v.y * lhs[4] + v.z * lhs[8] + lhs[12]) / d,
			(v.x * lhs[1] + v.y * lhs[5] + v.z * lhs[9] + lhs[13]) / d,
			(v.x * lhs[2] + v.y * lhs[6] + v.z * lhs[10] + lhs[14]) / d
		);
		return res;
	}

	inline public function transform(_x:Float, _y:Float, _z:Float):Vec3 {
		var d:Float = (this[3] * _x + this[7] * _y + this[11] * _z + this[15]);
		var res = new Vec3(
			(_x * this[0] + _y * this[4] + _z * this[8] + this[12]) / d,
			(_x * this[1] + _y * this[5] + _z * this[9] + this[13]) / d,
			(_x * this[2] + _y * this[6] + _z * this[10] + this[14]) / d
		);
		return res;
	}
}