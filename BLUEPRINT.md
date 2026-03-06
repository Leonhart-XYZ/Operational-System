# Operational System – Blueprint
## Komplettanleitung: CRM & Projektmanagement für Selbstständige

> **Was ist das?** Dieses Dokument ist eine vollständige Bauanleitung für ein maßgeschneidertes Operational System (CRM + Projektmanagement + Zeiterfassung + Rechnungswesen). Entwickelt für selbstständige Dienstleister, die ihre Kunden, Projekte und Finanzen in einem einzigen System verwalten wollen – ohne monatliche SaaS-Kosten.
>
> **Wie nutze ich es?** Öffne diese Datei in deinem AI-gestützten Code-Editor (VS Code mit Copilot/Claude, Cursor, Windsurf, Antigravity o.ä.) und lass dir das System Schritt für Schritt bauen. Jeder Abschnitt enthält klare Anweisungen, die dein AI-Assistent direkt umsetzen kann.
>
> **Was brauche ich?** Deine ausgefüllte `branding.md`, deine Supabase- und Vercel-Zugangsdaten, und ca. 2-4 Stunden Zeit.

---

## INHALTSVERZEICHNIS

1. [Voraussetzungen & Vorbereitung](#1-voraussetzungen--vorbereitung)
2. [Projekt initialisieren](#2-projekt-initialisieren)
3. [Tech Stack & Dependencies](#3-tech-stack--dependencies)
4. [Supabase Setup (Datenbank)](#4-supabase-setup-datenbank)
5. [Design System & Branding](#5-design-system--branding)
6. [App-Grundgerüst (Layout)](#6-app-grundgerüst-layout)
7. [Authentifizierung](#7-authentifizierung)
8. [Modul 1: Dashboard](#8-modul-1-dashboard)
9. [Modul 2: CRM (Kontakte, Unternehmen, Pipeline)](#9-modul-2-crm)
10. [Modul 3: Projekte](#10-modul-3-projekte)
11. [Modul 4: Aufgaben (Kanban)](#11-modul-4-aufgaben-kanban)
12. [Modul 5: Finanzen (Zeiterfassung, Rechnungen, Angebote)](#12-modul-5-finanzen)
13. [Modul 6: Partner & Provisionen](#13-modul-6-partner--provisionen)
14. [Modul 7: Reports & Analytics](#14-modul-7-reports--analytics)
15. [Modul 8: Einstellungen](#15-modul-8-einstellungen)
16. [Deployment (Vercel)](#16-deployment-vercel)
17. [Nach dem Launch](#17-nach-dem-launch)

---

## 1. VORAUSSETZUNGEN & VORBEREITUNG

### Was du brauchst, bevor du startest:

**Accounts (alle kostenlos):**
- GitHub-Account → https://github.com
- Supabase-Account → https://supabase.com (Free Tier reicht)
- Vercel-Account → https://vercel.com (Free Tier reicht, mit GitHub verbinden)

**Software:**
- Node.js v18+ → https://nodejs.org
- Git → https://git-scm.com
- Code-Editor mit AI-Unterstützung (VS Code, Cursor, Windsurf, Antigravity)

**Vorbereitung:**
1. Erstelle einen Ordner für dein Projekt
2. Kopiere die Dateien aus dem `blueprint/`-Ordner in deinen Projektordner:
   - `branding.example.md` → Kopiere als `branding.md` und fülle DEINE Daten ein
   - `.env.example` → Kopiere als `.env.local` (Werte kommen in Schritt 4)
   - `schema.sql` → Wird in Schritt 4 in Supabase deployed
3. Fülle `branding.md` vollständig aus – das ist die Grundlage für dein gesamtes Design

---

## 2. PROJEKT INITIALISIEREN

> **Anweisung an den AI-Assistenten:**
> Erstelle ein neues Vite + React + TypeScript Projekt mit folgender Konfiguration.

### 2.1 Projekt erstellen

```bash
npm create vite@latest mein-operational-system -- --template react-ts
cd mein-operational-system
```

### 2.2 Ordnerstruktur anlegen

Erstelle folgende Verzeichnisstruktur:

```
src/
├── components/
│   ├── ui/          → Shadcn/UI Basis-Komponenten
│   ├── layout/      → App-Shell, Sidebar, Topbar, Auth
│   └── shared/      → Wiederverwendbare Feature-Komponenten
├── pages/
│   ├── Auth/        → Login, Registrierung
│   ├── Dashboard/   → Hauptübersicht
│   ├── CRM/         → Kontakte, Unternehmen, Pipeline
│   ├── Projects/    → Projektverwaltung
│   ├── Tasks/       → Aufgaben (Kanban)
│   ├── Finance/     → Zeiterfassung, Rechnungen, Angebote
│   ├── Partners/    → Partnerverwaltung & Provisionen
│   ├── Reports/     → Berichte & Analytics
│   └── Settings/    → Systemeinstellungen
├── hooks/           → Custom Hooks (Daten-Fetching)
├── lib/             → Supabase Client, Utilities
├── store/           → Zustand State Stores
├── types/           → TypeScript Interfaces
├── App.tsx          → Router-Setup
├── main.tsx         → React Entry Point
└── index.css        → Globale Styles & Brand-Tokens
```

### 2.3 Git initialisieren

```bash
git init
```

Erstelle `.gitignore`:
```
node_modules
dist
.env.local
.DS_Store
```

---

## 3. TECH STACK & DEPENDENCIES

> **Anweisung an den AI-Assistenten:**
> Installiere alle benötigten Pakete.

### 3.1 Haupt-Dependencies installieren

```bash
# Core
npm install react-router-dom @supabase/supabase-js

# State Management
npm install zustand @tanstack/react-query

# UI Framework
npm install @radix-ui/react-dialog @radix-ui/react-dropdown-menu @radix-ui/react-select @radix-ui/react-tabs @radix-ui/react-tooltip @radix-ui/react-popover @radix-ui/react-switch @radix-ui/react-slot

# Styling & Animation
npm install tailwindcss @tailwindcss/vite tailwind-merge clsx framer-motion class-variance-authority

# Icons
npm install lucide-react

# Forms & Validation
npm install react-hook-form @hookform/resolvers zod

# Charts
npm install recharts

# Drag & Drop (für Kanban)
npm install @dnd-kit/core @dnd-kit/sortable @dnd-kit/utilities

# Dates
npm install date-fns

# PDF Export
npm install @react-pdf/renderer
```

### 3.2 Dev-Dependencies

```bash
npm install -D @types/node
```

### 3.3 Vite konfigurieren

**vite.config.ts:**
```typescript
import path from "path";
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
});
```

### 3.4 TypeScript konfigurieren

**tsconfig.json** – Füge den Path-Alias hinzu:
```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

### 3.5 Shadcn/UI initialisieren

```bash
npx shadcn@latest init
```

Wähle bei der Einrichtung:
- Style: Default
- Base color: Neutral
- CSS variables: Yes

Installiere dann die benötigten Shadcn-Komponenten:

```bash
npx shadcn@latest add button card dialog dropdown-menu input label select separator sheet table tabs textarea badge popover switch tooltip calendar
```

---

## 4. SUPABASE SETUP (DATENBANK)

### 4.1 Supabase-Projekt erstellen

1. Gehe zu https://supabase.com → "New Project"
2. Wähle einen Namen und ein sicheres Datenbank-Passwort
3. Region: Frankfurt (eu-central-1) oder nächstgelegene
4. Warte bis das Projekt bereit ist (~2 Minuten)

### 4.2 API-Keys holen

1. Gehe zu Settings → API
2. Kopiere:
   - **Project URL** → in `.env.local` als `VITE_SUPABASE_URL`
   - **anon / public key** → in `.env.local` als `VITE_SUPABASE_ANON_KEY`

### 4.3 Datenbank-Schema deployen

1. Gehe zu SQL Editor in deinem Supabase Dashboard
2. Öffne die Datei `schema.sql` aus dem blueprint-Ordner
3. Kopiere den gesamten Inhalt und führe ihn im SQL Editor aus
4. Prüfe unter Table Editor ob alle 15 Tabellen erstellt wurden:
   - profiles, companies, contacts, deals, projects, tasks, time_entries, quotes, invoices, invoice_items, activities, documents, partner_assignments, commissions, settings

### 4.4 Authentication einrichten

1. Gehe zu Authentication → Settings
2. Unter "Site URL": Trage `http://localhost:5173` ein
3. Unter "Redirect URLs": Füge hinzu:
   - `http://localhost:5173`
   - `http://localhost:5173/**`
   - (Später deine Vercel-URL)
4. Erstelle deinen Admin-User:
   - Gehe zu Authentication → Users → "Add User"
   - E-Mail + Passwort eingeben
5. Setze die Rolle auf Admin:
   - Gehe zu Table Editor → profiles
   - Finde deinen User und setze `role` auf `admin`

### 4.5 Storage einrichten (für Dokument-Uploads)

1. Gehe zu Storage → "New Bucket"
2. Name: `documents`
3. Public: Aus
4. File size limit: 10 MB
5. Allowed MIME types: `application/pdf, image/*, text/*`

### 4.6 Supabase Client erstellen

> **Anweisung an den AI-Assistenten:**
> Erstelle den Supabase Client.

**src/lib/supabase.ts:**
```typescript
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
```

**src/lib/utils.ts:**
```typescript
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

---

## 5. DESIGN SYSTEM & BRANDING

> **Anweisung an den AI-Assistenten:**
> Lies die Datei `branding.md` im Projektordner und verwende die dort definierten Farben, Fonts und Design-Regeln für ALLE folgenden Komponenten. Jede Komponente MUSS sich an die branding.md halten.

### 5.1 Globale Styles

**src/index.css** – Passe die Werte an deine `branding.md` an:

```css
@import "tailwindcss";
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Space+Grotesk:wght@500;600;700;800&display=swap');

/* ─── Brand Tokens aus branding.md ─── */
@theme {
  --color-brand-primary: #2563EB;   /* ← Aus deiner branding.md */
  --color-brand-surface: #F9FAFB;   /* ← Aus deiner branding.md */
  --color-brand-dark: #111827;       /* ← Aus deiner branding.md */
  --color-brand-white: #FFFFFF;      /* ← Aus deiner branding.md */
  --color-muted-text: rgba(0,0,0,0.55);

  --font-heading: 'Space Grotesk', sans-serif;
  --font-body: 'Inter', sans-serif;
}

/* ─── Design System Overrides ─── */
* {
  border-radius: 0px !important;  /* Scharfes Design – oder Wert aus branding.md */
}

.section-label {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 0.7rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--color-muted-text);
}

.section-label::before {
  content: '';
  width: 1.5rem;
  height: 2px;
  background: var(--color-brand-primary);
  flex-shrink: 0;
}
```

### 5.2 Tailwind konfigurieren

**tailwind.config.ts:**
```typescript
import type { Config } from "tailwindcss";

export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        "brand-primary": "var(--color-brand-primary)",
        "brand-surface": "var(--color-brand-surface)",
        "brand-dark": "var(--color-brand-dark)",
        "brand-white": "var(--color-brand-white)",
        "muted-text": "var(--color-muted-text)",
      },
      fontFamily: {
        heading: ["var(--font-heading)", "sans-serif"],
        body: ["var(--font-body)", "sans-serif"],
      },
      borderRadius: {
        DEFAULT: "0px",  // Oder Wert aus branding.md
      },
    },
  },
  plugins: [],
} satisfies Config;
```

---

## 6. APP-GRUNDGERÜST (LAYOUT)

> **Anweisung an den AI-Assistenten:**
> Baue die App-Shell mit Sidebar, Topbar und Main-Content-Bereich. Verwende die Farben und Fonts aus `branding.md`.

### 6.1 TypeScript Interfaces

**src/types/index.ts** – Erstelle ALLE Interfaces auf einmal:

```typescript
// ─── User & Auth ───
export interface Profile {
  id: string;
  email: string;
  full_name: string;
  role: 'admin' | 'mitarbeiter' | 'vertriebler' | 'lesezugriff' | 'partner';
  avatar_url?: string;
  created_at: string;
  updated_at: string;
}

// ─── CRM ───
export interface Company {
  id: string;
  name: string;
  industry?: string;
  size?: string;
  revenue_class?: string;
  website?: string;
  status: 'interessent' | 'aktiver_kunde' | 'inaktiv' | 'ehemaliger_kunde';
  created_at: string;
  updated_at: string;
}

export interface Contact {
  id: string;
  first_name: string;
  last_name: string;
  email?: string;
  phone?: string;
  position?: string;
  company_id?: string;
  company?: Company;
  birthday?: string;
  notes?: string;
  preferred_channel?: 'email' | 'phone' | 'linkedin' | 'other';
  tags?: string[];
  source?: string;
  follow_up_date?: string;
  created_at: string;
  updated_at: string;
}

// ─── Pipeline ───
export type DealStage =
  | 'lead'
  | 'erstgespraech'
  | 'qualifiziert'
  | 'angebot_erstellt'
  | 'verhandlung'
  | 'gewonnen'
  | 'verloren';

export interface Deal {
  id: string;
  title: string;
  contact_id?: string;
  contact?: Contact;
  company_id?: string;
  company?: Company;
  stage: DealStage;
  expected_value: number;
  probability: number;
  weighted_value: number;
  deal_type?: 'standard' | 'projekt' | 'pauschal';
  loss_reason?: string;
  follow_up_date?: string;
  notes?: string;
  created_at: string;
  updated_at: string;
}

export const DEAL_STAGES: { value: DealStage; label: string; probability: number }[] = [
  { value: 'lead', label: 'Lead', probability: 10 },
  { value: 'erstgespraech', label: 'Erstgespräch', probability: 25 },
  { value: 'qualifiziert', label: 'Qualifiziert', probability: 50 },
  { value: 'angebot_erstellt', label: 'Angebot erstellt', probability: 65 },
  { value: 'verhandlung', label: 'Verhandlung', probability: 80 },
  { value: 'gewonnen', label: 'Gewonnen', probability: 100 },
  { value: 'verloren', label: 'Verloren', probability: 0 },
];

// ─── Projects ───
export type ProjectStatus = 'geplant' | 'aktiv' | 'pausiert' | 'abgeschlossen' | 'abgebrochen';

export interface Project {
  id: string;
  name: string;
  company_id?: string;
  company?: Company;
  contact_id?: string;
  contact?: Contact;
  assigned_user_id?: string;
  assigned_user?: Profile;
  status: ProjectStatus;
  project_type: string;  // Werte aus branding.md "Project Types"
  start_date?: string;
  end_date?: string;
  budget?: number;
  budget_type?: 'einmalig' | 'retainer';
  budget_hours?: number;
  hourly_rate?: number;
  notes?: string;
  created_at: string;
  updated_at: string;
}

// ─── Tasks ───
export type TaskStatus = 'todo' | 'in_progress' | 'review' | 'done';

export const TASK_STATUSES: { value: TaskStatus; label: string }[] = [
  { value: 'todo', label: 'To Do' },
  { value: 'in_progress', label: 'In Bearbeitung' },
  { value: 'review', label: 'Review' },
  { value: 'done', label: 'Erledigt' },
];

export interface Task {
  id: string;
  title: string;
  description?: string;
  project_id?: string;
  project?: Project;
  contact_id?: string;
  assigned_user_id?: string;
  assigned_user?: Profile;
  status: TaskStatus;
  priority: 'hoch' | 'mittel' | 'niedrig';
  due_date?: string;
  is_recurring: boolean;
  recurrence_pattern?: string;
  created_at: string;
  updated_at: string;
}

// ─── Time Tracking ───
export interface TimeEntry {
  id: string;
  user_id: string;
  company_id?: string;
  company?: Company;
  project_id?: string;
  project?: Project;
  task_id?: string;
  date: string;
  duration_min: number;
  description?: string;
  hourly_rate?: number;
  billable: boolean;
  status: 'recorded' | 'reviewed' | 'invoiced';
  invoice_id?: string;
  created_at: string;
  updated_at: string;
}

// ─── Finance ───
export interface Quote {
  id: string;
  deal_id?: string;
  company_id?: string;
  company?: Company;
  contact_id?: string;
  contact?: Contact;
  template_type: 'standard' | 'projekt' | 'pauschal';
  status: 'entwurf' | 'versendet' | 'angesehen' | 'angenommen' | 'abgelehnt';
  version: number;
  total_amount: number;
  valid_until?: string;
  notes?: string;
  created_at: string;
  updated_at: string;
}

export interface Invoice {
  id: string;
  invoice_number: string;
  company_id?: string;
  company?: Company;
  contact_id?: string;
  contact?: Contact;
  project_id?: string;
  quote_id?: string;
  status: 'entwurf' | 'versendet' | 'bezahlt' | 'ueberfaellig' | 'storniert';
  total_amount: number;
  tax_amount: number;
  due_date?: string;
  paid_date?: string;
  notes?: string;
  created_at: string;
  updated_at: string;
}

export interface InvoiceItem {
  id: string;
  invoice_id: string;
  description: string;
  quantity: number;
  unit_price: number;
  total_price: number;
  created_at: string;
}

// ─── Activities ───
export interface Activity {
  id: string;
  contact_id?: string;
  company_id?: string;
  deal_id?: string;
  project_id?: string;
  created_by?: string;
  type: 'anruf' | 'email' | 'meeting' | 'linkedin' | 'notiz';
  subject?: string;
  description?: string;
  follow_up_date?: string;
  created_at: string;
}

// ─── Documents ───
export interface DocumentRecord {
  id: string;
  name: string;
  file_path: string;
  file_size?: number;
  mime_type?: string;
  contact_id?: string;
  company_id?: string;
  project_id?: string;
  uploaded_by?: string;
  created_at: string;
}

// ─── Partners ───
export interface PartnerAssignment {
  id: string;
  partner_id: string;
  company_id?: string;
  company?: Company;
  project_id?: string;
  project?: Project;
  commission_rate: number;
  status: 'aktiv' | 'inaktiv';
  notes?: string;
  created_at: string;
  updated_at: string;
}

export interface Commission {
  id: string;
  partner_user_id: string;
  deal_id?: string;
  invoice_id?: string;
  partner_assignment_id?: string;
  commission_rate: number;
  amount: number;
  status: 'offen' | 'abgerechnet';
  month?: number;
  year?: number;
  description?: string;
  created_at: string;
  updated_at: string;
}
```

### 6.2 Zustand Auth Store

**src/store/authStore.ts:**
```typescript
import { create } from 'zustand';
import type { User, Session } from '@supabase/supabase-js';
import type { Profile } from '@/types';

interface AuthState {
  user: User | null;
  session: Session | null;
  profile: Profile | null;
  isLoading: boolean;
  setUser: (user: User | null) => void;
  setSession: (session: Session | null) => void;
  setProfile: (profile: Profile | null) => void;
  setIsLoading: (loading: boolean) => void;
  reset: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  session: null,
  profile: null,
  isLoading: true,
  setUser: (user) => set({ user }),
  setSession: (session) => set({ session }),
  setProfile: (profile) => set({ profile }),
  setIsLoading: (isLoading) => set({ isLoading }),
  reset: () => set({ user: null, session: null, profile: null, isLoading: false }),
}));
```

### 6.3 Auth Provider

**src/components/layout/AuthProvider.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle einen AuthProvider, der:
> 1. Beim Mount `supabase.auth.getSession()` aufruft
> 2. Einen `onAuthStateChange` Listener registriert
> 3. Bei Session-Änderung das Profil aus der `profiles`-Tabelle lädt
> 4. Alles im Zustand authStore speichert
> 5. Children rendert (kein eigenes UI)

### 6.4 Protected Route

**src/components/layout/ProtectedRoute.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle eine ProtectedRoute-Komponente, die:
> 1. `isLoading` → Lade-Animation mit Logo aus branding.md zeigt
> 2. Keine Session → Redirect zu `/login`
> 3. Session vorhanden → Children rendern

### 6.5 App Shell (Hauptlayout)

**src/components/layout/AppShell.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle das Hauptlayout gemäß der Layout-Struktur in `branding.md`:
> ```
> ┌─────────────────────────────────────┐
> │ TOPBAR (brand-surface)              │
> ├──────────┬──────────────────────────┤
> │ SIDEBAR  │ MAIN CONTENT             │
> │ (brand-  │ (brand-surface)          │
> │  dark)   │ <Outlet /> (React Router)│
> │ w-60     │                          │
> └──────────┴──────────────────────────┘
> ```
> - Verwende `flex h-screen` als Container
> - Sidebar links (fixed width w-60, brand-dark Background)
> - Rechts: flex-1 flex-col mit Topbar oben und scrollbarem Content
> - Content-Bereich: `overflow-y-auto bg-brand-surface p-8`
> - `<Outlet />` von react-router-dom für Page-Rendering

### 6.6 Sidebar

**src/components/layout/Sidebar.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle eine Sidebar mit:
> 1. Logo aus `branding.md` oben (als SVG oder Text-Logo)
> 2. Navigations-Links mit Lucide-Icons:
>    - Dashboard (LayoutDashboard)
>    - CRM (Users)
>    - Projekte (FolderKanban)
>    - Aufgaben (CheckSquare)
>    - Partner (Handshake)
>    - Finanzen (Euro)
>    - Berichte (BarChart3)
>    - Einstellungen (Settings)
> 3. Rolle-basierte Navigation:
>    - Wenn `profile.role === 'partner'`: Nur Übersicht, Meine Projekte, Meine Provisionen
>    - Sonst: Alle Links
> 4. Active-State mit Framer Motion `layoutId="sidebar-active"` für smooth Animation
> 5. NavLink von react-router-dom für Routing
> 6. Dark Background (brand-dark), weiße Schrift (brand-white)
> 7. Hover: leicht aufgehellter Hintergrund

### 6.7 Topbar

**src/components/layout/Topbar.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle eine Topbar mit:
> 1. Links: Seitentitel (dynamisch basierend auf aktueller Route via `useLocation`)
> 2. Rechts: Quick-Timer-Button (Clock Icon), User-Dropdown
> 3. User-Dropdown (Framer Motion animiert):
>    - Name, E-Mail, Rollen-Badge
>    - Link zu Einstellungen
>    - Logout-Button
> 4. Hintergrund: brand-surface mit bottom border
> 5. Click-outside Handler zum Schließen des Dropdowns

### 6.8 Router Setup

**src/App.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle das Routing mit React Router v6:

```typescript
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { AuthProvider } from '@/components/layout/AuthProvider';
import { ProtectedRoute } from '@/components/layout/ProtectedRoute';
import { AppShell } from '@/components/layout/AppShell';
// Import all page components...

const queryClient = new QueryClient({
  defaultOptions: {
    queries: { staleTime: 5 * 60 * 1000, retry: 1 },
  },
});

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <AuthProvider>
        <BrowserRouter>
          <Routes>
            {/* Public Routes */}
            <Route path="/login" element={<LoginPage />} />
            <Route path="/partner-register" element={<PartnerRegisterPage />} />

            {/* Protected Routes */}
            <Route element={<ProtectedRoute><AppShell /></ProtectedRoute>}>
              <Route path="/" element={<DashboardPage />} />
              <Route path="/crm/*" element={<CRMPage />} />
              <Route path="/projekte/*" element={<ProjectsPage />} />
              <Route path="/aufgaben/*" element={<TasksPage />} />
              <Route path="/partner/*" element={<PartnersPage />} />
              <Route path="/provisionen/*" element={<PartnerCommissionsPage />} />
              <Route path="/finanzen/*" element={<FinancePage />} />
              <Route path="/berichte/*" element={<ReportsPage />} />
              <Route path="/einstellungen/*" element={<SettingsPage />} />
            </Route>
          </Routes>
        </BrowserRouter>
      </AuthProvider>
    </QueryClientProvider>
  );
}
```

### 6.9 Shared Components

> **Anweisung an den AI-Assistenten:**
> Erstelle diese wiederverwendbaren Komponenten. ALLE müssen sich an `branding.md` halten.

**PageHeader** (`src/components/shared/PageHeader.tsx`):
- Props: `title: string`, `subtitle?: string`, `actions?: ReactNode`
- Framer Motion Entrance: `opacity 0→1, y 12→0, 250ms`
- H1 mit `font-heading font-bold text-4xl`
- Actions rechts ausgerichtet

**KPICard** (`src/components/shared/KPICard.tsx`):
- Props: `label: string`, `value: string`, `trend?: string`, `variant?: 'default' | 'accent'`
- Default: weißer Hintergrund mit Border
- Accent: brand-primary Hintergrund mit weißer Schrift
- Hover: `whileHover={{ y: -2 }}`
- Label: Uppercase, klein, muted
- Value: `font-heading font-extrabold text-3xl`

**StatusBadge** (`src/components/shared/StatusBadge.tsx`):
- Props: `children: ReactNode`, `variant?: 'active' | 'neutral' | 'warning' | 'danger'`
- Active: brand-primary bg, white text
- Neutral: gray bg, dark text
- Warning: amber bg, dark text
- Danger: red bg, white text
- Uppercase, 11px, font-semibold

**SectionLabel** (`src/components/shared/SectionLabel.tsx`):
- Props: `children: ReactNode`
- Blaue Linie + Uppercase Text (wie in index.css definiert)

**EmptyState** (`src/components/shared/EmptyState.tsx`):
- Props: `icon: LucideIcon`, `title: string`, `description: string`, `action?: ReactNode`
- Zentriert, Icon in hellem Kasten, Titel bold, Description muted

**ActivityFeed** (`src/components/shared/ActivityFeed.tsx`):
- Props: `activities: Activity[]`
- Chronologische Liste mit Typ-Icons
- Datum formatiert mit date-fns

**DocumentsPanel** (`src/components/shared/DocumentsPanel.tsx`):
- Props: `entityType: 'contact' | 'company' | 'project'`, `entityId: string`
- Upload-Button → Supabase Storage
- Liste der hochgeladenen Dateien mit Download-Links

---

## 7. AUTHENTIFIZIERUNG

### 7.1 Login Page

**src/pages/Auth/LoginPage.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle eine Login-Seite mit:
> 1. Zentriertes Layout (flexbox center)
> 2. Logo aus branding.md
> 3. E-Mail-Feld + Passwort-Feld
> 4. Login-Button (brand-primary)
> 5. Fehleranzeige bei falschem Login
> 6. Nach erfolgreichem Login: Redirect zu `/`
> 7. Framer Motion Entrance Animation
> 8. Verwende `supabase.auth.signInWithPassword()`

### 7.2 Auth Hook

**src/hooks/useAuth.ts:**
```typescript
import { useAuthStore } from '@/store/authStore';
import { supabase } from '@/lib/supabase';

export function useAuth() {
  const { user, session, profile, isLoading } = useAuthStore();

  const signIn = async (email: string, password: string) => {
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    return { error };
  };

  const signOut = async () => {
    await supabase.auth.signOut();
    useAuthStore.getState().reset();
  };

  return { user, session, profile, isLoading, signIn, signOut };
}
```

---

## 8. MODUL 1: DASHBOARD

### Data Hooks Pattern

> **Anweisung an den AI-Assistenten:**
> Für JEDES Modul brauchst du Hooks nach diesem Pattern. Erstelle für jede Entität (contacts, companies, deals, projects, tasks, time_entries, invoices, quotes, activities, documents, commissions, partner_assignments) einen Hook mit CRUD-Operationen:

```typescript
// Beispiel: src/hooks/useContacts.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { supabase } from '@/lib/supabase';
import type { Contact } from '@/types';

// READ (Liste)
export function useContacts() {
  return useQuery({
    queryKey: ['contacts'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('contacts')
        .select('*, company:companies(*)')
        .order('created_at', { ascending: false });
      if (error) throw error;
      return data as Contact[];
    },
  });
}

// CREATE
export function useCreateContact() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (contact: Partial<Contact>) => {
      const { data, error } = await supabase
        .from('contacts')
        .insert(contact)
        .select('*, company:companies(*)')
        .single();
      if (error) throw error;
      return data as Contact;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['contacts'] });
    },
  });
}

// UPDATE
export function useUpdateContact() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, ...updates }: Partial<Contact> & { id: string }) => {
      const { data, error } = await supabase
        .from('contacts')
        .update(updates)
        .eq('id', id)
        .select('*, company:companies(*)')
        .single();
      if (error) throw error;
      return data as Contact;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['contacts'] });
    },
  });
}

// DELETE
export function useDeleteContact() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from('contacts').delete().eq('id', id);
      if (error) throw error;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['contacts'] });
    },
  });
}
```

> **Erstelle analoge Hooks für:** useCompanies, useDeals, useProjects, useTasks, useTimeEntries, useInvoices, useQuotes, useActivities, useDocuments, usePartnerAssignments, useCommissions.
> Bei useDeals: weighted_value = expected_value * (probability / 100) vor dem Insert berechnen.
> Bei useTimeEntries: company_id ist direkt verknüpft (nicht nur über project).

### Dashboard Page

**src/pages/Dashboard/index.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle die Dashboard-Seite mit:
>
> 1. **PageHeader**: Titel "Dashboard" mit Begrüßung "Guten [Morgen/Tag/Abend], [Name]"
>
> 2. **4 KPI-Karten** (in einer Reihe, grid-cols-4):
>    - Offene Leads: Anzahl Deals mit stage != gewonnen/verloren
>    - Aktive Projekte: Anzahl Projekte mit status = aktiv
>    - Umsatz Monat: Summe aller bezahlten Rechnungen im aktuellen Monat (€)
>    - Offene Aufgaben: Anzahl Tasks mit status != done
>
> 3. **Pipeline-Übersicht** (Kompakte Kanban-Darstellung):
>    - Stages als Spalten mit Anzahl Deals + Gesamtwert pro Stage
>    - Mini-Karten mit Deal-Titel und Wert
>
> 4. **Umsatz-Chart** (Recharts BarChart):
>    - Monatsweise Ist-Umsatz der letzten 6 Monate
>    - Optionaler Plan-Vergleich
>
> 5. **Nächste Aufgaben** (Top 5):
>    - Aufgaben sortiert nach due_date
>    - Mit Prioritäts-Badge und Projektname
>
> 6. Wenn `profile.role === 'partner'`: Zeige stattdessen Partner-Dashboard
>    mit eigenen Projekten, Provisionen und Umsatz
>
> 7. Alle Sections mit Framer Motion Entrance Animations (staggered)

---

## 9. MODUL 2: CRM

**src/pages/CRM/index.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle die CRM-Seite mit 3 Tabs (Shadcn Tabs):

### Tab 1: Kontakte

> 1. **PageHeader**: "CRM" mit Button "Neuer Kontakt"
> 2. **Suchfeld** oben (filtert Name, E-Mail, Unternehmen)
> 3. **Tabelle** (Shadcn Table):
>    - Spalten: Name, Unternehmen, Position, E-Mail, Tags, Follow-up, Erstellt
>    - Sortierbar nach Spalten
>    - Klick auf Zeile → Detail-Sheet (Slide-over von rechts)
> 4. **Neuer Kontakt Dialog** (Shadcn Dialog):
>    - Felder: Vorname*, Nachname*, E-Mail, Telefon, Position, Unternehmen (Dropdown), Tags, Quelle, Notizen
>    - Validierung mit Zod
>    - Submit → useCreateContact Mutation
> 5. **Kontakt-Detail Sheet** (Shadcn Sheet, von rechts):
>    - Kontaktdaten oben (editierbar)
>    - Tabs im Sheet: Aktivitäten, Deals, Dokumente
>    - ActivityFeed-Komponente mit "Neue Aktivität" Button
>    - Verknüpfte Deals anzeigen
>    - DocumentsPanel für Datei-Uploads

### Tab 2: Unternehmen

> 1. **Tabelle** mit: Name, Branche, Größe, Status, Website
> 2. **Neues Unternehmen Dialog**: Name*, Branche, Größe, Umsatzklasse, Website, Status
> 3. **Detail Sheet**: Unternehmensdaten + verknüpfte Kontakte + Projekte

### Tab 3: Pipeline (Kanban)

> 1. **Kanban-Board** mit @dnd-kit:
>    - Spalten = Deal-Stages (lead → erstgespraech → qualifiziert → angebot_erstellt → verhandlung → gewonnen/verloren)
>    - Jede Spalte zeigt: Stage-Name, Anzahl Deals, Gesamtwert
>    - Deal-Karten: Titel, Unternehmen, erwarteter Wert, Wahrscheinlichkeit
>    - **Drag & Drop** zwischen Spalten → `useUpdateDealStage` Mutation
>    - Gewonnen/Verloren als separate (abgesetzte) Spalten
> 2. **Neuer Deal Dialog**:
>    - Titel*, Kontakt (Dropdown), Unternehmen (Dropdown), erwarteter Wert, Deal-Typ
>    - Stage startet bei "Lead"
> 3. **Deal Detail Sheet**:
>    - Alle Deal-Daten editierbar
>    - Verlustgrund-Feld (nur bei Stage "verloren")
>    - Follow-up Datum
>    - Verknüpfte Aktivitäten

---

## 10. MODUL 3: PROJEKTE

**src/pages/Projects/index.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle die Projektseite:
>
> 1. **PageHeader**: "Projekte" mit Button "Neues Projekt"
> 2. **Filter-Leiste**: Status-Filter (Alle, Geplant, Aktiv, Pausiert, Abgeschlossen)
> 3. **Projekt-Liste** als Karten (grid-cols-2 oder -3):
>    - Projektname, Kunde, Status-Badge, Typ-Badge
>    - Budget-Anzeige (€ oder Stunden)
>    - Zeitraum (Start → Ende)
>    - Assigned User
>    - Klick → Detail-Ansicht
> 4. **Neues Projekt Dialog**:
>    - Name*, Kunde (Dropdown), Kontakt (Dropdown), Zugewiesen an (Dropdown)
>    - Projekttyp (Dropdown aus branding.md "Project Types")
>    - Start-/Enddatum, Budget, Budget-Typ (Einmalig/Retainer), Stunden, Stundensatz
>    - Notizen
> 5. **Projekt-Detail Seite** (eigene Route oder Sheet):
>    - Projektinfos oben (editierbar)
>    - Sub-Tabs:
>      - **Aufgaben**: Gefilterte Tasks nur für dieses Projekt + "Neue Aufgabe" Button
>      - **Zeiterfassung**: Gefilterte Time Entries + Stunden-Summe
>      - **Dokumente**: DocumentsPanel
>    - Budget-Fortschritt: Verbrauchte Stunden vs. Budget

---

## 11. MODUL 4: AUFGABEN (KANBAN)

**src/pages/Tasks/index.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle die Aufgabenseite:
>
> 1. **PageHeader**: "Aufgaben" mit Button "Neue Aufgabe"
> 2. **View-Switcher**: Kanban | Liste | Kalender (Standard: Kanban)
> 3. **Filter**: Projekt, Zugewiesen an, Priorität
>
> ### Kanban-View:
> - 4 Spalten: To Do → In Bearbeitung → Review → Erledigt
> - @dnd-kit Drag & Drop zwischen Spalten
> - Jede Spalte zeigt Anzahl Tasks
> - Task-Karten:
>   - Titel, Prioritäts-Badge (farbig: hoch=rot, mittel=amber, niedrig=grau)
>   - Projektname (falls verknüpft)
>   - Due-Date mit Überfällig-Warnung (rot wenn past due)
>   - Assigned User Avatar/Initialen
>   - Klick → Detail Sheet
>
> ### Listen-View:
> - Tabelle: Titel, Status, Priorität, Projekt, Fällig am, Zugewiesen an
> - Sortierbar
>
> ### Neue Aufgabe Dialog:
> - Titel*, Beschreibung, Projekt (Dropdown), Zugewiesen an, Priorität, Fällig am
> - Wiederkehrend? Toggle + Muster (täglich/wöchentlich/monatlich)
>
> ### Task Detail Sheet:
> - Alle Felder editierbar
> - Status-Wechsel per Dropdown
> - Verknüpfung zu Projekt und Kontakt

---

## 12. MODUL 5: FINANZEN

**src/pages/Finance/index.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle die Finanzseite mit 3 Tabs:

### Tab 1: Zeiterfassung

> 1. **Monats-Auswahl** oben (Monat/Jahr Picker)
> 2. **Übersicht-KPIs**: Gesamtstunden, Abrechenbar, Nicht-abrechenbar, Umsatz
> 3. **Gruppierte Tabelle** nach Kunde (Company):
>    - Pro Kunde: Summe Stunden, Summe Betrag, Anzahl Einträge
>    - Aufklappbar → einzelne Einträge mit Datum, Projekt, Beschreibung, Dauer, Rate
> 4. **Button "Rechnung erstellen"** pro Kunde:
>    - Erstellt automatisch eine Rechnung aus den offenen Zeiteinträgen des Monats
>    - Setzt time_entries.status auf 'invoiced' und verknüpft invoice_id
> 5. **Quick Time Entry** (im Topbar, Slide-over Panel):
>    - Kunde auswählen (Pflicht)
>    - Projekt auswählen (Optional, gefiltert nach Kunde)
>    - Beschreibung
>    - Datum (Default: heute)
>    - Dauer (Stunden:Minuten Input → speichert als duration_min)
>    - Stundensatz (Default: Projekt-Rate → Settings-Rate → 120€)
>    - Abrechenbar Toggle
>    - Betrag-Vorschau: (duration_min / 60) * hourly_rate
>    - Submit → useCreateTimeEntry + Toast-Notification

### Tab 2: Rechnungen

> 1. **Tabelle**: Rechnungsnummer, Kunde, Status-Badge, Betrag, Fällig am, Bezahlt am
> 2. **Neuer Button** → Rechnung manuell erstellen (oder aus Zeiteinträgen)
> 3. **Rechnungs-Detail Sheet**:
>    - Rechnungskopf: Nummer, Datum, Kunde, Status
>    - Positionen-Tabelle (invoice_items): Beschreibung, Menge, Einzelpreis, Gesamt
>    - Netto, MwSt (aus branding.md), Brutto
>    - Status-Wechsel: Entwurf → Versendet → Bezahlt / Überfällig / Storniert
>    - **PDF Export** Button → Generiert PDF mit react-pdf/renderer:
>      - Briefkopf aus branding.md (Firmenname, Adresse, Logo)
>      - Rechnungsdaten, Positionen, Summen
>      - Zahlungsinformationen aus branding.md (Bank, IBAN, BIC)
> 4. **Auto-Nummerierung**: `[PREFIX]-YYYY-NNN` (Prefix aus branding.md, auto-inkrement aus settings)

### Tab 3: Angebote

> 1. **Tabelle**: Angebotsnummer, Kunde, Template-Typ, Status-Badge, Betrag, Gültig bis
> 2. **Neues Angebot Dialog**:
>    - Deal (Dropdown), Kunde, Kontakt
>    - Template-Typ (Standard, Projekt, Pauschal)
>    - Betrag, Gültig bis
> 3. **Angebots-Detail Sheet**:
>    - Alle Felder editierbar
>    - Versionierung (v1, v2, v3...)
>    - Status-Wechsel: Entwurf → Versendet → Angesehen → Angenommen/Abgelehnt
>    - **PDF Export** im gleichen Design wie Rechnungen

---

## 13. MODUL 6: PARTNER & PROVISIONEN

**src/pages/Partners/index.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle die Partner-Verwaltung:
>
> 1. **PageHeader**: "Partner" mit Button "Partner einladen"
> 2. **Partner-Liste**: Name, E-Mail, Anzahl Zuweisungen, Gesamtprovisionen
> 3. **Partner einladen Dialog**:
>    - Name, E-Mail
>    - Erstellt Einladungslink zur `/partner-register` Seite
> 4. **Partner-Detail Sheet**:
>    - Profildaten
>    - Zuweisungen (Company/Project + Provisionssatz)
>    - Provisionsübersicht nach Monat
>
> **Partner-Registrierung** (src/pages/Auth/PartnerRegisterPage.tsx):
> - Öffentliche Seite
> - Name, E-Mail, Passwort
> - Erstellt User mit role='partner'
>
> **Partner-Commissions Page** (src/pages/Partners/PartnerCommissionsPage.tsx):
> - Für eingeloggte Partner
> - Eigene Provisionen nach Monat/Jahr
> - Status: Offen vs. Abgerechnet
> - Gesamtübersicht YTD

---

## 14. MODUL 7: REPORTS & ANALYTICS

**src/pages/Reports/index.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle die Reports-Seite mit mehreren Sections:
>
> 1. **Monats-Zusammenfassung**:
>    - KPIs: Umsatz, Neue Leads, Gewonnene Deals, Geleistete Stunden
>    - Vergleich zum Vormonat (% Änderung)
>
> 2. **Kundenprofitabilität** (Recharts BarChart):
>    - Top 10 Kunden nach Umsatz
>    - Balken: Umsatz vs. investierte Stunden (dual axis)
>
> 3. **Pipeline-Report**:
>    - Wert pro Stage (gestapeltes Balkendiagramm)
>    - Conversion Rate: Lead → Gewonnen (%)
>
> 4. **Forecast** (Prognose):
>    - Gewichtete Pipeline: Summe(expected_value * probability) für nächste 30/60/90 Tage
>    - Visualisierung als KPI-Karten
>
> 5. **Monatsvergleich** (Recharts LineChart):
>    - Umsatz der letzten 12 Monate
>    - Trend-Linie
>
> Alle Charts mit Recharts, Design aus branding.md (brand-primary als Hauptfarbe).

---

## 15. MODUL 8: EINSTELLUNGEN

**src/pages/Settings/index.tsx:**

> **Anweisung an den AI-Assistenten:**
> Erstelle die Einstellungsseite (nur für role='admin'):
>
> 1. **Unternehmensprofil**:
>    - Firmenname, Adresse, Steuer-ID, E-Mail, Telefon
>    - Logo-Upload (Supabase Storage)
>    - Gespeichert in settings-Tabelle (key='company_info')
>
> 2. **Stundensätze**:
>    - Default-Stundensatz
>    - Jahresweise Konfiguration (2025: 120€, 2026: 130€, ...)
>    - Gespeichert in settings (key='hourly_rates')
>
> 3. **Rechnungseinstellungen**:
>    - Rechnungs-Prefix
>    - Nächste Rechnungsnummer
>    - Standard-Zahlungsfrist (Tage)
>    - MwSt-Satz
>
> 4. **Benutzerverwaltung**:
>    - Liste aller Benutzer mit Rollen
>    - "User einladen" Button
>    - Rolle ändern (Dropdown)
>
> Alle Formulare mit react-hook-form + Zod.
> Save-Button speichert per Supabase UPDATE in settings/profiles Tabelle.

---

## 16. DEPLOYMENT (VERCEL)

### Schritt-für-Schritt Anleitung

### 16.1 Code vorbereiten

```bash
# Prüfe ob der Build funktioniert
npm run build

# Prüfe TypeScript Fehler
npx tsc --noEmit

# Stelle sicher, dass .env.local NICHT im Repo ist
cat .gitignore  # Sollte .env.local enthalten
```

### 16.2 GitHub Repository erstellen

1. Gehe zu GitHub → "New Repository"
2. Name wählen (z.B. `mein-operational-system`)
3. Private Repository empfohlen
4. Push deinen Code:

```bash
git add .
git commit -m "Initial commit: Operational System"
git remote add origin https://github.com/DEIN-USERNAME/REPO-NAME.git
git push -u origin main
```

### 16.3 Vercel-Projekt erstellen

1. Gehe zu https://vercel.com → "Add New Project"
2. Importiere dein GitHub Repository
3. Framework Preset: **Vite** (wird automatisch erkannt)
4. Build Command: `npm run build`
5. Output Directory: `dist`
6. **Environment Variables** hinzufügen:
   - `VITE_SUPABASE_URL` = dein Supabase Project URL
   - `VITE_SUPABASE_ANON_KEY` = dein Supabase Anon Key
7. Klicke "Deploy"

### 16.4 Supabase Redirect URLs aktualisieren

1. Gehe zu Supabase Dashboard → Authentication → URL Configuration
2. Füge deine Vercel-URL hinzu:
   - `https://dein-projekt.vercel.app`
   - `https://dein-projekt.vercel.app/**`
3. Wenn du eine Custom Domain hast:
   - `https://deine-domain.de`
   - `https://deine-domain.de/**`

### 16.5 Custom Domain (optional)

1. In Vercel → Project Settings → Domains
2. Füge deine Domain hinzu
3. Konfiguriere DNS:
   - CNAME: `cname.vercel-dns.com`
   - Oder A-Record: `76.76.21.21`
4. SSL wird automatisch eingerichtet

### 16.6 Nach dem Deployment prüfen

- [ ] Login funktioniert
- [ ] Daten werden geladen (keine CORS-Fehler)
- [ ] Neue Einträge können erstellt werden
- [ ] Datei-Uploads funktionieren
- [ ] PDF-Export funktioniert
- [ ] Mobile Ansicht prüfen

---

## 17. NACH DEM LAUNCH

### Regelmäßige Wartung

- **Supabase**: Prüfe regelmäßig die Datenbank-Größe (Free Tier: 500MB)
- **Backups**: Supabase erstellt automatische Backups (Pro Plan)
- **Updates**: Halte Dependencies aktuell (`npm outdated`, `npm update`)
- **Monitoring**: Vercel Analytics für Performance-Daten

### Mögliche Erweiterungen

- **E-Mail-Integration**: Rechnungen/Angebote direkt per E-Mail versenden
- **Kalendar-Integration**: Calendly/Google Calendar für Termine
- **Buchhaltungs-Export**: Lexoffice/DATEV CSV-Export
- **Multi-Tenant**: Mehrere Unternehmen in einer Instanz
- **Mobile App**: React Native oder PWA

### Kosten-Übersicht (Free Tiers)

| Service  | Free Tier               | Für Upgrade              |
|----------|-------------------------|--------------------------|
| Supabase | 500MB DB, 1GB Storage   | Pro $25/Monat            |
| Vercel   | 100GB Bandwidth         | Pro $20/Monat            |
| GitHub   | Unbegrenzt (Private)    | -                        |
| **Gesamt** | **0 € / Monat**       | ~45 € bei Bedarf         |

---

## ZUSAMMENFASSUNG DER DATEIEN

Dieses Blueprint-Paket enthält:

| Datei | Zweck |
|-------|-------|
| `BLUEPRINT.md` | Diese Anleitung – das Hauptdokument |
| `schema.sql` | Komplettes Datenbank-Schema für Supabase |
| `branding.example.md` | Branding-Template zum Ausfüllen |
| `.env.example` | Environment-Variablen Template |

### Empfohlene Reihenfolge

1. `branding.example.md` kopieren → als `branding.md` ausfüllen
2. `.env.example` kopieren → als `.env.local` ausfüllen (nach Supabase Setup)
3. `schema.sql` in Supabase SQL Editor ausführen
4. `BLUEPRINT.md` in deinem AI-Editor öffnen und Modul für Modul durcharbeiten

---

> **Tipp:** Du musst nicht alles auf einmal bauen. Starte mit den Modulen 1-5 (Dashboard, CRM, Projekte, Tasks, Finanzen) – das ist der Kern. Partner und Reports kannst du später hinzufügen.

> **Viel Erfolg beim Bauen deines eigenen Operational Systems!**
