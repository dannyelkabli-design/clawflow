-- ============================================================
-- Nemoclaw Consultants — Marketplace Database Setup
-- Plak dit in: Supabase Dashboard → SQL Editor → New query
-- ============================================================

-- TABELLEN
CREATE TABLE IF NOT EXISTS consultants (
  id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  naam        text NOT NULL,
  rol         text NOT NULL,
  email       text,
  locatie     text,
  bio         text,
  tarief      text,
  beschikbaar text,
  tags        text[],
  foto        text,
  verified    boolean DEFAULT false,
  created_at  timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS opdrachten (
  id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  bedrijf     text NOT NULL,
  naam        text,
  email       text,
  titel       text NOT NULL,
  beschrijving text,
  sector      text,
  budget      text,
  looptijd    text,
  tags        text[],
  featured    boolean DEFAULT false,
  created_at  timestamptz DEFAULT now()
);

-- ROW LEVEL SECURITY
ALTER TABLE consultants ENABLE ROW LEVEL SECURITY;
ALTER TABLE opdrachten  ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_read_consultants"  ON consultants FOR SELECT USING (true);
CREATE POLICY "public_insert_consultants" ON consultants FOR INSERT WITH CHECK (true);
CREATE POLICY "public_read_opdrachten"   ON opdrachten  FOR SELECT USING (true);
CREATE POLICY "public_insert_opdrachten" ON opdrachten  FOR INSERT WITH CHECK (true);

-- REALTIME (zet tabellen aan voor live updates)
ALTER PUBLICATION supabase_realtime ADD TABLE consultants;
ALTER PUBLICATION supabase_realtime ADD TABLE opdrachten;

-- SEED: CONSULTANTS
INSERT INTO consultants (naam, rol, locatie, bio, tarief, beschikbaar, tags, foto, verified) VALUES
(
  'Maarten van der Berg', 'OpenClaw Specialist', 'Amsterdam, NL',
  '5 jaar ervaring in finance automation. Gespecialiseerd in factuurverwerking, approvals en ERP-integraties voor middelgrote organisaties.',
  '850', 'Beschikbaar per direct',
  ARRAY['OpenClaw', 'Finance', 'ERP', 'SAP'],
  'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=128&h=128&fit=crop&crop=faces&auto=format',
  true
),
(
  'Sophie Roodbergen', 'Nemoclaw Architect', 'Den Haag, NL',
  'Gespecialiseerd in complexe overheidsworkflows en compliance automation. Projecten bij Rijkswaterstaat en meerdere gemeenten.',
  '975', 'Beschikbaar per direct',
  ARRAY['Nemoclaw', 'Overheid', 'Compliance', 'AVG'],
  'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=128&h=128&fit=crop&crop=faces&auto=format',
  true
),
(
  'David Karels', 'AI Workflow Architect', 'Utrecht, NL',
  'Bouwt end-to-end automation oplossingen voor HR en operations teams. Gecertificeerd in zowel OpenClaw als Nemoclaw platforms.',
  '1100', 'Binnenkort beschikbaar',
  ARRAY['OpenClaw', 'Nemoclaw', 'HR', 'Operations'],
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=128&h=128&fit=crop&crop=faces&auto=format',
  true
),
(
  'Lisa Hermans', 'Process Automation Lead', 'Rotterdam, NL',
  'Specialisatie in klantgerichte automation: van CRM-koppeling tot e-mail triage en chatbot implementaties bij grote retailers.',
  '800', 'Beschikbaar per direct',
  ARRAY['OpenClaw', 'Klantenservice', 'CRM', 'Retail'],
  'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=128&h=128&fit=crop&crop=faces&auto=format',
  false
),
(
  'Thomas Brouwer', 'Nemoclaw Senior Consultant', 'Eindhoven, NL',
  'Supply chain en logistiek automation expert. Bouwde automatische orderverwerking voor 3 van de top-10 Nederlandse logistieke bedrijven.',
  '925', 'Beschikbaar per direct',
  ARRAY['Nemoclaw', 'Logistiek', 'Supply Chain', 'EDI'],
  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=128&h=128&fit=crop&crop=faces&auto=format',
  true
),
(
  'Emma van Dijk', 'Finance Automation Consultant', 'Amsterdam, NL',
  'Audit-proof automation voor finance teams. Specialisatie in AP/AR automatisering, reconciliatie en maandafsluiting processen.',
  '875', 'Beschikbaar per 1 mei',
  ARRAY['OpenClaw', 'Finance', 'Audit', 'ERP'],
  'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=128&h=128&fit=crop&crop=faces&auto=format',
  false
);

-- SEED: OPDRACHTEN
INSERT INTO opdrachten (bedrijf, titel, beschrijving, sector, budget, looptijd, tags, featured) VALUES
(
  'Rabobank',
  'Automatisering AP-factuurverwerking',
  'Wij zoeken een OpenClaw specialist voor de automatisering van onze accounts payable verwerking. Het gaat om 2.000+ facturen per maand uit meerdere bronnen. Integratie met SAP vereist.',
  'Finance', '€ 35.000 – 55.000', '3 – 6 maanden',
  ARRAY['OpenClaw', 'Finance', 'SAP'], true
),
(
  'Gemeente Utrecht',
  'Digitalisering vergunningsaanvragen',
  'Gemeente Utrecht zoekt een Nemoclaw Architect voor de automatisering van het vergunningsproces. Van aanvraag tot goedkeuring volledig digitaal. AVG-compliance is vereist.',
  'Overheid', '€ 60.000 – 90.000', '6 – 12 maanden',
  ARRAY['Nemoclaw', 'Overheid', 'Compliance'], true
),
(
  'Coolblue',
  'E-mail triage & routing klantenservice',
  'We verwerken dagelijks 5.000+ klantmails. We zoeken iemand die AI-gedreven categorisatie en routing implementeert in onze klantenservice afdeling.',
  'Klantenservice', '€ 20.000 – 35.000', '1 – 3 maanden',
  ARRAY['OpenClaw', 'Klantenservice'], false
),
(
  'DHL Supply Chain',
  'Order management automation Benelux',
  'Automatiseren van orderverwerking, statusupdates en uitzonderingsmanagement voor onze Benelux operaties. Integratie met SAP en eigen WMS vereist.',
  'Logistiek', '€ 45.000 – 75.000', '3 – 6 maanden',
  ARRAY['Nemoclaw', 'Logistiek', 'SAP'], false
),
(
  'Philips',
  'HR onboarding workflow automatisering',
  'We onboarden maandelijks 50+ nieuwe medewerkers wereldwijd. Zoeken specialist om het volledige onboarding proces te automatiseren inclusief account provisioning.',
  'HR', '€ 25.000 – 40.000', '3 – 6 maanden',
  ARRAY['OpenClaw', 'HR'], false
),
(
  'Deloitte NL',
  'Compliance document verificatie',
  'Audit-ondersteuning via automatische verificatie van contracten, certificaten en compliance documenten. AVG-proof implementatie en audit trail vereist.',
  'Compliance', '€ 30.000 – 50.000', '3 – 6 maanden',
  ARRAY['Nemoclaw', 'Compliance', 'AVG'], false
);
