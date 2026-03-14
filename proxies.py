# Replace with a real proxy IP and port
# Example: 'http://user:password@host:port' (if authenticated)
# or 'http://host:port' (if open)
import requests

adapter = requests.adapters.HTTPAdapter(pool_connections=1, pool_maxsize=1)

session = requests.Session()
session.mount('https://', adapter)

proxies = {
    'http': 'socks4://36.83.78.197:8080',
    'https': 'socks4://36.83.78.197:8080'
}

session.proxies.update(proxies)

# Test if it works
try:
    # Use a 15s timeout because free proxies are notoriously slow
    r = session.get("https://httpbin.org/ip", timeout=15)
    print(f"Success! Proxy IP is: {r.json()['origin']}")
except Exception as e:
    print(f"Proxy failed: {e}. The proxy might be dead or offline.")