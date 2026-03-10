#pragma once

#include <QObject>
#include <QTcpSocket>
#include <QString>
#include <QHostAddress>

class GimbalTCPSender : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString cameraIP READ cameraIP WRITE setCameraIP NOTIFY cameraIPChanged)
    Q_PROPERTY(int cameraPort READ cameraPort WRITE setCameraPort NOTIFY cameraPortChanged)
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    
public:
    explicit GimbalTCPSender(QObject *parent = nullptr);
    ~GimbalTCPSender();
    
    // Invokable methods for QML
    Q_INVOKABLE void connectToCamera();
    Q_INVOKABLE void disconnectFromCamera();
    Q_INVOKABLE void sendCommand(const QString& command);
    
    // Property getters
    QString cameraIP() const { return _cameraIP; }
    int cameraPort() const { return _cameraPort; }
    bool connected() const { return _connected; }
    
    // Property setters
    void setCameraIP(const QString& ip);
    void setCameraPort(int port);
    
signals:
    void cameraIPChanged();
    void cameraPortChanged();
    void connectedChanged();
    void commandSent(const QString& command);
    void errorOccurred(const QString& error);
    void responseReceived(const QString& response);
    
private slots:
    void onSocketConnected();
    void onSocketDisconnected();
    void onSocketReadyRead();
    void onSocketError(QAbstractSocket::SocketError socketError);
    
private:
    QString calculateChecksum(const QString& command);
    QString buildC20Command(const QString& frameHead, const QString& addressBit,
                           const QString& dataLength, const QString& controlBit,
                           const QString& identificationBit, const QString& data);
    
    QTcpSocket*     _socket;
    QString         _cameraIP;
    int             _cameraPort;
    bool            _connected;
};