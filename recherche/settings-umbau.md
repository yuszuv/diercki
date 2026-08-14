# Umbau: Konfiguration über dry-system settings

Vorbereitet am 14.08.2026 auf `feat/ruby-web-app`, **noch nicht umgesetzt**. Gedacht
als eigener PR nach dem Merge des Webanwendungs-PRs. Diese Datei ist die Übergabe:
Befund, Bauformen, Hindernis, und was nicht kaputtgehen darf.

Kein brennender Fehler — funktionierender, getesteter Code wird abgelöst, weil die
handgeschriebene Fassung drei Dinge schlechter macht als die vorhandene Bibliothek.

## Was heute da ist

Drei Umgebungswerte, alle Pflicht, keiner mit Vorgabe:

| Variable | Form |
|---|---|
| `ATLAS_KONTO` | Kontoname |
| `ATLAS_PASSWORT_HASH` | bcrypt-Hash, **base64-kodiert** |
| `ATLAS_SESSION_SECRET` | Hex, ≥ 64 Zeichen |

Sie werden an zwei Stellen von Hand behandelt:

- **`web/auth.rb`, rund 32 Zeilen** — `Auth.env!` (Pflicht, sonst `abort`),
  `Auth.password_hash` (base64 dekodieren, gegen die bcrypt-Form prüfen),
  `Auth.abort_hash` (die Fehlermeldung).
- **`config.ru`, 27 Zeilen** — liest `.env`, weil docker compose das von selbst tut
  und `bundle exec puma` nicht. Wörtlich, ohne `${…}`-Auflösung; gesetzte Variablen
  gewinnen.

## Was der Settings-Provider besser macht

Gelesen in `dry-system-1.2.5/lib/dry/system/provider_sources/settings/`, nicht aus
der Doku übernommen — die Doku schweigt zu den zwei interessanten Punkten.

1. **Alle Fehler auf einmal.** `Config.load` sammelt und wirft einmal:

   ```ruby
   raise InvalidSettingsError, errors unless errors.empty?
   # "Could not load settings. The following settings were invalid:
   #  atlas_konto: … / atlas_session_secret: …"
   ```

   `Auth.env!` bricht beim ersten fehlenden Wert ab. Man repariert sie einzeln.

2. **Die Prüfung wird deklarativ**, und `dry-types` braucht es dafür **nicht** —
   ein Lambda genügt als `constructor:`. Nachgeprüft:

   ```ruby
   setting :atlas_passwort_hash, constructor: ->(v) {
     h = begin; v.to_s.unpack1('m0'); rescue ArgumentError; raise ArgumentError, 'kein gültiges Base64'; end
     raise ArgumentError, 'dekodiert kein bcrypt-Hash' unless h.to_s.match?(BCRYPT)
     h
   }
   # "Müll" → kein gültiges Base64 · gültiger Wert → dekodierter Hash
   ```

3. **Eine dokumentierte .env-Kette**, die es sonst nirgends gibt
   (`providers/settings/loader.rb`):

   ```ruby
   [".env.#{env}.local", ".env.local" (außer test), ".env.#{env}", ".env"]
   ```

   Das ist die Antwort auf die Frage, ob es eine `local`- oder
   `development`-Variante geben sollte: In docker compose **nein** — es liest nur
   `.env`, gemessen. Hier **ja**. Die Kette kommt über `dotenv`; fehlt das Gem, tut
   der Loader nichts (`rescue LoadError`).

`dry-configurable` liegt bereits im Lock (1.4.0, transitiv über dry-system).

## Das Hindernis, und es ist das eigentliche Stück Arbeit

`web/auth.rb` liest **beim Laden der Klasse**:

```ruby
class AuthApp < Roda
  DB = Auth.database                                   # ← ENV zur Ladezeit
  plugin :sessions, secret: Auth.env!('ATLAS_SESSION_SECRET')   # ← ebenso
```

Settings liegen im Container und stehen erst nach `Container.finalize!` bereit —
das passiert in `config.ru` **nach** `require_relative 'web/auth'`. Ein Umstieg
heißt also: die Startreihenfolge von `AuthApp` umbauen, damit Geheimnis und
Datenbank erst beim ersten Zugriff geholt werden. Roda-Plugins werden zur Ladezeit
konfiguriert; `plugin :sessions` nimmt aber auch ein Callable für `secret`, das ist
vermutlich der Hebel — **ungeprüft, bitte selbst nachsehen.**

Das ist der sicherheitsrelevante Pfad. Nicht nebenbei umbauen.

## Bauformen, mit Preis

| | Gems | Was bleibt handgeschrieben |
|---|---|---|
| **A** nur `dry-configurable` | 0 | ENV-Lesen und `.env` bleiben bei mir; nur die Deklaration wandert |
| **B** Settings-Provider ohne `dotenv` | 0 | mein `config.ru`-Loader bleibt daneben stehen — zwei Stellen lesen Umgebung |
| **C** Settings-Provider **mit** `dotenv` | 1 | nichts; der Loader fliegt raus, die `.env`-Kette kommt mit |

**Empfehlung: C.** B lässt zwei Mechanismen nebeneinander stehen, und genau das
ist die Sorte Doppelung, die dieses Projekt an anderer Stelle schon zweimal
eingesammelt hat (die neun CDN-Adressen, die zwei Wächter-Listen).

## Was nicht kaputtgehen darf

Alles gemessen und in Tests eingezäunt — wer den Umbau macht, prüft das gegen:

- **Kein Wert bekommt eine Vorgabe.** Ein Fallback-Geheimnis ist schlimmer als
  keines: nichts sieht kaputt aus, solange es drin ist.
- **`ATLAS_PASSWORT_HASH` bleibt base64.** Nicht Geschmack: docker compose löst
  `${…}` in jedem Wert auf, den es liest — auch in der `.env`, und weder
  Anführungszeichen noch `$$` noch `env_file:` halten das auf. Gemessen kommt
  `$2a$12$KDvI…/qxuoa` als `a2/qxuoa` an; die Anmeldung lehnte dann das richtige
  Passwort ab, ohne dass irgendwo etwas dazu stünde. Wer roh übergibt, muss weiter
  einen lauten Abbruch bekommen.
- **`Sources::Restricted` schließt zu**, wenn `web/geschuetzt.csv` unlesbar ist.
  Das hat nichts mit Settings zu tun, steht aber im selben Pfad.
- **Die 28 Tests bleiben grün**, besonders die drei Sicherheitstests
  (`test_no_spelling_of_a_guarded_path_gets_through`,
  `test_guarded_paths_ask_for_a_login`, `test_a_guarded_static_file_is_guarded_too`).
- **Die CI startet die Anwendung so, wie die README es sagt** — über eine `.env`,
  ohne exportierte Variablen (`.github/workflows/ci.yml`, Schritt „Start it the way
  the README says"). Wenn die `.env`-Kette sich ändert, ändert sich dieser Schritt
  mit. Genau dieser Schritt existiert, weil zweimal eine dokumentierte Zeile nicht
  funktionierte und es niemandem auffiel.

## Nachziehen, wenn es steht

- `README.md` — Abschnitt „Getting it running", falls die `.env`-Kette dazukommt
- `.env.example` — der Kopf erklärt heute, dass `config.ru` die Datei liest
- `WEB-APPLICATION.md` — Abschnitt „The gate", die Tabelle der drei Variablen
- `recherche/entscheidungen-webanwendung.md` — dort steht, warum `dry-system`
  bleibt und `dry-transformer` ging; dieser Umbau gehört als Absatz daneben
- `recherche/bmeise-nachzuziehen.md` — Punkt 3 nennt die drei Variablen für
  `dockerapp_env`. Ändert sich an Namen oder Form etwas, ändert es sich dort mit

## Verifikation

```sh
bundle exec ruby -Itest test/web_test.rb        # 28 runs

# der dokumentierte Weg, ohne exportierte Variablen
cp .env.example .env && $EDITOR .env
bundle exec puma                                # → http://localhost:9292/

# jeder Wert einzeln fehlend: laut scheitern, mit brauchbarer Meldung
env -u ATLAS_KONTO bundle exec puma
# roher statt base64-kodierter Hash: ebenso
docker compose --profile local up dev
```
