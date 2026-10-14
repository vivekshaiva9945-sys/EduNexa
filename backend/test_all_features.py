import urllib.request
import urllib.error
import json
import uuid
import datetime

BASE_URL = "http://127.0.0.1:8000/api/v1"

def login(email, password):
    data = json.dumps({"email": email, "password": password}).encode()
    req = urllib.request.Request(f"{BASE_URL}/auth/login", data=data, headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req) as resp:
        res = json.loads(resp.read().decode())
        return res["data"]["access_token"], res["data"]

def request(method, path, token, body=None):
    url = f"{BASE_URL}{path}"
    data = json.dumps(body).encode() if body else None
    req = urllib.request.Request(url, data=data, method=method, headers={
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    })
    try:
        with urllib.request.urlopen(req) as resp:
            content = resp.read().decode()
            return resp.getcode(), json.loads(content) if content else {}
    except urllib.error.HTTPError as e:
        err_content = e.read().decode()
        try:
            parsed = json.loads(err_content)
        except Exception:
            parsed = err_content
        return e.code, parsed

def run_tests():
    print("=" * 60)
    print("STARTING FULL END-TO-END FEATURE VERIFICATION SUITE")
    print("=" * 60)

    # 1. ADMIN PORTAL TESTS
    print("\n[+] 1. TESTING ADMIN PORTAL FEATURES...")
    admin_token, admin_info = login("admin@apex.edunexa.edu", "Admin@123")
    print(f"    Admin Logged In: Role={admin_info.get('role')} (College ID: {admin_info.get('college_id')})")

    admin_tests = [
        ("GET", "/auth/me", None),
        ("GET", "/admin/attendance/summary", None),
        ("GET", "/admin/attendance/trends", None),
        ("GET", "/admin/announcements", None),
        ("POST", "/admin/announcements", {
            "title": "Automated System Verification Notice",
            "content": "This notice validates all multi-tenant portal announcement features.",
            "target_role": "ALL"
        }),
        ("GET", "/admin/faculty/activity", None),
        ("GET", "/admin/academic-calendar", None),
        ("POST", "/admin/academic-calendar", {
            "event_title": "End-Term Project Presentations",
            "event_type": "EXAM",
            "start_date": str(datetime.date.today() + datetime.timedelta(days=14)),
            "end_date": str(datetime.date.today() + datetime.timedelta(days=16)),
            "description": "Annual technical showcase and capstone defense."
        })
    ]

    created_announcement_id = None
    for method, path, body in admin_tests:
        code, res = request(method, path, admin_token, body)
        status_str = "PASS" if code in (200, 201) else "FAIL"
        summary = ""
        if status_str == "PASS":
            d = res.get("data")
            if isinstance(d, list):
                summary = f"{len(d)} items returned"
            elif isinstance(d, dict):
                summary = f"keys: {list(d.keys())[:3]}"
                if path == "/admin/announcements" and method == "POST":
                    created_announcement_id = d.get("announcement_id")
            else:
                summary = str(d)[:30]
        else:
            summary = f"Error: {res}"
        print(f"    [{status_str}] {method.ljust(4)} {path.ljust(35)} -> HTTP {code} ({summary})")

    # Clean up created announcement
    if created_announcement_id:
        code, res = request("DELETE", f"/admin/announcements/{created_announcement_id}", admin_token)
        print(f"    [{'PASS' if code == 200 else 'FAIL'}] DELETE /admin/announcements/{{id}}         -> HTTP {code}")

    # Check faculty attendance logs with real faculty id
    code, res = request("GET", "/admin/faculty/activity", admin_token)
    if code == 200 and res.get("data"):
        fac_id = res["data"][0]["faculty_id"]
        code, logs_res = request("GET", f"/admin/faculty/{fac_id}/attendance-logs", admin_token)
        print(f"    [{'PASS' if code == 200 else 'FAIL'}] GET  /admin/faculty/{{id}}/attendance-logs -> HTTP {code} ({len(logs_res.get('data', []))} logs)")


    # 2. FACULTY PORTAL TESTS
    print("\n[+] 2. TESTING FACULTY PORTAL FEATURES...")
    faculty_token, faculty_info = login("rajesh.nambiar@apex.edunexa.edu", "Faculty@123")
    print(f"    Faculty Logged In: Role={faculty_info.get('role')} (Profile: {faculty_info.get('profile_id')})")

    faculty_tests = [
        ("GET", "/auth/me", None),
        ("GET", "/faculty/me/timetable", None),
        ("GET", "/faculty/me/courses", None),
        ("GET", "/faculty/announcements", None),
    ]

    for method, path, body in faculty_tests:
        code, res = request(method, path, faculty_token, body)
        status_str = "PASS" if code in (200, 201) else "FAIL"
        summary = ""
        if status_str == "PASS":
            d = res.get("data")
            if isinstance(d, list):
                summary = f"{len(d)} items returned"
            elif isinstance(d, dict):
                summary = f"keys: {list(d.keys())[:3]}"
        else:
            summary = f"Error: {res}"
        print(f"    [{status_str}] {method.ljust(4)} {path.ljust(35)} -> HTTP {code} ({summary})")

    # Get course-specific endpoints for faculty
    code, courses_res = request("GET", "/faculty/me/courses", faculty_token)
    test_course_id = None
    if code == 200 and courses_res.get("data"):
        test_course_id = courses_res["data"][0]["course_id"]
        print(f"    -> Using Course {courses_res['data'][0]['course_code']} ({test_course_id})")

        # Attendance metrics
        code, met_res = request("GET", f"/faculty/courses/{test_course_id}/attendance-metrics", faculty_token)
        print(f"    [{'PASS' if code == 200 else 'FAIL'}] GET  /faculty/courses/{{id}}/attendance-metrics -> HTTP {code}")

        # Students roster
        code, st_res = request("GET", f"/faculty/courses/{test_course_id}/students", faculty_token)
        print(f"    [{'PASS' if code == 200 else 'FAIL'}] GET  /faculty/courses/{{id}}/students -> HTTP {code} ({len(st_res.get('data', []))} students)")

        # Grades
        code, gr_res = request("GET", f"/faculty/courses/{test_course_id}/grades", faculty_token)
        print(f"    [{'PASS' if code == 200 else 'FAIL'}] GET  /faculty/courses/{{id}}/grades   -> HTTP {code} ({len(gr_res.get('data', []))} grades)")

        # Materials
        code, mat_res = request("GET", f"/faculty/courses/{test_course_id}/materials", faculty_token)
        print(f"    [{'PASS' if code == 200 else 'FAIL'}] GET  /faculty/courses/{{id}}/materials-> HTTP {code} ({len(mat_res.get('data', []))} materials)")

        # Upload material
        code, up_res = request("POST", "/faculty/materials", faculty_token, {
            "course_id": test_course_id,
            "title": "Lecture 08: Dynamic Memory Allocation",
            "description": "Comprehensive reference guide and code examples.",
            "file_type": "PDF",
            "file_url": "https://edunexa.edu/materials/lec08.pdf"
        })
        print(f"    [{'PASS' if code in (200, 201) else 'FAIL'}] POST /faculty/materials            -> HTTP {code}")
        created_mat_id = up_res.get("data", {}).get("material_id")
        if created_mat_id:
            code, del_res = request("DELETE", f"/faculty/materials/{created_mat_id}", faculty_token)
            print(f"    [{'PASS' if code == 200 else 'FAIL'}] DELETE /faculty/materials/{{id}}     -> HTTP {code}")


    # 3. STUDENT PORTAL TESTS
    print("\n[+] 3. TESTING STUDENT PORTAL FEATURES...")
    student_token, student_info = login("vivekshaiva9945@gmail.com", "072007")
    print(f"    Student Logged In: Role={student_info.get('role')} (Profile: {student_info.get('profile_id')})")

    student_tests = [
        ("GET", "/auth/me", None),
        ("GET", "/student/me/attendance", None),
        ("GET", "/student/me/timetable", None),
        ("GET", "/student/me/grades", None),
        ("GET", "/student/me/progress-report", None),
        ("GET", "/student/me/courses", None),
        ("GET", "/student/me/materials", None),
        ("GET", "/student/academic-calendar", None),
        ("GET", "/student/announcements", None),
        ("GET", "/student/assignments", None),
        ("GET", "/student/examinations", None),
        ("GET", "/student/fee-ledger", None),
    ]

    for method, path, body in student_tests:
        code, res = request(method, path, student_token, body)
        status_str = "PASS" if code in (200, 201) else "FAIL"
        summary = ""
        if status_str == "PASS":
            d = res.get("data")
            if isinstance(d, list):
                summary = f"{len(d)} items returned"
            elif isinstance(d, dict):
                summary = f"keys: {list(d.keys())[:3]}"
        else:
            summary = f"Error: {res}"
        print(f"    [{status_str}] {method.ljust(4)} {path.ljust(35)} -> HTTP {code} ({summary})")

    print("\n" + "=" * 60)
    print("VERIFICATION SUITE RUN COMPLETE")
    print("=" * 60)

if __name__ == "__main__":
    run_tests()
