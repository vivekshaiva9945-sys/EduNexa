# EduNexa Frontend (Next.js 16 + React 19)

Modern, high-performance academic management dashboard built with Next.js (App Router), React 19, Tailwind CSS v4, Lucide Icons, and React Query.

## 🚀 Tech Stack
- **Framework**: Next.js 16 (App Router + Turbopack)
- **UI Library**: React 19 + Tailwind CSS v4 + Framer Motion
- **State & Data Fetching**: TanStack React Query v5 & Axios
- **Charts & Visualizations**: Recharts & OGL 3D

---

## 🛠 Local Setup & Development

### 1. Prerequisites
- Node.js 18.18 or higher (Node 20+ recommended)
- npm or pnpm

### 2. Install Dependencies
```bash
npm install
```

### 3. Environment Variables
Copy `.env.example` to `.env.local`:
```bash
cp .env.example .env.local
```
Ensure `NEXT_PUBLIC_API_URL` points to your running FastAPI backend:
```env
NEXT_PUBLIC_API_URL=http://localhost:8000/api/v1
```

### 4. Run Development Server
```bash
npm run dev
```
Open [http://localhost:3000](http://localhost:3000) in your browser.

---

## ☁️ Deployment on Vercel

1. In [Vercel Dashboard](https://vercel.com/dashboard), click **Add New...** -> **Project**.
2. Connect your `EduNexa-Frontend` GitHub repository.
3. Configuration:
   - **Framework Preset**: Next.js (automatically detected)
   - **Root Directory**: `./`
   - **Build Command**: `npm run build` (or Next.js default)
   - **Output Directory**: `.next` (default)
4. Under **Environment Variables**, add:
   - `NEXT_PUBLIC_API_URL`: `https://your-backend-app.onrender.com/api/v1` (or your Railway backend URL)
5. Click **Deploy**.
