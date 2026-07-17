-- Phase 7 Nachtrag: 47 zusätzliche Wein-produzierende Länder als reine Land-Stubs
-- (nur Land, ohne Regionen/Appellationen — genaue Geografie folgt später).
-- Upsert ALLER Länder mit sort_order aus dem neuen Seed (Prod == Seed). Idempotent.

begin;
insert into public.countries (name, code, continent, sort_order)
values ('Albania', 'AL', 'Europe', 0)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Algeria', 'DZ', 'Africa', 1)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Argentina', 'AR', 'Americas', 2)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Armenia', 'AM', 'Asia', 3)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Australia', 'AU', 'Oceania', 4)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Austria', 'AT', 'Europe', 5)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Azerbaijan', 'AZ', 'Asia', 6)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Belarus', 'BY', 'Europe', 7)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Belgium', 'BE', 'Europe', 8)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Bolivia', 'BO', 'Americas', 9)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Bosnia and Herzegovina', 'BA', 'Europe', 10)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Brazil', 'BR', 'Americas', 11)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Bulgaria', 'BG', 'Europe', 12)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Canada', 'CA', 'Americas', 13)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Cape Verde', 'CV', 'Africa', 14)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Chile', 'CL', 'Americas', 15)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('China', 'CN', 'Asia', 16)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Colombia', 'CO', 'Americas', 17)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Croatia', 'HR', 'Europe', 18)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Cuba', 'CU', 'Americas', 19)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Cyprus', 'CY', 'Asia', 20)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Czech Republic', 'CZ', 'Europe', 21)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Denmark', 'DK', 'Europe', 22)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Dominican Republic', 'DO', 'Americas', 23)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Ecuador', 'EC', 'Americas', 24)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Egypt', 'EG', 'Africa', 25)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('England & Wales', 'GB', 'Europe', 26)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Estonia', 'EE', 'Europe', 27)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Ethiopia', 'ET', 'Africa', 28)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Finland', 'FI', 'Europe', 29)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('France', 'FR', 'Europe', 30)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('French Polynesia', 'PF', 'Oceania', 31)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Georgia', 'GE', 'Europe', 32)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Germany', 'DE', 'Europe', 33)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Greece', 'GR', 'Europe', 34)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Hungary', 'HU', 'Europe', 35)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('India', 'IN', 'Asia', 36)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Indonesia', 'ID', 'Asia', 37)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Iran', 'IR', 'Asia', 38)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Iraq', 'IQ', 'Asia', 39)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Ireland', 'IE', 'Europe', 40)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Israel', 'IL', 'Asia', 41)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Italy', 'IT', 'Europe', 42)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Japan', 'JP', 'Asia', 43)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Jordan', 'JO', 'Asia', 44)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Kazakhstan', 'KZ', 'Asia', 45)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Kenya', 'KE', 'Africa', 46)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Kosovo', 'XK', 'Europe', 47)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Kyrgyzstan', 'KG', 'Asia', 48)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Latvia', 'LV', 'Europe', 49)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Lebanon', 'LB', 'Asia', 50)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Liechtenstein', 'LI', 'Europe', 51)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Lithuania', 'LT', 'Europe', 52)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Luxembourg', 'LU', 'Europe', 53)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Madagascar', 'MG', 'Africa', 54)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Malta', 'MT', 'Europe', 55)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Mexico', 'MX', 'Americas', 56)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Moldova', 'MD', 'Europe', 57)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Montenegro', 'ME', 'Europe', 58)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Morocco', 'MA', 'Africa', 59)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Myanmar', 'MM', 'Asia', 60)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Namibia', 'NA', 'Africa', 61)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Netherlands', 'NL', 'Europe', 62)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('New Zealand', 'NZ', 'Oceania', 63)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('North Macedonia', 'MK', 'Europe', 64)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Norway', 'NO', 'Europe', 65)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Palestine', 'PS', 'Asia', 66)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Paraguay', 'PY', 'Americas', 67)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Peru', 'PE', 'Americas', 68)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Poland', 'PL', 'Europe', 69)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Portugal', 'PT', 'Europe', 70)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Reunion', 'RE', 'Africa', 71)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Romania', 'RO', 'Europe', 72)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Russia', 'RU', 'Europe', 73)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Serbia', 'RS', 'Europe', 74)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Slovakia', 'SK', 'Europe', 75)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Slovenia', 'SI', 'Europe', 76)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('South Africa', 'ZA', 'Africa', 77)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('South Korea', 'KR', 'Asia', 78)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Spain', 'ES', 'Europe', 79)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Sri Lanka', 'LK', 'Asia', 80)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Sweden', 'SE', 'Europe', 81)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Switzerland', 'CH', 'Europe', 82)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Syria', 'SY', 'Asia', 83)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Taiwan', 'TW', 'Asia', 84)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Tajikistan', 'TJ', 'Asia', 85)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Tanzania', 'TZ', 'Africa', 86)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Thailand', 'TH', 'Asia', 87)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Tunisia', 'TN', 'Africa', 88)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Turkey', 'TR', 'Asia', 89)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Turkmenistan', 'TM', 'Asia', 90)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Ukraine', 'UA', 'Europe', 91)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('United States', 'US', 'Americas', 92)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Uruguay', 'UY', 'Americas', 93)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Uzbekistan', 'UZ', 'Asia', 94)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Venezuela', 'VE', 'Americas', 95)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Vietnam', 'VN', 'Asia', 96)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.countries (name, code, continent, sort_order)
values ('Zimbabwe', 'ZW', 'Africa', 97)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

commit;
