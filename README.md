# Operational System – Blueprint

**Dein eigenes CRM & Projektmanagement-System für Selbstständige.**

Dieses Blueprint-Paket enthält alles, was du brauchst, um dir ein vollständiges Operational System zu bauen – ohne monatliche SaaS-Kosten, komplett unter deiner Kontrolle.

---

## Was du bekommst

Ein modernes Web-System mit diesen Modulen:

- **Dashboard** – KPIs, Pipeline-Übersicht, Umsatz-Chart, anstehende Aufgaben
- **CRM** – Kontakte, Unternehmen und eine visuelle Sales-Pipeline (Kanban)
- **Projekte** – Projektverwaltung mit Budget-Tracking und Zeiterfassung
- **Aufgaben** – Kanban-Board mit Drag & Drop, Prioritäten und Fälligkeiten
- **Finanzen** – Zeiterfassung mit Quick-Timer, Rechnungen mit PDF-Export, Angebote
- **Partner** – Vertriebspartner einladen, Kunden zuweisen, Provisionen tracken
- **Reports** – Umsatzentwicklung, Kundenprofitabilität, Pipeline-Forecast
- **Einstellungen** – Firmendaten, Stundensätze, Benutzerverwaltung

Technisch basiert das System auf React + TypeScript, Supabase (Datenbank & Auth) und Vercel (Hosting). Alles im Free Tier möglich – **0 € monatliche Kosten** zum Start.

---

## Was im Paket enthalten ist

| Datei | Was ist das? |
|---|---|
| **BLUEPRINT.md** | Die komplette Bauanleitung – 17 Kapitel, Schritt für Schritt |
| **schema.sql** | Fertiges Datenbank-Schema (15 Tabellen, Triggers, Sicherheitsregeln) |
| **branding.example.md** | Dein Branding-Template – Farben, Fonts, Firmendaten zum Ausfüllen |
| **.env.example** | Vorlage für deine Zugangsdaten (Supabase URL & Key) |
| **README.md** | Diese Datei |

---

## So gehst du vor

### Schritt 1: Vorbereitung (10 Min.)

Erstelle dir kostenlose Accounts bei [Supabase](https://supabase.com), [Vercel](https://vercel.com) und [GitHub](https://github.com), falls du noch keine hast. Installiere [Node.js](https://nodejs.org) (v18+).

### Schritt 2: Branding ausfüllen (15 Min.)

Kopiere `branding.example.md` als `branding.md` und trage deine eigenen Daten ein: Firmenname, Farben, Fonts, Rechnungsinfos, Projekttypen. Das ist die Grundlage für dein gesamtes Design.

### Schritt 3: System bauen (2–4 Std.)

Öffne `BLUEPRINT.md` in deinem AI-gestützten Code-Editor (VS Code mit Copilot, Cursor, Windsurf, Antigravity oder ähnlich). Der Blueprint ist so geschrieben, dass dein AI-Assistent die Anweisungen direkt umsetzen kann – Modul für Modul.

### Schritt 4: Datenbank einrichten (10 Min.)

Erstelle ein Supabase-Projekt, kopiere deine Keys in `.env.local` und führe `schema.sql` im SQL-Editor aus. Fertig – 15 Tabellen mit Sicherheitsregeln.

### Schritt 5: Online stellen (10 Min.)

Push deinen Code zu GitHub, verbinde das Repo mit Vercel, trage die Environment-Variablen ein – dein System ist live.

---

## Voraussetzungen

- Ein Computer mit Node.js (v18+)
- Ein Code-Editor mit AI-Unterstützung
- Grundlegendes Verständnis, wie man ein Terminal benutzt
- Programmierkenntnisse sind **nicht** zwingend nötig – der AI-Assistent übernimmt das Coden

---

## Tipp

Du musst nicht alles auf einmal bauen. Starte mit Dashboard, CRM, Projekte, Aufgaben und Finanzen – das ist der Kern. Partner-System und Reports kannst du jederzeit nachrüsten.

---

## Kosten

| Service | Free Tier | Bei Bedarf |
|---|---|---|
| Supabase | 500 MB Datenbank, 1 GB Storage | Pro ab 25 $/Monat |
| Vercel | 100 GB Bandwidth | Pro ab 20 $/Monat |
| GitHub | Unbegrenzt (auch Private Repos) | – |
| **Gesamt** | **0 €/Monat** | ~45 € bei Wachstum |

---

Viel Erfolg beim Bauen!
