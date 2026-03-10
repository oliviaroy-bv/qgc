#include "GimbalUDPSender.h"
#include <QDebug>

GimbalUDPSender::GimbalUDPSender(QObject* parent)
    : QObject(parent)
    , _socket(new QUdpSocket(this))
{}

void GimbalUDPSender::setCameraIP(const QString& ip)
{
    if (_cameraIP != ip) { _cameraIP = ip; emit cameraIPChanged(); }
}

void GimbalUDPSender::setCameraPort(int port)
{
    if (_cameraPort != port) { _cameraPort = port; emit cameraPortChanged(); }
}

void GimbalUDPSender::sendGimbalCommand(const QString& cmd)
{
    qDebug() << "GimbalUDPSender: dispatching" << cmd;
    dispatchCommand(cmd);
}

void GimbalUDPSender::dispatchCommand(const QString& cmd)
{
    if      (cmd.contains("PITCH_UP"))    sendPitchSpeed(-100);
    else if (cmd.contains("PITCH_DOWN"))  sendPitchSpeed(100);
    else if (cmd.contains("PITCH_LEFT"))  sendYawSpeed(-100);
    else if (cmd.contains("PITCH_RIGHT")) sendYawSpeed(100);
    else if (cmd.contains("UP"))          sendPitchSpeed(-60);
    else if (cmd.contains("DOWN"))        sendPitchSpeed(60);
    else if (cmd.contains("LEFT"))        sendYawSpeed(-60);
    else if (cmd.contains("RIGHT"))       sendYawSpeed(60);
    else if (cmd.contains("CENTER"))      centerGimbal();
    else if (cmd.contains("OPT_ZOOM_IN"))  zoomIn();
    else if (cmd.contains("OPT_ZOOM_OUT")) zoomOut();
    else if (cmd.contains("DIG_ZOOM_IN"))  digitalZoomIn();
    else if (cmd.contains("DIG_ZOOM_OUT")) digitalZoomOut();
    else if (cmd.contains("MODE_DAY"))    setDayMode();
    else if (cmd.contains("MODE_IR"))     setIRMode();
    else qWarning() << "GimbalUDPSender: unknown command:" << cmd;
}

QString GimbalUDPSender::calculateChecksum(const QString& cmd)
{
    int crc = 0;
    for (const QChar& ch : cmd) crc += ch.unicode();
    return QString("%1").arg(crc & 0xFF, 2, 16, QChar('0')).toUpper();
}

QString GimbalUDPSender::buildCommand(const QString& frameHead, const QString& addr,
                                       const QString& dataLen,  const QString& ctrl,
                                       const QString& ident,    const QString& data)
{
    QString base = frameHead + addr + dataLen + ctrl + ident + data;
    return base + calculateChecksum(base);
}

void GimbalUDPSender::sendUDP(const QString& command)
{
    _socket->writeDatagram(command.toUtf8(), QHostAddress(_cameraIP), _cameraPort);
    qDebug() << "GimbalUDPSender: UDP →" << _cameraIP << ":" << _cameraPort << command;
}

void GimbalUDPSender::sendYawSpeed(int speed)
{
    speed = qBound(-100, speed, 100);
    uint8_t b = static_cast<uint8_t>(static_cast<int>((speed / 100.0) * 127));
    sendUDP(buildCommand("#TP", "UG", "2", "w", "GSY",
                         QString("%1").arg(b, 2, 16, QChar('0')).toUpper()));
}

void GimbalUDPSender::sendPitchSpeed(int speed)
{
    speed = qBound(-100, speed, 100);
    uint8_t b = static_cast<uint8_t>(static_cast<int>((speed / 100.0) * 127));
    sendUDP(buildCommand("#TP", "UG", "2", "w", "GSP",
                         QString("%1").arg(b, 2, 16, QChar('0')).toUpper()));
}

void GimbalUDPSender::stopGimbal()
{
    sendUDP(buildCommand("#TP", "UG", "2", "w", "PTZ", "00"));
}

void GimbalUDPSender::centerGimbal()
{
    stopGimbal();
    sendUDP(buildCommand("#TP", "UG", "2", "w", "GSY", "00"));
    sendUDP(buildCommand("#TP", "UG", "2", "w", "GSP", "00"));
}

void GimbalUDPSender::zoomIn()
{
    sendUDP(buildCommand("#TP", "UD", "2", "w", "DZM", "0A"));
}

void GimbalUDPSender::zoomOut()
{
    sendUDP(buildCommand("#TP", "UD", "2", "w", "DZM", "0B"));
}

void GimbalUDPSender::digitalZoomIn()
{
    sendUDP(buildCommand("#TP", "UD", "2", "w", "DZM", "02"));
}

void GimbalUDPSender::digitalZoomOut()
{
    sendUDP(buildCommand("#TP", "UD", "2", "w", "DZM", "01"));
}

void GimbalUDPSender::setDayMode()
{
    sendUDP(buildCommand("#TP", "UD", "2", "w", "NIT", "00"));
}

void GimbalUDPSender::setIRMode()
{
    sendUDP(buildCommand("#TP", "UD", "2", "w", "NIT", "01"));
}