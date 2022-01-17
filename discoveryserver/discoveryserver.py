# https://fhnw.mit-license.org/

from http.server import HTTPServer, BaseHTTPRequestHandler
import socket, json

port = 8000
hostname = socket.gethostname()
response = {"hostname": hostname} 
class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(response).encode())

httpd = HTTPServer(('0.0.0.0', port), SimpleHTTPRequestHandler)
httpd.serve_forever()