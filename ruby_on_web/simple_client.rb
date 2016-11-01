require 'socket'

host = "localhost"
port = 2000

socket = TCPSocket.open(host, port)
response = socket.read
print response
