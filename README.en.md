# Netlify CLI One-Click Kit 🚀

> One-click install, use, and uninstall for Netlify CLI on Windows — no command-line knowledge required

**Korean guide:** [README.md](./README.md)

---

## What is this?

Netlify is a free service that lets you publish websites to the internet.  
Netlify CLI is a tool that lets you control that service from your own computer.

This kit gives you **three simple batch scripts** so you can install, use, and uninstall Netlify CLI on Windows with a double-click — no terminal experience needed.

---

## File Structure

```
Netlify-CLI_One-Click_Kit/
├── INSTALL.bat      ← Install Netlify CLI (run once)
├── RUN.bat          ← Use Netlify CLI via easy menu (start here daily)
├── UNINSTALL.bat    ← Remove Netlify CLI when no longer needed
├── README.md        ← Korean guide
└── README.en.md     ← English guide (this file)
```

---

## System Requirements

| Item | Requirement |
|------|-------------|
| OS | Windows 10 or Windows 11 |
| Node.js | **v20.12.2 or higher** (LTS recommended) |
| npm | Included with Node.js |
| Internet | Required for installation; some features need it afterwards |

> **Don't have Node.js?**  
> → Go to [https://nodejs.org](https://nodejs.org) and download the **LTS** version.  
> → Run the installer and click "Next" through all the default options.

---

## Beginner's Getting Started Guide

### Step 1: Install

1. Double-click **`INSTALL.bat`** in this folder.
2. When Windows asks "Do you want to allow this app to make changes?" click **Yes**.
3. A black window opens and installation begins. **Do not close this window.**
4. When you see `ALL DONE! NETLIFY CLI IS INSTALLED.` — you're done.
5. Press any key to close the window.

> ⏱ Installation takes 3–10 minutes depending on your internet speed.

### Step 2: Use

1. Double-click **`RUN.bat`**.
2. A numbered menu appears. Type a number and press Enter.
3. First time? Choose **`4` (Log in to Netlify)** to log in to your account.
4. Your browser will open — log in with your Netlify account.
5. Once logged in, you're ready to use all features.

### Step 3: Deploy a Website

1. In the `RUN.bat` menu, choose **`17` (Deploy PREVIEW)** to do a safe test deployment first.
2. A preview URL will appear — check that everything looks right.
3. When ready to go live, choose **`18` (Deploy to PRODUCTION)**.
4. Type `YES` and your website will be published to the internet.

---

## Full Menu Reference (RUN.bat)

### Basic
| # | Action |
|---|--------|
| 1 | Show Netlify CLI version |
| 2 | Update Netlify CLI to latest version |
| 3 | Run full diagnostic (find problems) |

### Account
| # | Action |
|---|--------|
| 4 | Log in to Netlify |
| 5 | Log out from Netlify |
| 6 | Show login status |
| 7 | Switch to another account |

### My Websites
| # | Action |
|---|--------|
| 8 | List all my sites |
| 9 | Start a new Netlify site in this folder (init) |
| 10 | Link this folder to an existing site |
| 11 | Unlink this folder from a site |
| 12 | Create a brand new empty site |

### Develop
| # | Action |
|---|--------|
| 13 | Start local dev server (preview on your PC) |
| 14 | Build the project |
| 15 | List functions |
| 16 | Run functions locally |

### Deploy
| # | Action |
|---|--------|
| 17 | Deploy PREVIEW (safe draft — nothing changes live) |
| 18 | Deploy to PRODUCTION (goes live immediately, requires YES) |
| 19 | Watch recent deploys |

### Environment Variables
| # | Action |
|---|--------|
| 20 | List all env vars |
| 21 | Set an env var |
| 22 | Remove an env var |

### Open in Browser
| # | Action |
|---|--------|
| 23 | Open my live website |
| 24 | Open Netlify admin dashboard |

### Advanced
| # | Action |
|---|--------|
| 25 | Show all netlify commands (help) |
| 26 | Type a custom netlify command |
| 0  | Exit |

---

## Environment Variables

Environment variables let you store API keys and secret settings safely — outside of your code files.

- **How to set:** Menu `21` → enter a name → enter a value
- **Example names:** `API_KEY`, `DATABASE_URL`, `SECRET_TOKEN`
- **Note:** Make sure no one can see your screen when you type secret values.

> ⚠️ Never put API keys, passwords, or tokens directly inside `.bat` files or code files.  
> Always use environment variables (menu 21) to manage secrets safely.

---

## How to Uninstall

When you no longer need Netlify CLI:

1. Double-click **`UNINSTALL.bat`**.
2. Click **Yes** when Windows asks for permission.
3. Press `1` to preview what will be removed (nothing changes yet).
4. Press `2`, then type `YES` to confirm removal.
5. When you see `ALL DONE! NETLIFY CLI WAS REMOVED.` — it's done.

> Your website files, Node.js, and npm are **not** removed. Only Netlify CLI is uninstalled.

---

## Common Errors & Fixes

### "Node.js is NOT on this computer"
→ Install Node.js from [https://nodejs.org](https://nodejs.org) (choose LTS version).

### "Your Node.js is TOO OLD"
→ Download the latest LTS from the same site and install it — it will replace the old version.

### "The install did not finish (tried twice)"
→ Temporarily pause your antivirus and try again.  
→ Or open Command Prompt as Administrator and run: `npm install -g netlify-cli --force`

### "Netlify CLI is not on this computer" (when opening RUN.bat)
→ Run `INSTALL.bat` first.

### "netlify command not found" (after installing)
→ Close this window, open a new one, or restart your PC.

### Installation fails on a company/firewall network
→ Ask your IT team to allow access to `registry.npmjs.org`.

---

## Security Notes

- Never write API keys, passwords, or tokens directly inside `.bat` files.
- Before running any `.bat` file from an unknown source, open it in Notepad and review the contents.
- Running `UNINSTALL.bat` will remove your Netlify login token — you will need to log in again if you reinstall.
- Menu option `18` (Deploy to PRODUCTION) publishes your site immediately. Always review before typing `YES`.

---

## License

Apache License 2.0 — Copyright 2026 SoDam AI Studio  
See the [LICENSE](./LICENSE) file for full details.
