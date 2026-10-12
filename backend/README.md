# EduNexa Backend (FastAPI)

Production-grade, multi-tenant academic management REST API built with FastAPI, PostgreSQL / Supabase, and SQLAlchemy.

## 🚀 Tech Stack
- **Framework**: FastAPI (Python 3.10+)
- **Server**: Uvicorn (ASGI)
- **Database**: PostgreSQL (Supabase / Neon / Docker) via SQLAlchemy 2.0 (Async + Sync) & `asyncpg` / `psycopg2`
- **Authentication**: JWT with bcrypt password hashing
- **Data Validation**: Pydantic v2

---

## 🛠 Local Setup & Development

### 1. Prerequisites
- Python 3.10 or higher
- PostgreSQL instance (or free Supabase project)

### 2. Install Dependencies
```bash
python -m venv venv
# On Windows PowerShell:
.\venv\Scripts\Activate.ps1
# On macOS/Linux:
source venv/bin/activate

pip install -r requirements.txt
```

### 3. Environment Variables
Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```
Update `DATABASE_URL` with your local Postgres or Supabase database URI:
```env
DATABASE_URL=postgresql+asyncpg://postgres:[YOUR-PASSWORD]@db.[YOUR-PROJECT-REF].supabase.co:5432/postgres
SECRET_KEY=your-secure-random-32-char-key-here
ENVIRONMENT=development
DEBUG=True
CORS_ORIGINS=["http://localhost:3000","http://127.0.0.1:3000","https://*.vercel.app"]
```

### 4. Database Setup (Supabase / Postgres)
1. Open your **Supabase Dashboard** -> **SQL Editor**.
2. Paste and run the entire contents of `schema.sql` to initialize all 25+ tables, multi-tenant row security policies, and indexes.
3. *(Optional)* Seed demo records by running:
   ```bash
   python seed_db.py
   ```

### 5. Run the Server
```bash
uvicorn app.main:app --reload --port 8000
```
- Interactive Swagger API docs: [http://localhost:8000/docs](http://localhost:8000/docs)
- Health check: [http://localhost:8000/health](http://localhost:8000/health)

---

## ☁️ Deployment Guide

### Deploying on Render (Web Service)
1. In [Render Dashboard](https://dashboard.render.com), click **New +** -> **Web Service**.
2. Connect your `EduNexa-Backend` GitHub repository.
3. Configure settings:
   - **Environment**: `Python 3`
   - **Region**: Choose closest to your database (e.g., Singapore / US East / Frankfurt)
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
4. In **Environment Variables**, add:
   - `DATABASE_URL`: `postgresql+asyncpg://postgres:[PASSWORD]@[HOST]:[PORT]/postgres`
   - `SECRET_KEY`: `<Generate a random 32+ character string>`
   - `ENVIRONMENT`: `production`
   - `DEBUG`: `False`
   - `CORS_ORIGINS`: `["https://*.vercel.app","http://localhost:3000"]` (or comma-separated Vercel frontend domains)

### Deploying on Railway
1. In [Railway Dashboard](https://railway.app), click **New Project** -> **Deploy from GitHub repo**.
2. Select `EduNexa-Backend`.
3. Railway automatically detects Python or Dockerfile.
   - Build Command: `pip install -r requirements.txt`
   - Start Command: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
4. Add the environment variables (`DATABASE_URL`, `SECRET_KEY`, `CORS_ORIGINS`) under the **Variables** tab.
