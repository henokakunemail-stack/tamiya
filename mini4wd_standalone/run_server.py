import http.server
import socketserver
import webbrowser
import os

PORT = 8080
DIRECTORY = r"D:\Henok\Projects\Game\mini4wd_standalone"

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

if __name__ == "__main__":
    os.chdir(DIRECTORY)
    print(f"Server Mini 4WD Standalone: http://localhost:{PORT}")
    webbrowser.open(f"http://localhost:{PORT}/index.html")
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped.")
