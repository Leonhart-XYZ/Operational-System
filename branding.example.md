# Branding Configuration
# =============================================================
# This file defines YOUR brand identity for the Operational System.
# Replace all placeholder values with your own brand details.
# The AI assistant will use this file to style every component.
# =============================================================

## Company Information

- **Company Name:** Muster GmbH
- **Tagline:** Smarter arbeiten. Besser wachsen.
- **Website:** https://www.muster-gmbh.de
- **Logo File:** logo.svg _(place in /public/)_
- **Favicon:** favicon.ico _(place in /public/)_

## Color Palette

| Token           | Hex Code   | Usage                                      |
|-----------------|------------|---------------------------------------------|
| `brand-primary` | `#2563EB`  | Primary CTA buttons, active nav, highlights |
| `brand-surface` | `#F9FAFB`  | App background, cards, light areas          |
| `brand-dark`    | `#111827`  | Sidebar, dark sections, headlines           |
| `brand-white`   | `#FFFFFF`  | Text on dark backgrounds, card backgrounds  |
| `muted-text`    | `rgba(0,0,0,0.55)` | Secondary text, labels, placeholders |
| `accent-green`  | `#16A34A`  | Success states, positive KPIs               |
| `accent-amber`  | `#D97706`  | Warning states, pending items               |
| `accent-red`    | `#DC2626`  | Error states, danger badges, overdue items  |

## Typography

| Element          | Font Family     | Weight   | Size  |
|------------------|-----------------|----------|-------|
| Page Title (H1)  | Space Grotesk   | 700      | 4xl   |
| Section Title (H2)| Space Grotesk  | 700      | 2xl   |
| Card Title (H3)  | Space Grotesk   | 700      | lg    |
| Body Text         | Inter          | 400      | sm    |
| Labels / Nav      | Inter          | 500      | xs    |
| KPI Values        | Space Grotesk  | 800      | 3xl   |

> **Note:** Space Grotesk and Inter are loaded from Google Fonts.
> You may replace them with your own brand fonts (update the @import in index.css).

## Design Principles

- **Border Radius:** `0px` on all elements (sharp, editorial look)
  - Set to a value like `8px` if you prefer rounded corners
- **Shadows:** None – use `border: 1px solid rgba(0,0,0,0.10)` for depth
  - Set to `shadow-sm` if you prefer subtle shadows
- **Animations:** Framer Motion for all transitions
  - Page entry: opacity 0→1, y 12→0, 250ms ease
  - Card hover: y -2px, 150ms
  - Modal/Sheet: slide from right, 280ms ease

## Layout Structure

```
┌─────────────────────────────────────────────┐
│ TOPBAR (brand-surface)                      │
│ Logo | Page Title           | Timer | User  │
├───────────┬─────────────────────────────────┤
│ SIDEBAR   │ MAIN CONTENT (brand-surface)    │
│ (brand-   │                                 │
│  dark)    │  KPI Cards                      │
│ w-60      │  Tables / Kanban / Charts       │
│           │  Modals / Sheets                │
│ Nav Items │                                 │
└───────────┴─────────────────────────────────┘
```

## Invoice / Quote Branding

- **Company Legal Name:** Muster GmbH
- **Address:** Musterstraße 1, 12345 Musterstadt
- **Tax ID (USt-IdNr.):** DE123456789
- **Bank Name:** Musterbank
- **IBAN:** DE00 0000 0000 0000 0000 00
- **BIC:** MUSTDEFF
- **Invoice Prefix:** `MUSTER`
- **Invoice Format:** `MUSTER-YYYY-NNN` (auto-incremented)
- **Default Tax Rate:** 19%
- **Default Hourly Rate:** 120 €
- **Payment Terms:** 14 Tage netto

## Email / Communication

- **Contact Email:** kontakt@muster-gmbh.de
- **Support Email:** support@muster-gmbh.de
- **Phone:** +49 123 456 789

## Roles (Customize if needed)

| Role           | German Label   | Access Level                              |
|----------------|----------------|-------------------------------------------|
| `admin`        | Administrator  | Full access, settings, user management    |
| `mitarbeiter`  | Mitarbeiter    | Projects, tasks, time tracking            |
| `vertriebler`  | Vertrieb       | CRM, pipeline, quotes (no finance)        |
| `lesezugriff`  | Lesezugriff    | View only, no editing                     |
| `partner`      | Partner        | Own projects & commissions only           |

## Project Types (Customize for your industry)

| Key                       | Label                     |
|---------------------------|---------------------------|
| `beratung`                | Beratung                  |
| `webentwicklung`          | Webentwicklung            |
| `design`                  | Design & Branding         |
| `marketing`               | Marketing                 |
| `prozessoptimierung`      | Prozessoptimierung        |
| `it_support`              | IT Support                |
| `schulung`                | Schulung & Workshops      |
| `sonstiges`               | Sonstiges                 |

> Adjust these to match your service offerings. The system will use these
> as dropdown options when creating projects.
