# Beginner's Guide — Netlify One-Click Kit

Written so that even a first-time computer user can follow it **exactly as shown on screen**. Hard words are explained in parentheses.
Korean guide: [사용설명서.md](./사용설명서.md). Short overview: [README.en.md](./README.en.md).

> **What is this tool?** Netlify = a service that **publishes your website to the internet**.
> This kit lets you use it through a **Korean menu, with no commands**.

> **Fastest path:** double-click `시작하기.bat` → follow the single **`>> What to do now`** line. That's all.

---

## 📑 Table of Contents
1. [5 words to know first](#1-5-words-to-know-first)
2. [What the screen looks like (preview)](#2-what-the-screen-looks-like-preview)
3. [Prerequisites & required programs](#3-prerequisites--required-programs)
4. [Download & unblock](#4-download--unblock)
5. [How to install (one-time)](#5-how-to-install-one-time)
6. [How to run · how to choose menu items](#6-how-to-run--how-to-choose-menu-items)
7. [Log in (connect account, incl. sign-up)](#7-log-in-connect-account-incl-sign-up)
8. [Practice deploy with the sample site (1-minute success)](#8-practice-deploy-with-the-sample-site-1-minute-success)
9. [Prepare your site · deploy your folder](#9-prepare-your-site--deploy-your-folder)
10. [Full workflow](#10-full-workflow)
11. [How to uninstall](#11-how-to-uninstall)
12. [When a problem or error happens](#12-when-a-problem-or-error-happens)
13. [File / doc / data locations](#13-file--doc--data-locations)
14. [Command reference](#14-command-reference)
15. [FAQ](#15-faq)
16. [License · Copyright · Commercial use](#16-license--copyright--commercial-use)

---

## 1. 5 words to know first

Don't panic if you see unfamiliar words. These five are enough.

- **Node.js** = a supporting program like a car **engine**. The Netlify tool needs it to run. Install it **once**.
- **Black window (console/terminal)** = a window where you tell the computer to do things with text. The kit **opens and closes it for you.** It's normal, not scary.
- **Netlify account** = your **ID** for Netlify. If you don't have one, **sign up free first** (email or GitHub, no card).
- **Deploy** = **putting your website on the internet** so it has an address (URL).
  - **Preview** = a temporary address only **you** check (safe, for practice).  **Production** = **anyone** can see it (be careful).
- **CLI** = "command-line tool." Since we only **press menu items**, there's nothing to memorize.

---

## 2. What the screen looks like (preview)

When you double-click `시작하기.bat`, you'll see something like this. (Real colors: green = good/recommended, yellow = to-do, red = caution.)

```
  ============================================
       Netlify 원클릭 키트 - 시작하기   (Start Here)
  ============================================

  [My computer status]
   - Node.js (required part) : present  [OK]
   - Netlify CLI             : missing  [install needed]

  >> What to do now: press [1] Install.

   How to choose: Up/Down arrows + Enter, or number keys (1-9)
   Fast path: just Enter = run the green recommended item.   ESC = cancel/back
  --------------------------------------------

   > [1] Install      (put the Netlify tool on this PC)   <- this one!
     [2] Use          (log in / sites / deploy)
     [3] Something's wrong? (self-diagnosis - in Korean)
     [4] Uninstall    (clean removal; your code is kept)  (caution)
     [5] Guide        (open the beginner guide)
     [6] Open Netlify dashboard (manage my sites)
     [0] Exit

   >> Now selected: Installs the Netlify tool. One-time only.
```

> Just read the bottom **`>> What to do now`** line and the **`>> Now selected`** description. They change with your state.

---

## 3. Prerequisites & required programs

### What you prepare yourself
1. **Windows 10 or 11** — this kit is Windows-only.
2. **Internet connection** — needed for install, login, and deploy.
3. **Node.js (required part) v20.12.2 or newer** — the kit does **NOT** install Node.js automatically. Install it yourself (see section 5).
4. **A Netlify account (free)** — needed at the login step. Sign up at https://app.netlify.com (no card).

### What the kit installs for you
- **netlify-cli** — the Netlify tool itself. **[1] Install** does it automatically.

> At a glance: **You prepare** = Windows + Internet + Node.js + Netlify account. **Kit handles** = installing netlify-cli.

---

## 4. Download & unblock

Windows sometimes **locks** files downloaded from the internet. Just unblock them.

- **Method 1 (easiest):** **Before** unzipping, right-click the zip → **Properties → check 'Unblock' at the bottom → OK**. Then unzip.
- **Method 2:** Right-click `시작하기.bat` → **Properties → check 'Unblock' → OK**, then double-click.
- If a blue **"Windows protected your PC"** dialog appears → **More info → Run anyway**.

> Once `시작하기.bat` runs, the lock on the rest of the files is **removed automatically.** (So usually you only deal with this once.)

---

## 5. How to install (one-time)

1. `시작하기.bat` → choose **[1] Install**.
2. **No admin prompt appears now.** (Netlify installs only into your user folder `%APPDATA%\npm`, so no admin rights are needed.)
3. A black window runs 6 steps in English. **Do not close it; wait (3–10 min).**
   - ⚠️ **Important:** the text may look **frozen for a while — that's normal** (downloading files).
     **Don't close the window.** Closing it breaks the install and you'll start over. Just wait.
4. `ALL DONE!  NETLIFY CLI IS INSTALLED.` means success. It looks like:

```
  [Verify] Checking that Netlify CLI works...
           Netlify CLI is ready: 26.x.x [OK]

  ============================================
     ALL DONE!  NETLIFY CLI IS INSTALLED.
  ============================================
```

**If it says Node.js is missing?**
→ The kit does not install Node.js automatically. Get it yourself:
   1. Open https://nodejs.org in your browser
   2. Download the big green **LTS** button (version 20 or higher) and install it
   3. Close the window and **run `시작하기.bat` again** → then [1] Install

> If right after install it says "netlify command not found", close all windows and open `시작하기.bat` in a **new** window. (Windows needs a new window to recognize a new program.)

---

## 6. How to run · how to choose menu items

Double-clicking `시작하기.bat` automatically checks your status (Node / CLI / login) and tells you **what to do now** in one line.

**How it works (how it operates):** the Korean panel (`lib\start.ps1`) **re-reads your computer state every time** and
**calls the English engines** (`INSTALL.bat` / `RUN.bat` / `UNINSTALL.bat`) on your behalf for the actual install / run / removal.
So you only press Korean menu items, and the black window opens and closes automatically.

**How to choose (remember just 4 things):**
- Move with **Up/Down arrows** + **Enter**, or press a **number key** (1–9) directly.
- The **"Now selected: …"** line below shows what each item does **before you press**, so you choose accurately.
- **Just Enter** runs the green **recommended** item. (Fastest path.)
- **ESC** = **cancel and go back**. You can safely exit even if you entered the wrong place.

**Start menu (7 items):** [1] Install · [2] Use · [3] Something's wrong? (self-diagnosis) · [4] Uninstall · [5] Guide · [6] Netlify dashboard · [0] Exit.

**[2] Use → Korean "frequent tasks" submenu:** [1] Log in · [2] Check login · [3] List my sites · **[4] Practice deploy with sample site (recommended)** · [5] Deploy my folder · [6] Open full menu (English, 26 items) · [0] Back.

---

## 7. Log in (connect account, incl. sign-up)

> **No account? Sign up free first!** Logging in means entering an account you already have, so it won't work without one.
> 1. Open **https://app.netlify.com** in your browser
> 2. Click **Sign up** → register with email or a GitHub account (**free, no credit card**)
> 3. Once registered, proceed with login below.

1. `시작하기.bat` → **[2] Use** (the Korean "frequent tasks" menu opens)
2. Choose **[1] Log in**
3. Your browser opens automatically → **log in / Authorize** with your Netlify account
4. When you see "Success", close that tab and return to the black window.

> You only log in once; it remembers you afterward.
> To confirm it worked, use **[2] Check login**; to see your sites, **[3] List my sites**.

---

## 8. Practice deploy with the sample site (1-minute success)

You **don't need your own website yet.** The kit includes a **practice example** so you can safely experience a deploy.

1. `시작하기.bat` → **[2] Use** → **[4] Practice deploy with sample site**
2. Choose **[1] Preview** (safe). (Not a real public release.)
3. After a moment a **temporary URL (Draft URL)** appears. Open it.
4. If you see **"Congratulations! 🎉 Your first site is on the internet"**, it's a **success**.

> Once you complete this loop (install → login → deploy → check the live URL), you can publish **your real website** the same way.

---

## 9. Prepare your site · deploy your folder

Order matters: **log in → (if needed) link a site → deploy**

**Don't have a website yet?** Try section 8 "practice deploy" first. To create a real site, use the full menu:
`시작하기.bat` → **[2] Use** → **[6] Open full menu** (English, 26 items) → **9) Start a new Netlify website here (init)** to start this folder as a new site. (If you already have one, use **10) Link**.)

**To deploy your website:** `시작하기.bat` → **[2] Use** → **[5] Deploy my folder**
- It first **checks whether this folder has a website**. If not, it safely asks you to enter the website folder path. (Prevents publishing the wrong folder.)
- Then you choose between **[1] Preview (safe)** and **[2] Production**.
- Production proceeds only after you type **`YES` (uppercase)**.

Netlify keeps you safe with **two kinds of deploy**:
- **Preview (Draft)** — visible only at a temporary URL; the real site is untouched. **Always practice with this first!**
- **Production** — visitors see it immediately. Proceeds only after **`YES` (uppercase)**. Do it only when you're sure.

> If unsure, check with preview first, and do production once it looks right.

---

## 10. Full workflow

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

## 11. How to uninstall

1. `시작하기.bat` → **[4] Uninstall**
2. Use **[1] Preview** to see what will be removed, then type **`YES`** in **[2]**
3. It's cleanly removed.

**Rest assured:** after removal,
- your **website code files** are kept
- **Node.js** is kept
- the **live sites** on Netlify's servers are kept. (Only the Netlify tool, login key, and cache are removed.)

---

## 12. When a problem or error happens (don't panic)

> **If you don't know what's wrong?** Use `시작하기.bat` → **[3] Something's wrong? (Self-diagnosis)**.
> It automatically checks Node.js / install / login / internet and tells you the **fix in Korean** right away. (It changes nothing, so it's safe.)

| If you see this | Do this |
|---|---|
| `OH NO - NETLIFY CLI IS NOT INSTALLED` | Run `시작하기.bat` → [1] Install first |
| Installed but `netlify ... not found` | Close all windows and reopen `시작하기.bat` in a **new** window |
| `Node.js is NOT on this computer` | Install **LTS** from https://nodejs.org, then [1] again |
| `Your Node.js is TOO OLD` | Reinstall the latest LTS from nodejs.org, then [1] again |
| `The install did not finish` | Follow "When internet/install fails" below |
| `permission` or `EACCES` error (rare) | Right-click `INSTALL.bat` → **Run as administrator** just once |
| Wrong number in a menu | It just returns to the menu. No worries. |

### When internet/install fails (do these one by one)

1. **Check the internet first:** open any site (e.g., google.com) in your browser. If it fails, fix Wi-Fi/LAN first.
2. **Pause antivirus briefly:** antivirus (Defender, etc.) often blocks install files. Turn it off for **10 minutes** and run [1] again.
3. **On a company/school Wi-Fi:** such networks often block external downloads. Switch to **home Wi-Fi or a phone hotspot** and retry. (Fastest fix.)
4. **Still stuck (advanced):** in the black window, type these one line at a time:
   - `npm cache clean --force` (clears partial files)
   - `npm install -g netlify-cli` (reinstall)
5. If nothing works, your corporate network may need a **proxy** setting. Ask your IT admin for the "npm proxy address."

---

## 13. File / doc / data locations

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
- **Note:** `%APPDATA%` is usually `C:\Users\(your name)\AppData\Roaming`.

---

## 14. Command reference

You **don't need to memorize commands** — the menu runs them. For the curious, here is what each number in the English full menu (`RUN.bat`) actually runs:

| Full-menu No. | Command run | Meaning |
|---|---|---|
| 1 | `netlify --version` | Show version |
| 4 / 5 / 6 | `netlify login` / `logout` / `status` | Log in / out / status |
| 7 | `netlify switch` | Switch to another account |
| 8 | `netlify sites:list` | List my sites |
| 9 | `netlify init` | Start this folder as a new site |
| 10 / 11 | `netlify link` / `unlink` | Link / unlink folder ↔ site |
| 12 | `netlify sites:create` | Create a new empty site |
| 13 | `netlify dev` | Local preview server (stop: Ctrl+C) |
| 14 | `netlify build` | Build the project |
| 15 / 16 | `netlify functions:list` / `serve` | List / run functions locally |
| 17 | `netlify deploy` | **Preview** deploy (safe) |
| 18 | `netlify deploy --prod` | **Production** deploy (needs YES) |
| 19 | `netlify watch` | Watch recent deploys |
| 20 / 21 / 22 | `netlify env:list` / `set` / `unset` | View / set / remove env vars |
| 23 / 24 | `netlify open:site` / `open:admin` | Open my site / admin page |
| 25 | `netlify help` | Full help |
| 26 | (type your own) | Run any command after `netlify` (advanced) |

---

## 15. FAQ

**Q. Do I have to memorize commands?**
A. No. Just use arrows or numbers. (Advanced users can type a command directly via full-menu item **26**.)

**Q. Does it cost money?**
A. Netlify has a **free tier**. Heavy usage may incur charges — check the Netlify dashboard. (The kit itself is free and unrelated to billing.)

**Q. What if I press the wrong thing and break something?**
A. Dangerous actions (production deploy, uninstall) all require typing **`YES` again**. In menus you can go back safely with **ESC**, or just close the window.

**Q. Can I take down a site I published?**
A. Yes. Manage or delete sites in the Netlify dashboard (menu [6]). See Netlify's help for details.

**Q. The Korean panel won't open.**
A. If `시작하기.bat` fails, you can double-click **INSTALL.bat → RUN.bat → UNINSTALL.bat** directly; they work the same (in English).

---

## 16. License · Copyright · Commercial use

Please follow this **strictly**. The full texts are [`LICENSE`](./LICENSE) and [`NOTICE`](./NOTICE) in this folder.

### This kit (the files we authored)
- **License: Apache License 2.0** — © 2026 **SoDam AI Studio**.
- **Commercial use allowed**: copy, modify, distribute, internal and commercial use are all permitted (under Apache-2.0 terms).
- Conditions: when redistributing, **include `LICENSE`/`NOTICE`**, state significant changes, keep attribution. **Trademarks are separate** (below).

### External programs the kit installs/uses (not ours)
- **netlify-cli** — **MIT License** © Netlify, Inc. (https://github.com/netlify/cli). Commercial use allowed.
- **Node.js** — MIT-style license © OpenJS Foundation and contributors. You install it from nodejs.org.

### Trademark · Service · Non-affiliation (important)
- **"Netlify"** is a **trademark** of **Netlify, Inc.** This kit is an **independent** tool, **not affiliated with, endorsed, or sponsored by** Netlify.
- **Code license and use of the Netlify service are separate.** Hosting, deployment, and fees are governed entirely by
  **Netlify's own Terms of Service and pricing** (https://www.netlify.com). **Exceeding the free tier may incur charges.**
- A trademark mention does not grant a code license. To use the "Netlify" name/logo in a commercial service, review Netlify's trademark policy separately.

### Disclaimer
- This kit is provided **"AS IS"** with **no warranty of any kind.**
- **You are responsible** for the results of use (deploys, charges, data, etc.). **Always review your content before a production deploy.**
