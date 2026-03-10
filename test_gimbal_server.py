#!/usr/bin/env python3
#test_gimbal_server.py
import socket
import threading
import time

HOST = '127.0.0.1'
PORT = 5555

def handle_client(conn, addr):
    print(f'✓ Gimbal client connected: {addr}')
    with conn:
        while True:
            try:
                data = conn.recv(1024)
                if not data:
                    break
                message = data.decode('utf-8').strip()
                timestamp = time.strftime('%H:%M:%S')
                print(f'[{timestamp}] GIMBAL COMMAND: {message}')
                
                # Send acknowledgment
                conn.sendall(b'OK\n')
            except Exception as e:
                print(f'✗ Error: {e}')
                break
    print(f'✗ Client disconnected: {addr}')

def main():
    print('=' * 60)
    print('  GIMBAL TCP SERVER')
    print('=' * 60)
    print(f'  Host: {HOST}')
    print(f'  Port: {PORT}')
    print('=' * 60)
    print('Waiting for connections...\n')
    
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.bind((HOST, PORT))
        s.listen()
        
        while True:
            conn, addr = s.accept()
            client_thread = threading.Thread(target=handle_client, args=(conn, addr))
            client_thread.daemon = True
            client_thread.start()

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('\n\nServer stopped.')