function rotm2Quat(rotm) {
    var tr = rotm.m11 + rotm.m22 + rotm.m33;
    var qw;
    var qx;
    var qy;
    var qz;
    var S;

    if (tr > 0) {
        S = Math.sqrt(tr+1.0) * 2;
        qw = 0.25 * S;
        qx = (rotm.m32 - rotm.m23) / S;
        qy = (rotm.m13 - rotm.m31) / S;
        qz = (rotm.m21 - rotm.m12) / S;
    } else if ((rotm.m11 > rotm.m22)&(rotm.m11 > rotm.m33)) {
        S = Math.sqrt(1.0 + rotm.m11 - rotm.m22 - rotm.m33) * 2;
        qw = (rotm.m32 - rotm.m23) / S;
        qx = 0.25 * S;
        qy = (rotm.m12 + rotm.m21) / S;
        qz = (rotm.m13 + rotm.m31) / S;
    } else if (rotm.m22 > rotm.m33) {
        S = Math.sqrt(1.0 + rotm.m22 - rotm.m11 - rotm.m33) * 2;
        qw = (rotm.m13 - rotm.m31) / S;
        qx = (rotm.m12 + rotm.m21) / S;
        qy = 0.25 * S;
        qz = (rotm.m23 + rotm.m32) / S;
    } else {
        S = Math.sqrt(1.0 + rotm.m33 - rotm.m11 - rotm.m22) * 2;
        qw = (rotm.m21 - rotm.m12) / S;
        qx = (rotm.m13 + rotm.m31) / S;
        qy = (rotm.m23 + rotm.m32) / S;
        qz = 0.25 * S;
    }
    return Qt.quaternion(qw, qx, qy, qz)
}

function quat2rotm(quat) {
    var xx = quat.x * quat.x;
    var xy = quat.x * quat.y;
    var xz = quat.x * quat.z;
    var xw = quat.x * quat.scalar;

    var yy = quat.y * quat.y;
    var yz = quat.y * quat.z;
    var yw = quat.y * quat.scalar;

    var zz = quat.z * quat.z;
    var zw = quat.z * quat.scalar;

    return Qt.matrix4x4(1 - 2 * (yy + zz), 2 * (xy - zw), 2 * (xz + yw), 0,
                        2 * (xy + zw), 1 - 2 * (xx + zz), 2 * (yz - xw), 0,
                        2 * (xz - yw), 2 * (yz + xw), 1 - 2 * (xx + yy), 0,
                        0, 0, 0, 1);
}

function rotX(angle) {
    var rx = Qt.matrix4x4(1, 0, 0, 0,
                          0, Math.cos(angle), -Math.sin(angle), 0,
                          0, Math.sin(angle), Math.cos(angle), 0,
                          0, 0, 0, 1);
    return rx
}

function rotY(angle) {
    var ry = Qt.matrix4x4(Math.cos(angle), 0, Math.sin(angle), 0,
                          0, 1, 0, 0,
                          -Math.sin(angle), 0, Math.cos(angle), 0,
                          0, 0, 0, 1);
    return ry
}

function rotZ(angle) {
    var rz = Qt.matrix4x4(Math.cos(angle), -Math.sin(angle), 0, 0,
                          Math.sin(angle), Math.cos(angle), 0, 0,
                          0, 0, 1, 0,
                          0, 0, 0, 1);
    return rz
}

function trans(vec) {
    var mat = Qt.matrix4x4(1, 0, 0, vec.x,
                           0, 1, 0, vec.y,
                           0, 0, 1, vec.z,
                           0, 0, 0, 1);
    return mat
}

function mat2posvec(mat) {
    var vec = Qt.vector3d(mat.m14, mat.m24, mat.m34)
    return vec
}



function rotm2rpy(rotm) {
    //    console.log("R: ", rotm);
    var rz;
    var rx;
    var ry;

    if (rotm.m31 === 1) {
        rz = 0;
        ry = - Math.PI / 2;
        rx = - rz + Math.atan2(- rotm.m12, - rotm.m13);
    }
    else if (rotm.m31 === -1) {
        rz = 0;
        ry = Math.PI / 2;
        rx = rz + Math.atan2(rotm.m12, rotm.m13);
    }
    else {
        ry = - Math.asin(rotm.m31);
        rx = Math.atan2(rotm.m32 / Math.cos(ry), rotm.m33 / Math.cos(ry));
        rz = Math.atan2(rotm.m21 / Math.cos(ry), rotm.m11 / Math.cos(ry));
    }

    return Qt.vector3d(rx, ry, rz)
}
