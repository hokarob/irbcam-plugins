#ifndef IRBCAMINTERFACEPUBLIC_H
#define IRBCAMINTERFACEPUBLIC_H

#include <QObject>
#include "irbcaminterface.h"
#include <QMatrix4x4>

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
 * is represented as a JSON object with various components, including 'spindle', 'targets', 'tool',
 * and 'velocity'. Each component contains specific information related to the robot's motion.
 *
 * @return A [QJsonObject](https://doc.qt.io/qt-6/qjsonobject.html) representing the Cartesian path in the station.
 *
 * The structure of the QJsonObject object is as follows:
 * \code{.json}
 * {
 *    "spindle": {
 *        "i": [0],
 *        "value": [0]
 *    },
 *    "targets": {
 *        "pX": [1],
 *        "pY": [2],
 *        "pZ": [3],
 *        "rY": [3.141592653589793],
 *        "rZ": [0],
 *        "rZ2": [0],
 *        "type": [0]
 *    },
 *    "tool": {
 *        "i": [0],
 *        "value": [0]
 *    },
 *    "velocity": {
 *        "i": [0],
 *        "value": [-1]
 *    }
 * }
 * \endcode
 *
 * The QJsonObject object contains arrays with values representing the translations and rotations. The length
 * of these arrays depends on the size of the path (number of targets), and the 'tool', 'velocity', and 'spindle' components
 * contain sparse data, where [i] is the index.
 *
 * @note This property is read-only and cannot be modified directly.
 *
 * @see cartesianPathChanged() Signal that is emitted when the Cartesian path changes.
     */
    Q_PROPERTY(QJsonObject cartesianPath READ getCartesianPath NOTIFY cartesianPathChanged)

    /**
     * @brief Q_PROPERTY for accessing the main window's geometry as a QRect.
     * @return A constant reference to the QRect representing the main window's position and size.
     * @note This property can be read and is updated dynamically. Use the mainWindowChanged signal
     * to be notified of changes to the main window's geometry.
     * @sa mainWindowChanged
     */
    Q_PROPERTY(QRect mainWindow READ getMainWindow NOTIFY mainWindowChanged)

    /**
     * @brief Gets the active ui theme (0: dark, 1: light)
     * @note This value is used for internal palette synchronization between IRBCAM and plugins. Inside plugins
     * this value should be accessed via the Colours.currentTheme qml property (import HokarobQml.Theme)
     */
    Q_PROPERTY(int uiTheme READ uiTheme NOTIFY uiThemeChanged)
    /**
     * @brief Gets the active accent colour as a hex string (empty string if default)
     * @note This value is used for internal palette synchronization between IRBCAM and plugins. Inside plugins
     * the accent colour should be accessed via the palette (e.g. palette.accent or palette.highlight)
     */
    Q_PROPERTY(QString accentColour READ accentColour NOTIFY accentColourChanged)

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
     * @param r1 The rotation angle around the first axis in radians.
     * @param r2 The rotation angle around the second axis in radians.
     * @param r3 The rotation angle around the third axis in radians.
     * @param seq The rotation sequence to be used for conversion.
     * @return The resulting Quaternion representing the given Euler angles.
     * @sa RotationSequence
    */
    Q_INVOKABLE QQuaternion eulerToQuaternion(double r1, double r2, double r3, RotationSequence seq);
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
     * @brief Sets position and orientation of the coordinate frame.
     * @param frame The coordinate frame whose position and orientation will be set/overwritten.
     * @param position The position of the coordinate frame.
     * @param quat The rotation representation by the quaternion of the coordinate frame.
     * @sa CoordinateFrame
     */
    Q_INVOKABLE void setCoordinateFrame(CoordinateFrame frame, QVector3D position, QQuaternion quat);



    /**
     * @brief Gets the active ui theme (0: dark, 1: light)
     */
    int uiTheme() const;

    /**
     * @brief Gets the active accent colour as a hex string (empty string if default)
     */
    const QString& accentColour() const;


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
    /**
     * @brief Signal emitted when the Cartesian path has changed.
     *
     * This signal is emitted whenever the Cartesian path used in the station is updated. I.e. if a target is edited.
     * Connect to this signal to be notified of changes in the Cartesian path.
     */
    void cartesianPathChanged();
    /**
     * @brief Signal emitted when the ui theme changes
     */
    void uiThemeChanged();
    /**
     * @brief Signal emitted when the accent colour changes
     */
    void accentColourChanged();

};

#endif // IRBCAMINTERFACEPUBLIC_H
