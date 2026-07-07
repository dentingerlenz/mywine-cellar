-- Allow sub_region_id to be NULL for country- and region-level appellations
ALTER TABLE wine_appellations ALTER COLUMN sub_region_id DROP NOT NULL;

DO $$
DECLARE
  v_user_id uuid;
  v_country_id uuid;
  v_region_id uuid;
  rec record;
BEGIN
  SELECT user_id INTO v_user_id FROM wine_countries LIMIT 1;
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'No user_id available in wine_countries';
  END IF;

  -- COUNTRY-LEVEL
  FOR rec IN
    SELECT * FROM (VALUES
      ('France', 'Vin de France', 'AOC'),
      ('Italy', 'Vino d''Italia', 'IGT'),
      ('Germany', 'Deutscher Wein', 'Tafelwein'),
      ('Spain', 'Vino de España', 'VdlT'),
      ('Portugal', 'Vinho', 'Vinho'),
      ('Austria', 'Wein', 'Tafelwein'),
      ('Switzerland', 'Vin de Table / Tafelwein', 'Tafelwein'),
      ('Greece', 'Epitrapezios Oinos', 'Table'),
      ('Hungary', 'Bortermelo Orszag', 'Table'),
      ('Bulgaria', 'Trpezno Vino', 'Table'),
      ('Romania', 'Vin fara Indicatie Geografica', 'Table'),
      ('Croatia', 'Stolno Vino', 'Table'),
      ('Slovenia', 'Namizno Vino', 'Table'),
      ('Czech Republic', 'Stolni Vino', 'Table'),
      ('Slovakia', 'Stolove Vino', 'Table'),
      ('Moldova', 'Vin de masa', 'Table'),
      ('Georgia', 'Magrada Ghvino', 'Table'),
      ('England & Wales', 'English Wine / Welsh Wine', 'National'),
      ('United States', 'American Wine', 'National'),
      ('Argentina', 'Vino de Argentina', 'National'),
      ('Chile', 'Vino de Chile', 'National'),
      ('Australia', 'Australian Wine', 'National'),
      ('New Zealand', 'New Zealand Wine', 'National'),
      ('South Africa', 'Wine of Origin', 'WO'),
      ('China', 'Putao Jiu', 'National'),
      ('Japan', 'Japanese Wine', 'National')
    ) AS t(country_name, app_name, app_type)
  LOOP
    SELECT id INTO v_country_id FROM wine_countries
      WHERE lower(trim(name)) = lower(trim(rec.country_name)) LIMIT 1;
    IF v_country_id IS NULL THEN
      RAISE NOTICE 'Country not found: %', rec.country_name;
      CONTINUE;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM wine_appellations
      WHERE name = rec.app_name AND level = 'country' AND country_id = v_country_id
    ) THEN
      INSERT INTO wine_appellations
        (name, level, country_id, region_id, sub_region_id, appellation_type, user_id)
      VALUES
        (rec.app_name, 'country', v_country_id, NULL, NULL, rec.app_type, v_user_id);
    END IF;
  END LOOP;

  -- REGION-LEVEL
  FOR rec IN
    SELECT * FROM (VALUES
      ('France', 'Bordeaux', 'AOC Bordeaux', 'AOC'),
      ('France', 'Bourgogne', 'AOC Bourgogne', 'AOC'),
      ('France', 'Champagne', 'AOC Champagne', 'AOC'),
      ('France', 'Alsace', 'AOC Alsace', 'AOC'),
      ('France', 'Vallee du Rhone', 'IGP Mediterranee', 'IGP'),
      ('France', 'Vallee de la Loire', 'IGP Val de Loire', 'IGP'),
      ('France', 'Provence', 'IGP Mediterranee', 'IGP'),
      ('France', 'Languedoc-Roussillon', 'IGP Pays d''Oc', 'IGP'),
      ('France', 'Sud-Ouest', 'IGP Comtes Tolosan', 'IGP'),
      ('France', 'Beaujolais', 'IGP Vin de Pays d''Oc', 'IGP'),
      ('France', 'Bordeaux', 'IGP Atlantique', 'IGP'),
      ('France', 'Vallee du Rhone', 'AOC Cotes du Rhone', 'AOC'),
      ('Italy', 'Piemonte', 'IGT Langhe Fantasia', 'IGT'),
      ('Italy', 'Toscana', 'IGT Toscana', 'IGT'),
      ('Italy', 'Veneto', 'IGT Delle Venezie', 'IGT'),
      ('Italy', 'Sicilia', 'IGT Terre Siciliane', 'IGT'),
      ('Italy', 'Puglia', 'IGT Puglia', 'IGT'),
      ('Italy', 'Campania', 'IGT Campania', 'IGT'),
      ('Italy', 'Lombardia', 'IGT Lombardia', 'IGT'),
      ('Italy', 'Sardegna', 'IGT Isola dei Nuraghi', 'IGT'),
      ('Italy', 'Lazio', 'IGT Lazio', 'IGT'),
      ('Italy', 'Abruzzo', 'IGT Terre di Chieti', 'IGT'),
      ('Italy', 'Calabria', 'IGT Calabria', 'IGT'),
      ('Italy', 'Basilicata', 'IGT Basilicata', 'IGT'),
      ('Italy', 'Marche', 'IGT Marche', 'IGT'),
      ('Italy', 'Umbria', 'IGT Umbria', 'IGT'),
      ('Italy', 'Emilia-Romagna', 'IGT Emilia', 'IGT'),
      ('Italy', 'Friuli-Venezia Giulia', 'IGT Delle Venezie', 'IGT'),
      ('Italy', 'Trentino-Alto Adige', 'IGT Delle Venezie', 'IGT'),
      ('Germany', 'Mosel', 'Landwein der Mosel', 'Landwein'),
      ('Germany', 'Rheingau', 'Rheingauer Landwein', 'Landwein'),
      ('Germany', 'Rheinhessen', 'Rheinischer Landwein', 'Landwein'),
      ('Germany', 'Pfalz', 'Pfälzer Landwein', 'Landwein'),
      ('Germany', 'Baden', 'Badischer Landwein', 'Landwein'),
      ('Germany', 'Franken', 'Fränkischer Landwein', 'Landwein'),
      ('Germany', 'Württemberg', 'Schwäbischer Landwein', 'Landwein'),
      ('Germany', 'Nahe', 'Nahegauer Landwein', 'Landwein'),
      ('Germany', 'Ahr', 'Ahrer Landwein', 'Landwein'),
      ('Germany', 'Sachsen', 'Sächsischer Landwein', 'Landwein'),
      ('Germany', 'Saale-Unstrut', 'Mitteldeutscher Landwein', 'Landwein'),
      ('Spain', 'Rioja', 'Vino de la Tierra Castilla', 'VdlT'),
      ('Spain', 'Cataluna', 'Vino de la Tierra Cataluna', 'VdlT'),
      ('Spain', 'Castilla y Leon', 'Vino de la Tierra Castilla y Leon', 'VdlT'),
      ('Spain', 'Castilla-La Mancha', 'Vino de la Tierra Castilla-La Mancha', 'VdlT'),
      ('Spain', 'Galicia', 'Vino de la Tierra Barbanza e Iria', 'VdlT'),
      ('Spain', 'Valencia', 'Vino de la Tierra Valencia', 'VdlT'),
      ('Spain', 'Andalucia', 'Vino de la Tierra Cadiz', 'VdlT'),
      ('Spain', 'Aragon', 'Vino de la Tierra Bajo Aragon', 'VdlT'),
      ('Spain', 'Navarra', 'Vino de la Tierra Navarra', 'VdlT'),
      ('Spain', 'Extremadura', 'Vino de la Tierra Extremadura', 'VdlT'),
      ('Portugal', 'Douro', 'Vinho Regional Transmontano', 'Vinho Regional'),
      ('Portugal', 'Vinho Verde', 'Vinho Regional Minho', 'Vinho Regional'),
      ('Portugal', 'Alentejo', 'Vinho Regional Alentejano', 'Vinho Regional'),
      ('Portugal', 'Lisboa', 'Vinho Regional Lisboa', 'Vinho Regional'),
      ('Portugal', 'Tejo', 'Vinho Regional Tejo', 'Vinho Regional'),
      ('Portugal', 'Dao', 'Vinho Regional Beiras', 'Vinho Regional'),
      ('Portugal', 'Bairrada', 'Vinho Regional Beiras', 'Vinho Regional'),
      ('Portugal', 'Peninsula de Setubal', 'Vinho Regional Peninsula de Setubal', 'Vinho Regional'),
      ('Portugal', 'Algarve', 'Vinho Regional Algarve', 'Vinho Regional'),
      ('Austria', 'Niederösterreich', 'Niederösterreichischer Landwein', 'Landwein'),
      ('Austria', 'Burgenland', 'Burgenländischer Landwein', 'Landwein'),
      ('Austria', 'Steiermark', 'Steirischer Landwein', 'Landwein'),
      ('Austria', 'Wien', 'Wiener Landwein', 'Landwein'),
      ('United States', 'California', 'California Wine', 'State designation'),
      ('United States', 'Oregon', 'Oregon Wine', 'State designation'),
      ('United States', 'Washington State', 'Washington Wine', 'State designation'),
      ('United States', 'New York State', 'New York Wine', 'State designation'),
      ('Australia', 'South Australia', 'South Eastern Australia', 'Broad GI'),
      ('Australia', 'Victoria', 'South Eastern Australia', 'Broad GI'),
      ('Australia', 'New South Wales', 'South Eastern Australia', 'Broad GI'),
      ('Australia', 'Western Australia', 'Western Australia', 'Broad GI'),
      ('Australia', 'Tasmania', 'Tasmania', 'Broad GI'),
      ('New Zealand', 'Marlborough', 'Marlborough Wine', 'GI'),
      ('New Zealand', 'Central Otago', 'Central Otago Wine', 'GI'),
      ('New Zealand', 'Hawke''s Bay', 'Hawke''s Bay Wine', 'GI'),
      ('Argentina', 'Mendoza', 'Mendoza Wine', 'IG'),
      ('Argentina', 'Patagonia', 'Patagonia Wine', 'IG'),
      ('Chile', 'Valle Central', 'Valle Central Wine', 'DO'),
      ('Chile', 'Aconcagua', 'Aconcagua Wine', 'DO'),
      ('South Africa', 'Western Cape', 'Western Cape', 'WO')
    ) AS t(country_name, region_name, app_name, app_type)
  LOOP
    SELECT id INTO v_country_id FROM wine_countries
      WHERE lower(trim(name)) = lower(trim(rec.country_name)) LIMIT 1;
    IF v_country_id IS NULL THEN
      RAISE NOTICE 'Country not found: %', rec.country_name;
      CONTINUE;
    END IF;

    SELECT id INTO v_region_id FROM wine_regions
      WHERE lower(trim(name)) = lower(trim(rec.region_name))
        AND country_id = v_country_id
      LIMIT 1;
    IF v_region_id IS NULL THEN
      RAISE NOTICE 'Region not found: % / %', rec.country_name, rec.region_name;
      CONTINUE;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM wine_appellations
      WHERE name = rec.app_name AND level = 'region'
        AND country_id = v_country_id AND region_id = v_region_id
    ) THEN
      INSERT INTO wine_appellations
        (name, level, country_id, region_id, sub_region_id, appellation_type, user_id)
      VALUES
        (rec.app_name, 'region', v_country_id, v_region_id, NULL, rec.app_type, v_user_id);
    END IF;
  END LOOP;
END $$;