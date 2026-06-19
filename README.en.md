# Netlify One-Click Kit (Netlify CLI One-Click Kit)

A **beginner-friendly** kit that lets you **install, use, and remove** the Netlify CLI — the tool that
**publishes your website to the internet** — with **a few clicks and no commands to memorize**.
A Korean-first guide panel tells you **"which number to press now."**

> Korean is the default. This English version mirrors it. Detailed guide: [GUIDE.en.md](./GUIDE.en.md). Korean docs: [README.md](./README.md), [사용설명서.md](./사용설명서.md).

---

## 📑 Table of Contents

1. [What is this? (1-minute overview)](#1-what-is-this-1-minute-overview)
2. [5 words to know first](#2-5-words-to-know-first)
3. [Prerequisites & required programs](#3-prerequisites--required-programs)
4. [Quick start (3 minutes)](#4-quick-start-3-minutes)
5. [Download & unblock](#5-download--unblock)
6. [How to install](#6-how-to-install)
7. [Run / use / how it works](#7-run--use--how-it-works)
8. [Full workflow](#8-full-workflow)
9. [How to uninstall](#9-how-to-uninstall)
10. [Problem & error handling](#10-problem--error-handling)
11. [File / doc / data locations](#11-file--doc--data-locations)
12. [Command reference (optional)](#12-command-reference-optional)
13. [License · Copyright · Commercial use](#13-license--copyright--commercial-use)

---

## 1. What is this? (1-minute overview)

- **Netlify** is a service that puts your website on the internet and gives it a **web address (URL)**.
- Normally you must type **English commands** in a black console window — a big wall for first-timers.
- This kit replaces that with a **Korean menu + number selection**. **Nothing to memorize.**

---

## 2. 5 words to know first

| Word | Plain meaning |
|---|---|
| **Node.js** | A supporting program like a car **engine**. The Netlify tool needs it to run. Install **once**. |
| **Black window (console/terminal)** | A window where you give the computer text commands. The kit **opens and closes it for you**. Normal. |
| **Netlify account** | Your **ID** for Netlify. If you don't have one, **sign up free** (no card). |
| **Deploy** | **Publishing** your website to the internet. Two kinds: **Preview** (only you) and **Production** (everyone). |
| **CLI** | "Command-line tool." Since we only press menu items, **no commands to memorize**. |

---

## 3. Prerequisites & required programs

### What you must prepare yourself
- **Windows 10 or 11** (this kit is Windows-only)
- **Internet connection** (needed for install, login, deploy)
- **Node.js v20.12.2 or newer** (LTS) — the kit does **NOT** install Node.js for you. Install it yourself (see section 6).
- **A Netlify account** (free) — needed at the login step. Sign up at https://app.netlify.com if you don't have one.

### What the kit installs for you
- **netlify-cli** — the Netlify tool itself. `INSTALL.bat` (menu [1] Install) installs it automatically.

> In short: **You prepare** = Windows + Internet + Node.js + Netlify account. **The kit handles** = installing netlify-cli.

---

## 4. Quick start (3 minutes)

1. **Double-click** `시작하기.bat` (means "Start Here").
2. Follow the single **`>> What to do now`** line near the bottom of the screen.
3. **[1] Install** → (when done) **[2] Use → [1] Log in** → **[4] Practice deploy with the sample site**.
4. When a temporary URL appears, open it. If you see **"Congratulations!"**, it worked.

> **How to choose:** Up/Down arrows + Enter, or number keys. **Just Enter** runs the green **recommended** item. **ESC** = cancel/back.
> The **"Now selected: …"** line below the menu lets you confirm what you're choosing before pressing.

---

## 5. Download & unblock

Windows sometimes **locks** files downloaded from the internet. Just unblock them.

1. (Easiest) **Before** unzipping, right-click the zip → **Properties → check 'Unblock' at the bottom → OK** → then unzip.
2. If a blue **"Windows protected your PC"** dialog appears → **More info → Run anyway**.

> Once `시작하기.bat` runs once, the rest of the files are **unblocked automatically.** (Usually you only deal with this once.)

---

## 6. How to install

1. `시작하기.bat` → **[1] Install**.
2. **No admin prompt appears.** (Netlify installs only into your user folder `%APPDATA%\npm`, so no admin rights are needed.)
3. A black window runs 6 steps in English. **Do not close it; wait (3–10 min).**
   Text may appear **frozen for a while — that's normal** (downloading). Closing it breaks the install.
4. `ALL DONE!  NETLIFY CLI IS INSTALLED.` means success.

**If it says Node.js is missing** → install **LTS (20+)** from https://nodejs.org, then close the window, re-run `시작하기.bat` → [1].

Step-by-step screens and the error table are in [GUIDE.en.md](./GUIDE.en.md).

---

## 7. Run / use / how it works

Double-clicking `시작하기.bat` automatically checks your computer state (Node / CLI / login) and tells you **what to do now** in one line.

**Start menu (Korean labels)**

| No. | Item | What it does |
|---|---|---|
| 1 | Install | Install the Netlify tool |
| 2 | Use | Log in / practice deploy / deploy my site (Korean submenu) |
| 3 | "Something's wrong?" | **Self-diagnosis** — checks what's wrong and shows fixes in Korean (safe) |
| 4 | Uninstall | Cleanly remove the Netlify tool (keeps your code) |
| 5 | Guide | Open the beginner guide |
| 6 | Netlify dashboard | Open the site-management page in your browser |
| 0 | Exit | Close the panel |

**[2] Use submenu:** 1 Log in · 2 Check login · 3 List my sites · **4 Practice deploy with sample site (recommended)** · 5 Deploy my folder · 6 Full menu (English, 26 items) · 0 Back.

**How it works (in brief):** the Korean panel (`lib\start.ps1`) calls the English engines (`INSTALL/RUN/UNINSTALL.bat`) for you and re-reads your state every time.

---

## 8. Full workflow

```
Double-click 시작하기.bat
        │
        ▼
 [1] Install  ──(if Node missing, install from nodejs.org, then retry)──┐
        │                                                               │
        ▼                                                               │
 [2] Use → [1] Log in (sign up free first if needed) ◄──────────────────┘
        │
        ▼
 [2] Use → [4] Practice deploy with sample site  (complete one success loop)
        │
        ▼
 Prepare my website → [5] Deploy my folder
        │
        ├─ [1] Preview (safe, temporary URL)   ← always first
        └─ [2] Production (type YES)           ← only when sure
```

---

## 9. How to uninstall

1. `시작하기.bat` → **[4] Uninstall**.
2. Use **[1] Preview** to see what will be removed, then type **`YES` (uppercase)** in **[2]**.

**What is kept:** your **website code files**, **Node.js**, and the **live sites** already on Netlify's servers. (Only the Netlify tool, login key, and cache are removed.)

---

## 10. Problem & error handling

> **If you don't know what's wrong**, use `시작하기.bat` → **[3] Something's wrong? (Self-diagnosis)**.
> It checks Node / install / login / internet and gives **fixes in Korean** right away.

| Symptom | Fix |
|---|---|
| `NETLIFY CLI IS NOT INSTALLED` | Run [1] Install first |
| Installed but `netlify ... not found` | Close all windows and reopen `시작하기.bat` in a **new** window |
| `Node.js is NOT on this computer` | Install **LTS** from https://nodejs.org, then [1] again |
| `The install did not finish` | Check internet/antivirus/corporate network → disable antivirus 10 min and retry (steps in the guide) |
| File won't open / "protected your PC" warning | See section 5 "Download & unblock" |

The most common causes are a **blocked network (corporate/school)** and **antivirus**. Step-by-step recovery is in [GUIDE.en.md](./GUIDE.en.md).

---

## 11. File / doc / data locations

### Files inside the kit folder

| File/folder | What it does |
|---|---|
| `시작하기.bat` | Korean start panel. **Start here.** |
| `INSTALL.bat` | Install the Netlify CLI (English engine) |
| `RUN.bat` | 26-item full menu: login, sites, deploy (English engine) |
| `UNINSTALL.bat` | Clean removal (English engine) |
| `lib\start.ps1` | The actual content of the Korean panel |
| `sample-site\index.html` | A one-page **practice** sample site |
| `README.md` / `README.en.md` | Overview (Korean / English) |
| `사용설명서.md` / `GUIDE.en.md` | Detailed guide (Korean / English) |
| `LICENSE` / `NOTICE` | License & notices |

### Where your data is stored (Windows)
- **Login key & settings:** `%APPDATA%\netlify\Config\config.json`
- **Where the Netlify tool installs:** `%APPDATA%\npm` (user folder — that's why no admin is needed)

---

## 12. Command reference (optional)

You don't need commands. For the curious, here is what the English full menu (`RUN.bat`, [2] Use → [6]) actually runs:

| Full-menu No. | Command | Meaning |
|---|---|---|
| 4 / 5 | `netlify login` / `netlify logout` | Log in / out |
| 6 | `netlify status` | Login / link status |
| 8 | `netlify sites:list` | List my sites |
| 9 | `netlify init` | Start this folder as a new site |
| 10 / 11 | `netlify link` / `netlify unlink` | Link / unlink folder ↔ site |
| 13 | `netlify dev` | Local preview server |
| 17 | `netlify deploy` | **Preview** deploy (safe) |
| 18 | `netlify deploy --prod` | **Production** deploy (needs YES) |
| 20–22 | `netlify env:list/set/unset` | View/set/remove env vars |
| 23 / 24 | `netlify open:site` / `open:admin` | Open my site / admin page |

> Item **26** of the full menu lets you type any command after `netlify` (advanced).

---

## 13. License · Copyright · Commercial use

Please follow this **strictly**. The full texts are [`LICENSE`](./LICENSE) and [`NOTICE`](./NOTICE) in this folder.

### This kit (the files we authored)
- **License: Apache License 2.0** — © 2026 **SoDam AI Studio**.
- **Commercial use allowed**: copy, modify, distribute, internal and commercial use are all permitted (under Apache-2.0 terms).
- Conditions: when redistributing, **include `LICENSE`/`NOTICE`**, state significant changes, keep attribution. **Trademarks are separate** (below).

### External programs the kit installs/uses (not ours)
- **netlify-cli** — **MIT License** © Netlify, Inc. (https://github.com/netlify/cli). Commercial use allowed.
- **Node.js** — MIT-style license © OpenJS Foundation and contributors. Installed by you from nodejs.org.

### Trademark · Service · Non-affiliation (important)
- **"Netlify"** is a **trademark** of **Netlify, Inc.** This kit is an **independent** tool, **not affiliated with, endorsed, or sponsored by** Netlify.
- **Code license and use of the Netlify service are separate.** Hosting, deployment, and fees are governed entirely by
  **Netlify's own Terms of Service and pricing** (https://www.netlify.com). **Exceeding the free tier may incur charges.**
- A trademark mention does not grant a code license. To use the "Netlify" name/logo in a commercial service, review Netlify's trademark policy separately.

### Disclaimer
- This kit is provided **"AS IS"** with **no warranty of any kind.**
- **You are responsible** for the results of use (deploys, charges, data, etc.). **Always review your content before a production deploy.**
