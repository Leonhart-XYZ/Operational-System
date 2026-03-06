-- =============================================================
-- OPERATIONAL SYSTEM – Complete Database Schema
-- =============================================================
-- Deploy this to your Supabase project via SQL Editor.
-- Run this ONCE when setting up a new instance.
-- =============================================================

-- ─────────────────────────────────────────────
-- EXTENSIONS
-- ─────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ─────────────────────────────────────────────
-- 1. PROFILES (extends Supabase auth.users)
-- ─────────────────────────────────────────────
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  full_name TEXT NOT NULL DEFAULT '',
  role TEXT NOT NULL DEFAULT 'mitarbeiter'
    CHECK (role IN ('admin', 'mitarbeiter', 'vertriebler', 'lesezugriff', 'partner')),
  avatar_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─────────────────────────────────────────────
-- 2. COMPANIES (Kunden / Unternehmen)
-- ─────────────────────────────────────────────
CREATE TABLE companies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  industry TEXT,
  size TEXT,
  revenue_class TEXT,
  website TEXT,
  status TEXT NOT NULL DEFAULT 'interessent'
    CHECK (status IN ('interessent', 'aktiver_kunde', 'inaktiv', 'ehemaliger_kunde')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─────────────────────────────────────────────
-- 3. CONTACTS (Ansprechpartner)
-- ─────────────────────────────────────────────
CREATE TABLE contacts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  position TEXT,
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
  birthday DATE,
  notes TEXT,
  preferred_channel TEXT DEFAULT 'email'
    CHECK (preferred_channel IN ('email', 'phone', 'linkedin', 'other')),
  tags TEXT[] DEFAULT '{}',
  source TEXT,
  follow_up_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_contacts_company ON contacts(company_id);

-- ─────────────────────────────────────────────
-- 4. DEALS (Pipeline / Opportunities)
-- ─────────────────────────────────────────────
CREATE TABLE deals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  contact_id UUID REFERENCES contacts(id) ON DELETE SET NULL,
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
  stage TEXT NOT NULL DEFAULT 'lead'
    CHECK (stage IN (
      'lead', 'erstgespraech', 'qualifiziert',
      'angebot_erstellt', 'verhandlung',
      'gewonnen', 'verloren'
    )),
  expected_value NUMERIC(12,2) DEFAULT 0,
  probability INTEGER DEFAULT 0 CHECK (probability >= 0 AND probability <= 100),
  weighted_value NUMERIC(12,2) DEFAULT 0,
  deal_type TEXT CHECK (deal_type IN ('standard', 'projekt', 'pauschal')),
  loss_reason TEXT,
  follow_up_date DATE,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_deals_stage ON deals(stage);
CREATE INDEX idx_deals_company ON deals(company_id);
CREATE INDEX idx_deals_contact ON deals(contact_id);

-- ─────────────────────────────────────────────
-- 5. PROJECTS (Projekte)
-- ─────────────────────────────────────────────
CREATE TABLE projects (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
  contact_id UUID REFERENCES contacts(id) ON DELETE SET NULL,
  assigned_user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  status TEXT NOT NULL DEFAULT 'geplant'
    CHECK (status IN ('geplant', 'aktiv', 'pausiert', 'abgeschlossen', 'abgebrochen')),
  project_type TEXT NOT NULL DEFAULT 'sonstiges',
  -- ↑ Customize project_type CHECK constraint to match your branding.md project types
  start_date DATE,
  end_date DATE,
  budget NUMERIC(12,2),
  budget_type TEXT CHECK (budget_type IN ('einmalig', 'retainer')),
  budget_hours NUMERIC(8,2),
  hourly_rate NUMERIC(8,2) DEFAULT 120,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_assigned ON projects(assigned_user_id);

-- ─────────────────────────────────────────────
-- 6. TASKS (Aufgaben)
-- ─────────────────────────────────────────────
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
  contact_id UUID REFERENCES contacts(id) ON DELETE SET NULL,
  assigned_user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  status TEXT NOT NULL DEFAULT 'todo'
    CHECK (status IN ('todo', 'in_progress', 'review', 'done')),
  priority TEXT NOT NULL DEFAULT 'mittel'
    CHECK (priority IN ('hoch', 'mittel', 'niedrig')),
  due_date DATE,
  is_recurring BOOLEAN DEFAULT false,
  recurrence_pattern TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_assigned ON tasks(assigned_user_id);
CREATE INDEX idx_tasks_project ON tasks(project_id);
CREATE INDEX idx_tasks_due ON tasks(due_date);

-- ─────────────────────────────────────────────
-- 7. TIME ENTRIES (Zeiterfassung)
-- ─────────────────────────────────────────────
CREATE TABLE time_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
  project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
  task_id UUID REFERENCES tasks(id) ON DELETE SET NULL,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  duration_min INTEGER NOT NULL DEFAULT 0,
  description TEXT,
  hourly_rate NUMERIC(8,2),
  billable BOOLEAN DEFAULT true,
  status TEXT NOT NULL DEFAULT 'recorded'
    CHECK (status IN ('recorded', 'reviewed', 'invoiced')),
  invoice_id UUID,  -- FK added after invoices table
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_time_user ON time_entries(user_id);
CREATE INDEX idx_time_company ON time_entries(company_id);
CREATE INDEX idx_time_project ON time_entries(project_id);
CREATE INDEX idx_time_date ON time_entries(date);
CREATE INDEX idx_time_status ON time_entries(status);
CREATE INDEX idx_time_billable ON time_entries(billable);

-- ─────────────────────────────────────────────
-- 8. QUOTES (Angebote)
-- ─────────────────────────────────────────────
CREATE TABLE quotes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  deal_id UUID REFERENCES deals(id) ON DELETE SET NULL,
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
  contact_id UUID REFERENCES contacts(id) ON DELETE SET NULL,
  template_type TEXT DEFAULT 'standard'
    CHECK (template_type IN ('standard', 'projekt', 'pauschal')),
  status TEXT NOT NULL DEFAULT 'entwurf'
    CHECK (status IN ('entwurf', 'versendet', 'angesehen', 'angenommen', 'abgelehnt')),
  version INTEGER DEFAULT 1,
  total_amount NUMERIC(12,2) DEFAULT 0,
  valid_until DATE,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─────────────────────────────────────────────
-- 9. INVOICES (Rechnungen)
-- ─────────────────────────────────────────────
CREATE TABLE invoices (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  invoice_number TEXT UNIQUE NOT NULL,
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
  contact_id UUID REFERENCES contacts(id) ON DELETE SET NULL,
  project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
  quote_id UUID REFERENCES quotes(id) ON DELETE SET NULL,
  status TEXT NOT NULL DEFAULT 'entwurf'
    CHECK (status IN ('entwurf', 'versendet', 'bezahlt', 'ueberfaellig', 'storniert')),
  total_amount NUMERIC(12,2) DEFAULT 0,
  tax_amount NUMERIC(12,2) DEFAULT 0,
  due_date DATE,
  paid_date DATE,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_invoices_due ON invoices(due_date);

-- Add FK from time_entries to invoices
ALTER TABLE time_entries
  ADD CONSTRAINT fk_time_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE SET NULL;
CREATE INDEX idx_time_invoice ON time_entries(invoice_id);

-- ─────────────────────────────────────────────
-- 10. INVOICE ITEMS (Rechnungspositionen)
-- ─────────────────────────────────────────────
CREATE TABLE invoice_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  invoice_id UUID NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
  description TEXT NOT NULL,
  quantity NUMERIC(10,2) DEFAULT 1,
  unit_price NUMERIC(10,2) DEFAULT 0,
  total_price NUMERIC(12,2) DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─────────────────────────────────────────────
-- 11. ACTIVITIES (Interaktionen / CRM History)
-- ─────────────────────────────────────────────
CREATE TABLE activities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  contact_id UUID REFERENCES contacts(id) ON DELETE SET NULL,
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
  deal_id UUID REFERENCES deals(id) ON DELETE SET NULL,
  project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  type TEXT NOT NULL
    CHECK (type IN ('anruf', 'email', 'meeting', 'linkedin', 'notiz')),
  subject TEXT,
  description TEXT,
  follow_up_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_activities_contact ON activities(contact_id);
CREATE INDEX idx_activities_deal ON activities(deal_id);
CREATE INDEX idx_activities_created_by ON activities(created_by);

-- ─────────────────────────────────────────────
-- 12. DOCUMENTS (Dateien / Storage-Referenzen)
-- ─────────────────────────────────────────────
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  file_path TEXT NOT NULL,
  file_size INTEGER,
  mime_type TEXT,
  contact_id UUID REFERENCES contacts(id) ON DELETE SET NULL,
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
  project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
  uploaded_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─────────────────────────────────────────────
-- 13. PARTNER ASSIGNMENTS (Partner ↔ Kunden-Zuordnung)
-- ─────────────────────────────────────────────
CREATE TABLE partner_assignments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  partner_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
  project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
  commission_rate NUMERIC(5,2) DEFAULT 10,
  status TEXT NOT NULL DEFAULT 'aktiv'
    CHECK (status IN ('aktiv', 'inaktiv')),
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─────────────────────────────────────────────
-- 14. COMMISSIONS (Provisionen)
-- ─────────────────────────────────────────────
CREATE TABLE commissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  partner_user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  deal_id UUID REFERENCES deals(id) ON DELETE SET NULL,
  invoice_id UUID REFERENCES invoices(id) ON DELETE SET NULL,
  partner_assignment_id UUID REFERENCES partner_assignments(id) ON DELETE SET NULL,
  commission_rate NUMERIC(5,2) NOT NULL,
  amount NUMERIC(12,2) NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'offen'
    CHECK (status IN ('offen', 'abgerechnet')),
  month INTEGER CHECK (month >= 1 AND month <= 12),
  year INTEGER,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─────────────────────────────────────────────
-- 15. SETTINGS (System-Konfiguration)
-- ─────────────────────────────────────────────
CREATE TABLE settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  key TEXT UNIQUE NOT NULL,
  value JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Default settings (customize via branding.md)
INSERT INTO settings (key, value) VALUES
  ('company_info', '{"name": "Mein Unternehmen", "address": "", "tax_id": "", "email": ""}'),
  ('hourly_rates', '{"default": 120, "2025": 120, "2026": 130}'),
  ('invoice_prefix', '"INV"'),
  ('invoice_next_number', '1');

-- ─────────────────────────────────────────────
-- TRIGGERS
-- ─────────────────────────────────────────────

-- Auto-create profile on user signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, email, full_name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', '')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at_profiles BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at_companies BEFORE UPDATE ON companies FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at_contacts BEFORE UPDATE ON contacts FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at_deals BEFORE UPDATE ON deals FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at_projects BEFORE UPDATE ON projects FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at_tasks BEFORE UPDATE ON tasks FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at_time_entries BEFORE UPDATE ON time_entries FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at_quotes BEFORE UPDATE ON quotes FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at_invoices BEFORE UPDATE ON invoices FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at_settings BEFORE UPDATE ON settings FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at_partner_assignments BEFORE UPDATE ON partner_assignments FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at_commissions BEFORE UPDATE ON commissions FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ─────────────────────────────────────────────
-- ROW LEVEL SECURITY (RLS)
-- ─────────────────────────────────────────────

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE deals ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE time_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE quotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoice_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE partner_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE commissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

-- Profiles: users can read/update own profile
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- General access: authenticated users can CRUD all business data
-- (Adjust these policies to be more restrictive for multi-tenant setups)
CREATE POLICY "Authenticated full access" ON companies FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated full access" ON contacts FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated full access" ON deals FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated full access" ON projects FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated full access" ON tasks FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated full access" ON time_entries FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated full access" ON quotes FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated full access" ON invoices FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated full access" ON invoice_items FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated full access" ON activities FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated full access" ON documents FOR ALL USING (auth.role() = 'authenticated');

-- Partner-specific policies
CREATE POLICY "Non-partners full access" ON partner_assignments
  FOR ALL USING (
    (SELECT role FROM profiles WHERE id = auth.uid()) != 'partner'
  );

CREATE POLICY "Partners see own assignments" ON partner_assignments
  FOR SELECT USING (partner_id = auth.uid());

CREATE POLICY "Partners see own commissions" ON commissions
  FOR SELECT USING (partner_user_id = auth.uid());

CREATE POLICY "Non-partners full access commissions" ON commissions
  FOR ALL USING (
    (SELECT role FROM profiles WHERE id = auth.uid()) != 'partner'
  );

-- Settings: admin only
CREATE POLICY "Admin settings access" ON settings
  FOR ALL USING (
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
  );

-- ─────────────────────────────────────────────
-- STORAGE BUCKET (for document uploads)
-- ─────────────────────────────────────────────
-- Run this separately in Supabase Dashboard → Storage:
-- Create a bucket named "documents" with:
--   Public: false
--   File size limit: 10MB
--   Allowed MIME types: application/pdf, image/*, text/*
--
-- Or via SQL:
-- INSERT INTO storage.buckets (id, name, public, file_size_limit)
-- VALUES ('documents', 'documents', false, 10485760);
