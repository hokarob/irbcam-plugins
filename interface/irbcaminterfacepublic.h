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
 * @note The API class is defined in C++ and is registered in QML as **IrbcamQml.InterfacePublic**
 * 
 * C++ types defined here are converted into QML types. See the [official documentation on type conversion](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html).
 * 
 * To utilize this interface in your QML plugins, include the following import statement at the beginning of your QML files:
 * ```
 * import IrbcamQml.InterfacePublic
 * ```
 */
class IrbcamInterfacePublic : public QObject
{
    Q_OBJECT

    /**
     * @brief Q_PROPERTY for checking if IRBCAM is built for web.
     * @note This property is used internally. In the public API the value will always be true
     */
    Q_PROPERTY(bool irbcamForWeb READ IrbcamForWeb CONSTANT)

    /**
     * @brief Q_PROPERTY for accessing the URL of the plugin.
     * @return A constant QString representing the plugin's URL.
     * @note This property is constant and can only be read.
     */
    Q_PROPERTY(QString pluginUrl READ getPluginUrl CONSTANT)
    /**
     * @brief Q_PROPERTY for accessing the name of the plugin.
     * @return A constant QString representing the plugin's name.
     * @note This property is constant and can only be read.
     */
    Q_PROPERTY(QString pluginName READ getPluginName CONSTANT)

    /**
     * @brief Q_PROPERTY for accessing application settings as a JSON object.
     * @return A constant reference to the JSON object containing application settings.
     * @note This property is constant and can only be read.
     */
    Q_PROPERTY(QJsonObject settings READ getSettings CONSTANT)
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
     * velocityMode     | SpeedMode     | Speed mode (see SpeedMode)
     * velocity         | double        | Speed
     * velocityChange   | bool          | Speed change
     * toolNumber       | int           | Tool index
     * toolChange       | bool          | Tool index change
     * spindleSpeed     | double        | Spindle speed
     * spindleChange    | bool          | Spindle speed change
     * motionType       | MotionType    | Motion type (see MotionType)
     * status           | KinSolution   | The current solution state of this target (see KinSolution)
     *
     *
     * These can be accessed either via the Qt [Model/View](https://doc.qt.io/qt-6/qtquick-modelviewsdata-modelview.html)
     * interface or can be read directly using the `dataAt(index, roleName)` method
     *
     *
     */
    Q_PROPERTY(TargetProxyModel* pathModel READ pathModel CONSTANT FINAL)

    /**
     * @brief Q_PROPERTY for accessing the main window's geometry as a QRect.
     * @return A constant reference to the QRect representing the main window's position and size.
     * @note This property can be read and is updated dynamically. Use the mainWindowChanged signal
     * to be notified of changes to the main window's geometry.
     * @sa mainWindowChanged
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
     * The values of this enum are registered with the Qt Meta-Object System using the Q_ENUM() macro,
     * allowing the enum to be used in QML files for integration with QML components.
     *
     * Example usage in QML:
     * @code{qml}
     * Item {
     *     property int selectedSequence: IrbcamInterfacePublic.Xyz
     *     // ...
     * }
     * @endcode
     *
     * @see RotationSequence
     */
    enum RotationSequence {
        Xyz = int(Hokarob::RotationSequence::xyz),
        Xzy = int(Hokarob::RotationSequence::xzy),
        Yxz = int(Hokarob::RotationSequence::yxz),
        Yzx = int(Hokarob::RotationSequence::yzx),
        Zxy = int(Hokarob::RotationSequence::zxy),
        Zyx = int(Hokarob::RotationSequence::zyx),
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
     * @sa RotationSequence
    */
    Q_INVOKABLE QQuaternion eulerToQuaternion(double rx, double ry, double rz, RotationSequence seq);
    /**
     * @brief Converts a Quaternion to Euler angles using the specified rotation sequence.
     * @param quat The input Quaternion to be converted to Euler angles.
     * @param seq The rotation sequence to be used for conversion.
     * @return The resulting Euler angles in radians.
     * @sa RotationSequence
    */
    Q_INVOKABLE QVector3D quaternionToEuler(QQuaternion quat, RotationSequence seq);
    /**
     * @brief Converts an angle from degrees to radians.
     * @param val The angle in degrees to be converted.
     * @return The equivalent angle in radians.
      */
    Q_INVOKABLE double degToRad(double val);
    /**
     * @brief Converts an angle from radians to degrees.
     * @param val The angle in radians to be converted.
     * @return The equivalent angle in degrees.
     */
    Q_INVOKABLE double radToDeg(double val);
    /**
     * @brief Converts transformation matrix to a quaternion
     * @param mat The 4x4 transformation matrix
     * @return The resulting quaternion representing the transformation matrix.
     */
    Q_INVOKABLE QQuaternion matrixToQuaternion(QMatrix4x4 mat);
    /**
     * @brief Converts quaternion to transformation matrix
     * @param quat quaternion
     * @return The resulting transformation matrix representing the quaternion.
     */
    Q_INVOKABLE QMatrix4x4 quaternionToMatrix(QQuaternion quat);
    /**
     * @brief Converts quaternion to Roll Pitch Yaw (RPY) angles.
     * @param quat The input quaternion to be converted to RPY.
     * @return The resulting RPY angles in radians.
    */
    Q_INVOKABLE QVector3D quaternionToRpy(QQuaternion quat);

    TargetProxyModel* pathModel();

    /**
     * @brief Enum representing different coordinate frames.
     *
     * The CoordinateFrame enum defines different coordinate frames used in IRBCAM.
     *
     * The values of this enum are registered with the Qt Meta-Object System using the Q_ENUM() macro,
     * allowing the enum to be used in QML files for integration with QML components.
     *
     * Example usage in QML:
     * @code{qml}
     * Item {
     *     property int frame: IrbcamInterfacePublic.UserFrame
     *     // ...
     * }
     * @endcode
     *
     * @see CoordinateFrame
     */
    enum CoordinateFrame {
        UserFrame = 0,
        ObjectFrame,
        TooltipFrame,
        StationaryToolBaseFrame,
        RobotBaseFrame,
        RotaryTableBaseFrame,
        LinearTrackBaseFrame
    };
    Q_ENUM(CoordinateFrame)

    /**
     * @brief The type of move operation
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
     * @brief Sped mode
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
     * @brief Status of solution
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
     * @brief Sets position and orientation of the coordinate frame.
     * @param frame The coordinate frame whose position and orientation will be set/overwritten.
     * @param position The position of the coordinate frame.
     * @param quat The rotation representation by the quaternion of the coordinate frame.
     * @sa CoordinateFrame
     */
    Q_INVOKABLE void setCoordinateFrame(CoordinateFrame frame, QVector3D position, QQuaternion quat);

    /**
     * @brief Check if IRBCAM is built for web
     * @note This property is used internally. In the public API the value will always be true
     */
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
