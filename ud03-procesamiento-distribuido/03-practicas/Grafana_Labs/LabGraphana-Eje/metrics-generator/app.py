from http.server import BaseHTTPRequestHandler, HTTPServer
import random
import time

class MetricsHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/metrics":
            cpu = random.uniform(10, 90)
            requests = random.randint(50, 300)

            metrics = f"""
# HELP fake_cpu_usage CPU usage percentage
# TYPE fake_cpu_usage gauge
fake_cpu_usage {cpu}

# HELP fake_requests_total Number of requests
# TYPE fake_requests_total counter
fake_requests_total {requests}
"""
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(metrics.encode())
        else:
            self.send_response(404)
            self.end_headers()

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8000), MetricsHandler)
    print("Metrics generator running on port 8000")
    server.serve_forever()