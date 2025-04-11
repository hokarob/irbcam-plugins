#ifndef IRBCAMINTERFACEPUBLIC_H
#define IRBCAMINTERFACEPUBLIC_H

#include <QObject>
#include "irbcaminterface.h"
#include <QMatrix4x4>

#include "targetproxymodel.h"

/**
 * @class IrbcamInterfacePublic
 * @brief Public Interface for Extending IRBCAM using QML Plugins.
 *
 * The `IrbcamInterfacePublic` class serves as the public interface for extending IRBCAM with custom plugins. This interface allows plugin developers to access and interact with the core functionality of IRBCAM through QML, making it easier to create feature-rich and customizable extensions.
 * 
 * @note The API class is defined in C++ and is registered in QML as **IRBCAM.InterfacePublic**
 * 
 * C++ types defined here are converted into QML types. See the [official documentation on type conversion](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html).
 * 
 * To utilize this interface in your QML plugins, include the following import statement at the beginning of your QML files:
 * ```
 * import IRBCAM.InterfacePublic
 * ```
 */
class IrbcamInterfacePublic : public QObject
{
    Q_OBJECT

    // Don't use Doxygen documentation on this property. It is only used for development in Hokarob.
    Q_PROPERTY(bool irbcamForWeb READ IrbcamForWeb CONSTANT)
    // Don't use Doxygen documentation on this property. It is needed to load the plugin
    Q_PROPERTY(QString pluginUrl READ getPluginUrl CONSTANT)

    /**
     * @brief Q_PROPERTY for accessing the name of the plugin.
     * @return A constant QString representing the plugin's name as set in File > Settings > Plugins
     * @note This property is constant and can only be read.
     *
     * Example usage in QML:
     * @code{qml}
     * Label {
     *     text: "Plugin name: " + IrbcamInterfacePublic.pluginName
     * }
     * @endcode
     */
    Q_PROPERTY(QString pluginName READ getPluginName CONSTANT)

    /**
     * @brief Access the Cartesian path in the station.
     *
     * This property provides access to the Cartesian path of the robot's motion. The Cartesian path
     * is represented as a model with various access roles. Each component contains specific information related to the
     * robot's motion.
     *
     * @return A TargetProxyModel containing information about the path
     *
     * Available role names are:
     *
     * Role name | Type | Description
     * --- | --- | ---
     * px               | double        | X-position
     * py               | double        | Y-position
     * pz               | double        | Z-position
     * rz1              | double        | First euler rotation (z-axis)
     * ry               | double        | Second euler rotation (y-axis)
     * rz2              | double        | Third euler rotation (z-axis)
     * velocityMode     | \ref SpeedMode     | Speed mode
     * velocity         | double        | Speed
     * velocityChange   | bool          | Speed change
     * toolNumber       | int           | Tool index
     * toolChange       | bool          | Tool index change
     * spindleSpeed     | double        | Spindle speed
     * spindleChange    | bool          | Spindle speed change
     * motionType       | \ref MotionType    | Motion type
     * status           | \ref KinSolution   | The current solution state of this target
     *
     *
     * These can be accessed either via the Qt [Model/View](https://doc.qt.io/qt-6/qtquick-modelviewsdata-modelview.html)
     * interface or can be read directly using the `dataAt(index, roleName)` method
     *
     * @note Contrary to the path editor in the user interface, the index starts at 0.
     *
     * Example usage in QML:
     * @code{qml}
     * Item {
     *      // X position from the first target
     *      property double xStart = IrbcamInterfacePublic.pathModel.dataAt(0, "px");
     * }
     * @endcode
     *
     */
    Q_PROPERTY(TargetProxyModel* pathModel READ pathModel CONSTANT FINAL)

    /**
     * @brief Q_PROPERTY for accessing the main window's geometry as a QRect.
     * @return A constant reference to the QRect representing the main window's position and size.
     * @note This property can be read and is updated dynamically. Use the mainWindowChanged signal
     * to be notified of changes to the main window's geometry.
     *
     * Example usage in QML:
     * @code{qml}
     * Item {
     *     property rect windowSize: IrbcamInterfacePublic.mainWindow
     * }
     * @endcode
     *
     * @sa mainWindowChanged
     * @sa <a href=https://doc.qt.io/qt-6/qml-rect.html>QML type rect</a>
     */
    Q_PROPERTY(QRect mainWindow READ getMainWindow NOTIFY mainWindowChanged)

public:
    explicit IrbcamInterfacePublic(QObject *parent = nullptr);
    virtual ~IrbcamInterfacePublic();


    /**
     * @brief Enum representing different rotation sequences.
     *
     * The RotationSequence enum defines different sequences for rotating objects in 3D space.
     * Each sequence specifies the order in which rotations around X, Y, and Z axes are applied.
     *
     * Example usage in QML:
     * @code{qml}
     * Item {
     *     property int selectedSequence: IrbcamInterfacePublic.Xyz
     *     // ...
     * }
     * @endcode
     *
     * @sa eulerToQuaternion()
     * @sa quaternionToEuler()
     */
    enum RotationSequence {
        /// Rotation in sequence: X > Y > Z
        Xyz = int(Hokarob::RotationSequence::xyz),
        /// Rotation in sequence: X > Z > Y
        Xzy = int(Hokarob::RotationSequence::xzy),
        /// Rotation in sequence: Y > X > Z
        Yxz = int(Hokarob::RotationSequence::yxz),
        /// Rotation in sequence: Y > Z > X
        Yzx = int(Hokarob::RotationSequence::yzx),
        /// Rotation in sequence: Z > X > Y
        Zxy = int(Hokarob::RotationSequence::zxy),
        /// Rotation in sequence: Z > Y > X
        Zyx = int(Hokarob::RotationSequence::zyx),
        /// Rotation in sequence: Z > Y > Z
        Zyz = int(Hokarob::RotationSequence::zyz)
    };
    Q_ENUM(RotationSequence)

    /**
     * @brief Converts Euler angles to a Quaternion using the specified rotation sequence.
     * @param rx The rotation angle around the x axis in radians.
     * @param ry The rotation angle around the y axis in radians.
     * @param rz The rotation angle around the z axis in radians.
     * @param seq The rotation sequence to be used for conversion.
     * @return The resulting Quaternion representing the given Euler angles.
     *
     * Example usage in QML:
     * @code{qml}
     * Item {
     *     // 180 degrees rotation about Z
     *     property quaternion myRotation: IrbcamInterfacePublic.eulerToQuaternion(0, 0, 3.14, IrbcamInterfacePublic.Xyz)
     * }
     * @endcode
     *
     * @sa RotationSequence
     * @sa <a href=https://doc.qt.io/qt-6/qml-quaternion.html>QML type quaternion</a>
    */
    Q_INVOKABLE QQuaternion eulerToQuaternion(double rx, double ry, double rz, RotationSequence seq);
    /**
     * @brief Converts a Quaternion to Euler angles using the specified rotation sequence.
     * @param quat The input Quaternion to be converted to Euler angles.
     * @param seq The rotation sequence to be used for conversion.
     * @return The resulting Euler angles in radians.
     *
     * Example usage in QML:
     * @code{qml}
     * Item {
     *     // -180 degrees rotation about X
     *     property vector3d eulerRotation: IrbcamInterfacePublic.quaternionToEuler(Qt.quaternion(0,1,0,0), IrbcamInterfacePublic.Xyz)
     * }
     * @endcode
     * @sa RotationSequence
     * @sa <a href=https://doc.qt.io/qt-6/qml-quaternion.html>QML type quaternion</a>
     * @sa <a href=https://doc.qt.io/qt-6/qml-vector3d.html>QML type vector3d</a>
    */
    Q_INVOKABLE QVector3D quaternionToEuler(QQuaternion quat, RotationSequence seq);
    /**
     * @brief Converts an angle from degrees to radians.
     * @param val The angle in degrees to be converted.
     * @return The equivalent angle in radians.
     *
     * Example usage in QML:
     * @code{qml}
     * Item {
     *     property double radians: IrbcamInterfacePublic.degToRad(90)
     * }
     * @endcode
     */
    Q_INVOKABLE double degToRad(double val);
    /**
     * @brief Converts an angle from radians to degrees.
     * @param val The angle in radians to be converted.
     * @return The equivalent angle in degrees.
     *
     * Example usage in QML:
     * @code{qml}
     * Item {
     *      // 1 radian in degrees
     *      property double deg: IrbcamInterfacePublic.radToDeg(1.0)
     * }
     * @endcode
     */
    Q_INVOKABLE double radToDeg(double val);
    /**
     * @brief Converts transformation matrix to a quaternion
     * @param mat The 4x4 transformation matrix
     * @return The resulting quaternion representing the transformation matrix.
     *
     * Example usage in QML:
     * @code{qml}
     * function myFunc() {
     *      // Create transformation matrix
     *      var m = Qt.matrix4x4();
     *
     *      // Rotate 90 degrees about X axis
     *      m.rotate(90,Qt.vector3d(1,0,0));
     *
     *      // Convert rotation from m to quaternion
     *      var myQuaternion = IrbcamInterfacePublic.matrixToQuaternion(m);
     *      return myQuaternion;
     *}
     * @endcode
     *
     * @sa <a href="https://doc.qt.io/qt-6/qml-matrix4x4.html">QML type matrix4x4</a>
     * @sa <a href=https://doc.qt.io/qt-6/qml-quaternion.html>QML type quaternion</a>
     */
    Q_INVOKABLE QQuaternion matrixToQuaternion(QMatrix4x4 mat);
    /**
     * @brief Converts quaternion to transformation matrix
     * @param quat quaternion
     * @return The resulting transformation matrix representing the quaternion.
     *
     * Example usage in QML:
     * @code{qml}
     * function myFunc() {
     *      // Create quaternion with 45 degree rotation about Y
     *      var q = Qt.quaternion(-0.8733046, 0, -0.4871745, 0);
     *
     *      // Convert rotation quaternion to matrix
     *      var m = IrbcamInterfacePublic.quaternionToMatrix(q);
     *      return m;
     *}
     * @endcode
     * @sa <a href="https://doc.qt.io/qt-6/qml-matrix4x4.html">QML type matrix4x4</a>
     * @sa <a href=https://doc.qt.io/qt-6/qml-quaternion.html>QML type quaternion</a>
     */
    Q_INVOKABLE QMatrix4x4 quaternionToMatrix(QQuaternion quat);
    
    /**
     * @brief Converts a quaternion to Roll Pitch Yaw (RPY) angles.
     * This function converts a rotation expressed in terms of a quaternion, to a roll-pitch-yaw representation and checks for singulatities.
     * In the returned <a href=https://doc.qt.io/qt-6/qml-vector3d.html>vector3d</a>, the components are mapped like this:
     *
     * Rotation | Vector3D component
     * --- | ---
     * roll     | Vector3D.z
     * pitch    | Vector3D.y
     * yaw      | Vector3D.x
     *
     * @param quat The input quaternion to be converted to RPY.
     * @return The resulting RPY angles in radians as a Vector3D
     *
     * Example usage in QML:
     * @code{qml}
     * function myFunc() {
     *      // Create quaternion with 45 degree rotation about Y
     *      var q = Qt.quaternion(-0.8733046, 0, -0.4871745, 0);
     *
     *      // Convert rotation quaternion to RPY
     *      var rpy = IrbcamInterfacePublic.quaternionToRpy(q);
     *
     *      // Roll: rpy.z
     *      // Pitch: rpy.y
     *      // Yaw: rpy.x
     *
     *      return rpy;
     *}
     * @endcode
     *
     * @sa <a href=https://doc.qt.io/qt-6/qml-quaternion.html>QML type quaternion</a>
     * @sa <a href=https://doc.qt.io/qt-6/qml-vector3d.html>QML type vector3d</a>
    */
    Q_INVOKABLE QVector3D quaternionToRpy(QQuaternion quat);

    TargetProxyModel* pathModel();

    /**
     * @brief Enum representing different coordinate frames.
     *
     * This enum defines different coordinate frames used in IRBCAM.
     *
     *
     * Example usage in QML:
     * @code{qml}
     * Item {
     *     property int frame: IrbcamInterfacePublic.UserFrame
     * }
     * @endcode
     *
     * @sa setCoordinateFrame()
     */
    enum CoordinateFrame {
        /// User frame transformation
        UserFrame = 0,
        /// Object frame transformation
        ObjectFrame,
        /// Tool tip  (TCP) frame transformation
        TooltipFrame,
        /// Stationary tool base frame transformation
        StationaryToolBaseFrame,
        /// Robot base frame transformation
        RobotBaseFrame,
        /// Rotary table base frame transformation
        RotaryTableBaseFrame,
        /// Linear track base frame transformation
        LinearTrackBaseFrame
    };
    Q_ENUM(CoordinateFrame)

    /**
     * @brief Type of move operation
     *
     * This enum describes which a target's kind of move operation.
     *
     * Example usage in QML:
     * @code{qml}
     * Item {
     *     property int motionTypeLinear: IrbcamInterfacePublic.MotionTypeLinear
     * }
     * @endcode
     *
     * @sa pathModel
     */
    enum MotionType
    {
        /// Linear move. Corresponds to moveL
        MotionTypeLinear = int(EMotionType::MotionTypeLinear),
        /// Arc move. Corresponds to moveC
        MotionTypeArcMidpoint = int(EMotionType::MotionTypeArcMidpoint),
        /// Linear lift point. Exported as a linear move
        MotionTypeLinearLiftPoint = int(EMotionType::MotionTypeLinearLiftPoint),
        /// Rotary table lift point. Exported as a linear move
        MotionTypeRotaryLiftPoint1 = int(EMotionType::MotionTypeRotaryLiftPoint1),
        /// Rotary table lift point. Exported as a linear move
        MotionTypeRotaryLiftPoint2 = int(EMotionType::MotionTypeRotaryLiftPoint2),
        /// Rotary table lift point. Exported as a linear move
        MotionTypeRotaryLiftPoint3 = int(EMotionType::MotionTypeRotaryLiftPoint3),
        /// Rotary table lift point. Exported as a linear move
        MotionTypeRotaryLiftPoint4 = int(EMotionType::MotionTypeRotaryLiftPoint4),
    };
    Q_ENUM(MotionType)

    /**
     * @brief Target speed mode
     *
     * This enum describes which speed mode a target follows.
     *
     * Example usage in QML:
     * @code{qml}
     * Item {
     *     property int speedModeInput: IrbcamInterfacePublic.SpeedModeInput
     * }
     * @endcode
     *
     * @sa pathModel
     */
    enum SpeedMode
    {
        /// Manual input
        SpeedModeInput = int(ESpeedMode::SpeedModeInput),
        /// Rapid move speed. Usually a special type of move speed configured by the controller
        SpeedModeRapid = int(ESpeedMode::SpeedModeRapid),
        /// Cutting move speed. Usually a special type of move speed configured by the controller
        SpeedModeCutting = int(ESpeedMode::SpeedModeCutting),
    };
    Q_ENUM(SpeedMode)

    /**
     * @brief Solution status
     *
     * This enum describes the kinematic solution status for a target. The status is reset to KinSolution::NotSolved when changing the path.
     *
     * Example usage in QML:
     * @code{qml}
     * function printSolutionStatus(status) {
     *      switch (status) {
     *
     *      case IrbcamInterfacePublic.NotSolved:
     *          return "Target has not been attempted solved";
     *
     *      case IrbcamInterfacePublic.Failed:
     *          return "Target failed to solve";
     *
     *      case IrbcamInterfacePublic.Solved:
     *          return "Target is solved";
     *
     *      // Break and return "Invalid status" if we don't get a match
     *      default:
     *          break;
     *      }
     *
     *      return "Invalid status";
     * }
     * @endcode
     *
     * @sa pathModel
     */
    enum KinSolution
    {
        /// The target/path is not solved and an attempt to solve it has not been made
        NotSolved = int(EKinSolution::NotSolved),
        /// An attempt to solve the target/path was made, but it failed
        Failed = int(EKinSolution::Failed),
        /// The target /path was solved successfully
        Solved = int(EKinSolution::Solved),
    };
    Q_ENUM(KinSolution)

    /**
     * @brief Sets position and orientation of a given coordinate frame.
     * @param frame The coordinate frame whose position and orientation will be set/overwritten.
     * @param position The position of the coordinate frame in mm
     * @param quat The rotation representation by the quaternion of the coordinate frame.
     *
     * Example usage in QML:
     * @code{qml}
     * function moveRobot() {
     *      let position = Qt.vector3d(100.0, 200.0, 0.0);
     *      let rotation = Qt.quaternion(1.0, 0.0, 0.0, 0.0);
     *
     *      // Set robot base transformation
     *      IrbcamInterfacePublic.setCoordinateFrame(IrbcamInterfacePublic.RobotBaseFrame, position, rotation);
     * }
     *
     * Button {
     *      text: "Move robot"
     *      onClicked: moveRobot()
     * }
     * @endcode
     *
     * @sa CoordinateFrame
     * @sa <a href=https://doc.qt.io/qt-6/qml-quaternion.html>QML type quaternion</a>
     * @sa <a href=https://doc.qt.io/qt-6/qml-vector3d.html>QML type vector3d</a>
     */
    Q_INVOKABLE void setCoordinateFrame(CoordinateFrame frame, QVector3D position, QQuaternion quat);

    static bool IrbcamForWeb();
public slots:

signals:
    /**
     * @brief Signal emitted when the main window size has changed.
     *
     * This signal is emitted whenever the size of the application main window changes.
     * Connect to this signal to perform actions when the main window size is updated.
     */
    void mainWindowChanged();

};

#endif // IRBCAMINTERFACEPUBLIC_H
