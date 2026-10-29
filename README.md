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
| `nyb_hub.lua` | **NYB HUB v3.1-fix** — build yang udah dibenerin, ini yang dipakai |
| `nyb_hub_v31_broken.lua` | Rebrand v3.1 **sebelum fix** — buat pembanding A/B |
| `nova_vd_v1.lua` | NOVA VD v3.1 — asli, branding NOVA utuh |
| `nyb_hub_debug.lua` | Build diagnostik: lapor error yang biasanya ditelan `pcall` |
| `loader.lua` | One-liner loadstring untuk `nyb_hub.lua` |

Raw URL:

```lua
-- build fix (dipakai loader /Delta/Scripts/nyb)
loadstring(game:HttpGet("https://raw.githubusercontent.com/xnotyours/nyb-hub/main/nyb_hub.lua"))()

-- pembanding: versi sebelum fix
loadstring(game:HttpGet("https://raw.githubusercontent.com/xnotyours/nyb-hub/main/nyb_hub_v31_broken.lua"))()
```

## Yang dibenerin di v3.1-fix

Tiga bug di lapisan port WindUI (bukan di fiturnya — kode ESP/aim/loop byte-identik
sama v2.6 vanilla yang jalan):

1. **Section bersarang.** `U.section` pakai `parentOf(page)` yang balikin `page.__cur`,
   jadi section ke-2 dibuat **di dalam** section ke-1, ke-3 di dalam ke-2, dst — sampai
   10 level di tab Auto. Kontrak di `AGENTS.md` bilang harusnya sibling di bawah Tab.
   Sekarang host-nya `page.__tab`.

2. **Section gak pernah kebuka.** Di `el_Section.lua`, `Expandable` baru jadi `true`
   saat **element pertama** masuk, dan `Open()`/`Close()` dua-duanya di-guard
   `if Section.Expandable`. Jadi `Open()` yang dipanggil `task.defer` (karena
   `Opened = true`) itu **no-op**. Section kekunci di tinggi header, dan
   `Main.Outline` punya `ClipsDescendants = true` — toggle/slider di dalamnya
   ke-clip: gak kelihatan, gak bisa diklik. Sekarang `Expandable` dipaksa `true`
   lalu `sec:Open(true)` dipanggil, dan diulang `task.defer` setelah elemennya masuk.

3. **Gagal diam-diam.** `NYB.pickParent()` ngecek tiap method (`Toggle`/`Slider`/
   `Button`/`Paragraph`/`Colorpicker`/`Section`) ada di parent-nya; kalau nggak,
   `warn()` nama method + tipe parent, lalu fallback ke Tab. Build gak mati separuh
   tanpa jejak lagi. Ringkasan ke clipboard di akhir.



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
