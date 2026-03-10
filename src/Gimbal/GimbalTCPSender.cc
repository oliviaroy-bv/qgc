#include "GimbalTCPSender.h"
#include <QDebug>
#include <QTimer>

GimbalTCPSender::GimbalTCPSender(QObject *parent)
    : QObject(parent)
    , _socket(new QTcpSocket(this))
    , _cameraIP("192.168.144.108")
    , _cameraPort(5000)
    , _connected(false)
{
    connect(_socket, &QTcpSocket::connected, this, &GimbalTCPSender::onSocketConnected);
    connect(_socket, &QTcpSocket::disconnected, this, &GimbalTCPSender::onSocketDisconnected);
    connect(_socket, &QTcpSocket::readyRead, this, &GimbalTCPSender::onSocketReadyRead);
    connect(_socket, QOverload<QAbstractSocket::SocketError>::of(&QTcpSocket::errorOccurred),
            this, &GimbalTCPSender::onSocketError);
    
    qDebug() << "GimbalTCPSender created for Skydroid C20";
}

GimbalTCPSender::~GimbalTCPSender()
{
    if (_socket->state() == QAbstractSocket::ConnectedState) {
        _socket->disconnectFromHost();
        if (_socket->state() != QAbstractSocket::UnconnectedState) {
            _socket->waitForDisconnected(3000);
        }
    }
}

void GimbalTCPSender::setCameraIP(const QString& ip)
{
    if (_cameraIP != ip) {
        _cameraIP = ip;
        emit cameraIPChanged();
    }
}

void GimbalTCPSender::setCameraPort(int port)
{
    if (_cameraPort != port) {
        _cameraPort = port;
        emit cameraPortChanged();
    }
}

void GimbalTCPSender::connectToCamera()
{
    if (_socket->state() != QAbstractSocket::ConnectedState) {
        qDebug() << "Connecting to C20 camera:" << _cameraIP << ":" << _cameraPort;
        _socket->connectToHost(_cameraIP, _cameraPort);
    } else {
        qDebug() << "Already connected to C20 camera";
    }
}

void GimbalTCPSender::disconnectFromCamera()
{
    if (_socket->state() == QAbstractSocket::ConnectedState) {
        qDebug() << "Disconnecting from C20 camera";
        _socket->disconnectFromHost();
    }
}

QString GimbalTCPSender::calculateChecksum(const QString& command)
{
    int crc = 0;
    for (const QChar &ch : command) {
        crc += ch.unicode();
    }
    return QString("%1").arg(crc & 0xFF, 2, 16, QChar('0')).toUpper();
}

QString GimbalTCPSender::buildC20Command(const QString& frameHead, const QString& addressBit,
                                        const QString& dataLength, const QString& controlBit,
                                        const QString& identificationBit, const QString& data)
{
    QString baseCommand = frameHead + addressBit + dataLength + controlBit + identificationBit + data;
    QString checksum = calculateChecksum(baseCommand);
    return baseCommand + checksum;
}

void GimbalTCPSender::sendCommand(const QString& qgcCommand)
{
    if (!_connected || _socket->state() != QAbstractSocket::ConnectedState) {
        qWarning() << "Cannot send command - not connected to C20 camera";
        emit errorOccurred("Not connected to C20 camera");
        return;
    }
    
    // Translate QGC gimbal commands to C20 protocol
    QString c20Command;
    QString cmd = qgcCommand.trimmed().toUpper();
    
    if (cmd == "UP") {
        // Pitch up (negative speed)
        uint8_t speedByte = static_cast<uint8_t>(+50);
        QString speedHex = QString("%1").arg(speedByte, 2, 16, QChar('0')).toUpper();
        c20Command = buildC20Command("#TP", "UG", "2", "w", "GSP", speedHex);
    }
    else if (cmd == "DOWN") {
        // Pitch down (positive speed)
        uint8_t speedByte = static_cast<uint8_t>(-50);
        QString speedHex = QString("%1").arg(speedByte, 2, 16, QChar('0')).toUpper();
        c20Command = buildC20Command("#TP", "UG", "2", "w", "GSP", speedHex);
    }
    else if (cmd == "LEFT") {
        // Yaw left (negative speed)
        uint8_t speedByte = static_cast<uint8_t>(+50);
        QString speedHex = QString("%1").arg(speedByte, 2, 16, QChar('0')).toUpper();
        c20Command = buildC20Command("#TP", "UG", "2", "w", "GSY", speedHex);
    }
    else if (cmd == "RIGHT") {
        // Yaw right (positive speed)
        uint8_t speedByte = static_cast<uint8_t>(-50);
        QString speedHex = QString("%1").arg(speedByte, 2, 16, QChar('0')).toUpper();
        c20Command = buildC20Command("#TP", "UG", "2", "w", "GSY", speedHex);
    }
    else if (cmd == "CENTER") {
        // Center gimbal - send yaw 0° then pitch 0°
        QString yawCmd = buildC20Command("#TP", "UG", "6", "w", "GAY", "000032");
        QByteArray yawData = yawCmd.toUtf8();
        _socket->write(yawData);
        _socket->flush();
        
        // // Small delay then pitch
        // QThread::msleep(50);
        // c20Command = buildC20Command("#TP", "UG", "6", "w", "GAP", "000032");

        QTimer::singleShot(50, this, [this]() {
            QString pitchCmd = buildC20Command("#TP", "UG", "6", "w", "GAP", "000032");
            QByteArray pitchData = pitchCmd.toUtf8();
            _socket->write(pitchData);
            _socket->flush();
            qDebug() << "Sent pitch center command:" << pitchCmd;
            emit commandSent("CENTER_PITCH");
        });
        
        // Return early since we're handling this differently
        return;
    }
    else if (cmd == "PITCH_UP") {
        // Pitch to -90°
        c20Command = buildC20Command("#TP", "UG", "6", "w", "GAP", "232032");
    }
    else if (cmd == "PITCH_DOWN") {
        // Pitch to +90°
        c20Command = buildC20Command("#TP", "UG", "6", "w", "GAP", "DCE032");
    }
    else if (cmd == "PITCH_LEFT") {
        // Yaw to -90°
        c20Command = buildC20Command("#TP", "UG", "6", "w", "GAY", "DCE032");
    }
    else if (cmd == "PITCH_RIGHT") {
        // Yaw to +90°
        c20Command = buildC20Command("#TP", "UG", "6", "w", "GAY", "232032");
    }
    else if (cmd == "OPT_ZOOM_IN" || cmd == "DIG_ZOOM_IN") {
        c20Command = buildC20Command("#TP", "UD", "2", "w", "DZM", "0A");
    }
    else if (cmd == "OPT_ZOOM_OUT" || cmd == "DIG_ZOOM_OUT") {
        c20Command = buildC20Command("#TP", "UD", "2", "w", "DZM", "0B");
    }
    else if (cmd == "MODE_DAY") {
        c20Command = buildC20Command("#TP", "UD", "2", "w", "NIT", "00");
    }
    else if (cmd == "MODE_IR") {
        c20Command = buildC20Command("#TP", "UD", "2", "w", "NIT", "02");
    }
    else {
        qWarning() << "Unknown command:" << cmd;
        emit errorOccurred(QString("Unknown command: %1").arg(cmd));
        return;
    }
    
    // Send the C20 command
    QByteArray data = c20Command.toUtf8();
    qint64 bytesWritten = _socket->write(data);
    _socket->flush();
    
    if (bytesWritten == -1) {
        qWarning() << "Failed to send command to C20:" << c20Command;
        emit errorOccurred("Failed to send command");
    } else {
        qDebug() << "Sent C20 command:" << c20Command << "(" << bytesWritten << "bytes)";
        emit commandSent(qgcCommand);
    }
}

void GimbalTCPSender::onSocketConnected()
{
    _connected = true;
    qDebug() << "Connected to C20 camera:" << _cameraIP << ":" << _cameraPort;
    emit connectedChanged();
    
    // Send version query to test connection
    QString testCommand = buildC20Command("#TP", "UD", "2", "r", "VER", "00");
    QByteArray data = testCommand.toUtf8();
    _socket->write(data);
    _socket->flush();
}

void GimbalTCPSender::onSocketDisconnected()
{
    _connected = false;
    qDebug() << "Disconnected from C20 camera";
    emit connectedChanged();
}

void GimbalTCPSender::onSocketReadyRead()
{
    QByteArray data = _socket->readAll();
    QString response = QString::fromUtf8(data);
    qDebug() << "C20 Response:" << response;
    emit responseReceived(response);
}

void GimbalTCPSender::onSocketError(QAbstractSocket::SocketError socketError)
{
    Q_UNUSED(socketError)
    QString errorString = _socket->errorString();
    qWarning() << "C20 TCP error:" << errorString;
    emit errorOccurred(errorString);
    _connected = false;
    emit connectedChanged();
}