# NYB HUB — Violence District Toolkit

Single-file Roblox script hub buat **[BUTCHER] Violence District** (PlaceId `93978595733734`).

| | |
|---|---|
| Versi | v3.1 |
| File | `nyb_hub.lua` — 5.041 baris, ~168 KB |
| Engine UI | [WindUI](https://github.com/Footagesus/WindUI) — di-fetch via `HttpGet` saat inject |
| Platform | Mobile (Delta / Hydrogen) + PC (Xeno / Wave / Swift) |

## Load

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/xnotyours/nyb-hub/main/nyb_hub.lua"))()
```

Atau pakai [`loader.lua`](loader.lua) yang isinya persis satu baris itu.

## Daftar file

| File | Isi |
|---|---|
| `nyb_hub.lua` | NYB HUB v3.1 — versi rebrand (branding NYB) |
| `nova_vd_v1.lua` | NOVA VD v3.1 — **asli, branding NOVA utuh**, buat pembanding A/B |
| `nyb_hub_debug.lua` | Build diagnostik: lapor error yang biasanya ditelan `pcall` + probe otomatis |
| `loader.lua` | One-liner loadstring untuk `nyb_hub.lua` |

Raw URL pembanding:

```lua
-- NOVA VD v3.1 (asli, WindUI)
loadstring(game:HttpGet("https://raw.githubusercontent.com/xnotyours/nyb-hub/main/nova_vd_v1.lua"))()

-- build diagnostik (probe otomatis jalan 4 detik setelah load)
loadstring(game:HttpGet("https://raw.githubusercontent.com/xnotyours/nyb-hub/main/nyb_hub_debug.lua"))()
```

> `nyb_hub.lua` dan `nova_vd_v1.lua` **ekuivalen secara fungsional** — bedanya cuma token
> brand (`NOV`→`NYB`, `NOVA_*`→`NYB_*`, folder config, string tampil). Kalau dua-duanya
> berperilaku sama in-game, berarti masalahnya di port WindUI, bukan di rebrand.


> **Butuh internet saat inject.** WindUI gak di-embed ke dalam file — section UI-nya
> ngambil source dari repo resmi WindUI lewat `HttpGet`. Kalau koneksi mati,
> script `warn()` dan batal jalan.

## Struktur

**9 tab, 39 section.**

- **Main** — Preset, Session
- **ESP** — Pemain, Objek Map, Lain, Warna ESP
- **Aim** — Aimbot, Silent Aim, Target & Crosshair
- **Auto** — Generator, Survivor QoL, Killer, Survivor Utility, Killer Utility,
  Fake Perks, Killer Ability, Status Generator, Item, Gen Boost
- **Combat** — Parry, Guard
- **Movement** — Kecepatan, Terbang & Noclip, Lain
- **Visual** — Layar, Performa, Kamera
- **Teleport** — Objek Map, Pemain, Pallet / Window
- **Misc** — Diagnostik, Probe (eksperimen), Info Overlay, Gate, Cosmetic / QoL,
  Config, Remote Terdeteksi, Info, Info Tambahan

## Config

Disimpan sebagai `NYB_HUB/config.json` di workspace executor
(`makefolder` / `isfolder` / `writefile`). Ada tombol Save / Load / Reset di tab
**Misc → Config**.

## Diagnostik

Tab **Misc → Diagnostik** punya tombol **Self Test** + **Scan Ulang Map** +
**Dump Remote**. Self Test ngecek PlaceId, karakter/HRP, remote yang ke-RE,
hasil scan map, leaderstats, dan fitur mana yang ON — hasilnya di-`print()`,
di-`warn()`, dan disalin ke clipboard.

## Catatan

- `Remotes.Mechanics.Chat.*` (TempBan / PermaBan / Unban) **sengaja gak dipakai** —
  itu tool moderasi server, bukan fitur cheat.
- Guard global pakai flag `NYB_HUB_RUNNING` di `getgenv()`. Tekan **Unload**
  dulu sebelum reload, kalau nggak script nolak jalan.
- Semua fitur yang efeknya di luar main loop (kamera, GFX, GUI standalone)
  di-reapply eksplisit lewat `NYB.reapplySideEffects` pas load preset/config,
  biar toggle gak kebaca OFF padahal efeknya masih jalan.
