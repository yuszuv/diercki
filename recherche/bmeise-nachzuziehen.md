# Was in bmeise nachzuziehen ist

Stand 14.08.2026. Diese Datei beschreibt Änderungen an einem **anderen Repo**
(`~/137/bmeise`) und ändert dort nichts — sie hält fest, was fällig ist und in
welcher Reihenfolge. Alles betrifft `inventory/host_vars/paketzentrum.yml`,
Dienst `diercki`.

## Erledigt — und was daraus folgt

**Die Punkte 1 bis 4 sind in bmeise umgesetzt**, Commit `d632fd4` („diercki zieht
das Image aus der CI und meldet sich selbst an"), committet und gepusht, Baum
sauber. Nachgeprüft am 14.08.2026: beide Geheimnisse liegen `!vault`-verschlüsselt
vor, `ATLAS_KONTO: admin` steht im Klartext daneben, `build:` ist weg (die Rolle
nimmt damit von selbst `pull: always`), und der `basicauth`-Block für diercki
existiert nicht mehr.

**Angewendet ist davon noch nichts.** Genau das dreht die Reihenfolge unten um.

## Reihenfolge — jetzt andersherum

Sie war: erst deployen, dann den Caddy entschärfen. Da der Block im Repo schon weg
ist, lautet die Gefahr nun umgekehrt: **zu früh deployen**. Gemessen am
14.08.2026 — `origin/main` trägt weder `web/auth.rb` noch `web/geschuetzt.csv`,
und auf ghcr existiert noch gar kein Paket (`Package not found`).

Ein `make webhost LIMIT=paketzentrum` in diesem Zustand schreibt einen Caddyfile
ohne `basicauth` und scheitert danach am Pull. Der alte Container läuft weiter —
alter Inhalt, kein Schutz. Also:

1. PR mergen
2. den CI-Job „Image" abwarten, bis `ghcr.io/yuszuv/diercki:latest` existiert
3. **erst dann** `make webhost LIMIT=paketzentrum`
4. die zwei `curl`-Nachkontrollen aus `paketzentrum.yml` (302 auf das Foto,
   200 auf ein offenes Blatt)

## 1 · Der Kommentar beschreibt einen Zustand, den es nicht mehr gibt

Aktuell steht dort:

> „Statisch, aber in einem Container: **nginx** schreibt die CDN-Verweise der
> Blätter um und liefert das **JSON-Verzeichnislisting**, an dem die
> Drift-Erkennung der Seite hängt. Gebaut wird auf dem Host aus dem gepinnten
> Commit — **das Image ist Inhalt, kein kompiliertes Artefakt**, eine
> Registry-Rundreise pro Kartenänderung wäre die falsche Granularität."

Vier Aussagen, drei überholt:

| steht dort | ist jetzt |
|---|---|
| nginx schreibt um | eine Rack-Middleware; nginx ist raus |
| JSON-Verzeichnislisting trägt die Drift-Erkennung | `/_index/` gibt es nicht mehr, der Server liest das Verzeichnis direkt |
| „statisch" | eine Roda-Anwendung mit Anmeldung |
| Image ist Inhalt, nicht kompiliert | kompiliert `nio4r`, zieht plattformspezifische `sqlite3`-Binaries |

Vorschlag:

    # Sternprodukt-Atlas. Eine Roda-Anwendung, die den Baum ausliefert und
    # Startseite, Schaukasten, Blattschau, Namensregister und Werkstatt daraus
    # baut; eine Rack-Middleware schreibt die CDN-Verweise der Blätter auf lokal
    # eingebackene Bibliotheken um. Das Image wird in der CI des Repos gebaut und
    # nach ghcr.io geschoben — seit dem Ruby-Teil ist es kein reiner Inhalt mehr,
    # sondern kompiliert (nio4r, sqlite3), und ein Bauversagen gehört nicht auf
    # den Server.

## 2 · Nicht mehr bauen, sondern ziehen

`build: true` entfällt. Die Rolle nimmt dann von selbst `pull: always` und
`build: policy` — an `roles/dockerapp` ändert sich nichts, und ihr eigener
Vertrag verlangt es ohnehin: *„Prefer pre-built images"*. `diercki` war der
einzige `build: true`-Eintrag über alle Hosts.

Das Compose-Image ist `${ATLAS_IMAGE:-ghcr.io/yuszuv/diercki:latest}`. Ohne
weitere Angabe folgt der Dienst `latest`, also `main`. Wer einen benannten Stand
will, setzt in `dockerapp_env`:

    ATLAS_IMAGE: ghcr.io/yuszuv/diercki:sha-<commit>

Ist das Paket privat, braucht es `dockerapp_registry` auf `ghcr.io` plus
`dockerapp_registry_username`/`password` (ein PAT mit `read:packages`). Bei einem
öffentlichen Paket nicht.

## 3 · Drei Umgebungswerte über `dockerapp_env`

    dockerapp_env:
      ATLAS_KONTO: jan
      ATLAS_PASSWORT_HASH: "<base64>"     # vaulten
      ATLAS_SESSION_SECRET: "<hex 64>"    # vaulten

Ohne sie startet die Anwendung nicht — Absicht, ein Vorgabe-Geheimnis wäre
schlimmer als keines.

**Der Hash muss base64 sein.** Nicht Geschmack, sondern gemessen: `dockerapp_env`
schreibt eine `.env`, und docker compose löst `${…}` in jedem Wert auf, den es
liest — auch dort. Ein bcrypt-Hash besteht aus `$`-Feldern:

    roh:          $2a$12$KDvI6RuYisJKz0YWxL3ntewqW5gpbtOdlRMa2Typjy2VoI2/qxuoa
    im Container: a2/qxuoa

Weder einfache noch doppelte Anführungszeichen noch `$$`-Verdopplung helfen,
`env_file:` verhält sich wie `environment:`. Die Anwendung würde starten und das
richtige Passwort ablehnen, ohne dass irgendwo etwas dazu steht.

Erzeugen:

    ruby -rbcrypt -e 'print [BCrypt::Password.create("…")].pack("m0")'
    ruby -rsecurerandom -e 'print SecureRandom.hex(64)'

`web/auth.rb` verweigert den Start, wenn dekodiert kein bcrypt-Hash herauskommt.

## 4 · Erst nach bewiesenem Deploy: `basicauth` entfernen

Der ganze Block kann weg. Die vier Pfade stehen unverändert in
`web/geschuetzt.csv`, und der Wächter der Anwendung sitzt vor der
Statik-Auslieferung — er greift damit auch für die zwei statischen Dateien
(`Gruss-an-Stefan-Waldmann.dc.html`, `uploads/neumaier-frueher.png`), die der
Caddy heute schützt.

Prüfen vor dem Entfernen, gegen die laufende Seite:

    curl -sI https://diercki.sternprodukt.de/uploads/neumaier-frueher.png   # 302 → /anmelden
    curl -sI https://diercki.sternprodukt.de/Rumaenien-Physisch.html        # 200

Solange der Caddy-Block noch steht, fragt er zusätzlich — doppelte Abfrage, aber
nichts ist offen. Andersherum wäre es ein Fenster.

## 5 · `upstream: diercki:80` bleibt

Der Container lauscht auf `ATLAS_PORT`, Vorgabe 80. Lokal ist alles 9292, aber
innen bleibt es 80, damit hier nichts nachzuziehen ist. Wer das ändern will,
ändert beides in einem Zug.
