#!/usr/bin/env python3
"""
Simple HTTP server to run the Flutter Dodge web game locally.
"""

import http.server
import socketserver
import webbrowser
import os
import sys

def main():
    # Change to the web directory
    web_dir = os.path.join(os.path.dirname(__file__), 'web')
    if not os.path.exists(web_dir):
        print("Error: web directory not found!")
        sys.exit(1)
    
    os.chdir(web_dir)
    
    # Set up the server
    PORT = 8000
    
    # Create the server
    Handler = http.server.SimpleHTTPRequestHandler
    Handler.extensions_map.update({
        '.html': 'text/html',
        '.js': 'application/javascript',
        '.css': 'text/css',
    })
    
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        print(f"Server started at http://localhost:{PORT}")
        print("Opening game in your default browser...")
        print("Press Ctrl+C to stop the server")
        
        # Open the game in the default browser
        webbrowser.open(f'http://localhost:{PORT}')
        
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped.")
            httpd.shutdown()

if __name__ == "__main__":
    main() 