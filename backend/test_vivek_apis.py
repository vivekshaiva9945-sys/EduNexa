import urllib.request
import json

data = json.dumps({'email': 'vivekshaiva9945@gmail.com', 'password': '072007'}).encode()
req = urllib.request.Request('http://127.0.0.1:8000/api/v1/auth/login', data=data, headers={'Content-Type': 'application/json'})
res = urllib.request.urlopen(req)
login_data = json.loads(res.read().decode())['data']
token = login_data['access_token']
headers = {'Authorization': f'Bearer {token}', 'Content-Type': 'application/json'}

print("[*] Authentication Successful:")
print(f"    User ID: {login_data['user_id']}")
print(f"    Role: {login_data['role']}")
print(f"    Profile ID: {login_data['profile_id']}")

endpoints = [
    ('/auth/me', 'http://127.0.0.1:8000/api/v1/auth/me'),
    ('/student/me/attendance', 'http://127.0.0.1:8000/api/v1/student/me/attendance'),
    ('/student/me/timetable', 'http://127.0.0.1:8000/api/v1/student/me/timetable'),
    ('/student/me/grades', 'http://127.0.0.1:8000/api/v1/student/me/grades'),
    ('/student/me/progress-report', 'http://127.0.0.1:8000/api/v1/student/me/progress-report'),
    ('/student/me/courses', 'http://127.0.0.1:8000/api/v1/student/me/courses'),
    ('/student/assignments', 'http://127.0.0.1:8000/api/v1/student/assignments'),
    ('/student/examinations', 'http://127.0.0.1:8000/api/v1/student/examinations'),
    ('/student/fee-ledger', 'http://127.0.0.1:8000/api/v1/student/fee-ledger'),
]

for name, url in endpoints:
    r = urllib.request.Request(url, headers=headers)
    resp = urllib.request.urlopen(r)
    body = json.loads(resp.read().decode())
    d = body.get('data')
    if isinstance(d, list):
        summary = f"{len(d)} items returned"
    elif isinstance(d, dict):
        summary = f"dict keys: {list(d.keys())[:4]}"
    else:
        summary = str(d)[:40]
    print(f"[OK] {name.ljust(30)} -> {summary}")
