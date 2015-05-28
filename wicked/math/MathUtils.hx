package wicked.math;

class MathUtils
{
    inline public static var FLOAT_MAX = 3.4028234663852886e+38;
    inline public static var FLOAT_MIN = -3.4028234663852886e+38;
    inline public static var DOUBLE_MAX = 1.7976931348623157e+308;
    inline public static var DOUBLE_MIN = -1.7976931348623157e+308;
    inline public static var DEG2RAD:Float = 0.017453292519943295769236907684886;
    inline public static var RAD2DEG:Float = 57.295779513082320876798154814105;
    inline public static var DEG2RAD_HALF:Float = 0.0087266462599716478846184538424431;
    inline public static var LN2 = 0.6931471805599453;
    inline public static var PIQUARTER = 0.7853981633974483;
    inline public static var PIHALF = 1.5707963267948966;
    inline public static var PI = 3.141592653589793;
    inline public static var PI2 = 6.283185307179586;
    inline public static var EPS = 1e-6;
    inline public static var EPS_SQ = 1e-6 * 1e-6;

    inline public static function fmin(x:Float, y:Float):Float
        return x < y ? x : y;
    
    inline public static function fmax(x:Float, y:Float):Float
        return x > y ? x : y;
    
    inline public static function fabs(x:Float):Float
        return x < 0 ? -x : x;

    inline public static function polarToCartesian(_pol:Vec3):Vec3
    {
        return new Vec3(
                _pol.x * Math.sin(_pol.z + PIHALF) * Math.sin(_pol.y),
                _pol.x * Math.cos(_pol.z + PIHALF),
                _pol.x * Math.sin(_pol.z + PIHALF) * Math.cos(_pol.y)
            );
    }
    
    inline public static function cartesianToPolar(_cart:Vec3):Vec3
    {
        return new Vec3(
                Math.sqrt(_cart.x * _cart.x + _cart.y * _cart.y + _cart.z * _cart.z),
                Math.atan2(_cart.z, _cart.x),
                Math.acos(_cart.y / _cart.x) - PIHALF
            );
    }

/*  TODO: undust these old yet usefull routines
    inline public static function getRelativeYaw(vDir:Vec3, m:Mat44):Float {
        // front component vector
        var fFront:Float =
             vDir.x * m.rawData[2]
            -vDir.y * m.rawData[6]
            -vDir.z * m.rawData[10];
        // left component
        var fLeft:Float =
             vDir.x * m.rawData[0]
            -vDir.y * m.rawData[4]
            -vDir.z * m.rawData[8];
        // relative heading is arctan of angle between front and left
        return Math.atan2(fLeft, fFront);
    }
    
    inline public static function getRelativePitch(vDir:Vec3, m:Mat44):Float {
        // get front component of vector
        var fFront:Float =
             vDir.x * m.rawData[2]
            -vDir.y * m.rawData[6]
            -vDir.z * m.rawData[10];
        // get up component of vector
        var fUp:Float = 
            -vDir.x * m.rawData[1]
            +vDir.y * m.rawData[5]
            +vDir.z * m.rawData[9];
        // relative pitch is arctan of angle between front and up
        return Math.atan2(fUp, fFront);
    }
    
    inline public static function getRelativeRoll(vDir:Vec3, m:Mat44):Float {
        // get left component of vector
        var fLeft:Float = 
             vDir.x * m.rawData[0]
            -vDir.y * m.rawData[4]
            -vDir.z * m.rawData[8];
        // get up component of vector
        var fUp:Float = 
            -vDir.x * m.rawData[1]
            +vDir.y * m.rawData[5]
            +vDir.z * m.rawData[9];
        // relative yaw is arctan of angle between left and up
        return Math.atan2(fUp, fLeft);
    }
*/
}