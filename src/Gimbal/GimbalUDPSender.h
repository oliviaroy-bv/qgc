#pragma once
#include <QObject>
#include <QUdpSocket>
#include <QHostAddress>

class GimbalUDPSender : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString cameraIP READ cameraIP WRITE setCameraIP NOTIFY cameraIPChanged)
    Q_PROPERTY(int cameraPort READ cameraPort WRITE setCameraPort NOTIFY cameraPortChanged)

public:
    explicit GimbalUDPSender(QObject* parent = nullptr);

    Q_INVOKABLE void sendGimbalCommand(const QString& cmd);

    QString cameraIP()   const { return _cameraIP; }
    int cameraPort() const { return _cameraPort; }
    void setCameraIP(const QString& ip);
    void setCameraPort(int port);

signals:
    void cameraIPChanged();
    void cameraPortChanged();

private:
    QString buildCommand(const QString& frameHead, const QString& addr,
                         const QString& dataLen,  const QString& ctrl,
                         const QString& ident,    const QString& data);
    QString calculateChecksum(const QString& cmd);
    void sendUDP(const QString& command);
    void dispatchCommand(const QString& cmd);

    void sendYawSpeed(int speed);
    void sendPitchSpeed(int speed);
    void stopGimbal();
    void centerGimbal();
    void zoomIn();
    void zoomOut();
    void digitalZoomIn();
    void digitalZoomOut();
    void setDayMode();
    void setIRMode();

    QUdpSocket* _socket    = nullptr;
    QString     _cameraIP  = "192.168.144.108";
    int     _cameraPort = 5000;
};