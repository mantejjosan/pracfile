# AI Practicals Formatting Workflow
## 📘 What is this?

This repository provides a **template for generating college-style practical files** in a clean and structured format.

You write your code in **Jupyter notebooks**, and the `build.sh` script automatically converts and compiles them into a **single, well-formatted PDF** containing all your practicals.

---

## ✨ Why use this?

* Only **one person** needs to set up the formatting using Typst (a modern and simpler alternative to LaTeX, yet equally powerful).
* Everyone else can focus purely on writing code in Jupyter notebooks.
* The final output is **consistent, professional, and ready for submission**.

---

## 📂 Convention

To ensure proper ordering and processing:

* Name your notebooks as:

  * `p01.ipynb`
  * `p02.ipynb`
  * `p03.ipynb`
  * and so on...

---

## ⚙️ Prerequisites

The following tools are required:

* Pandoc
* Typst compiler
* JupyterLab
* Zathura (PDF viewer)

---

## 🚀 Getting Started

### 🟦 Ubuntu / Debian (and derivatives)

```bash
curl -sSL https://raw.githubusercontent.com/mantejjosan/pracfile/main/debian_based_install.sh | bash
```

---

### 🟩 Arch Linux

```bash
curl -sSL https://raw.githubusercontent.com/mantejjosan/pracfile/main/arch_based_install.sh | bash
```

---

## 🧠 Workflow

1. Write your practicals in Jupyter notebooks inside the `notebooks/` folder
2. After completing your work, run:

```bash
cd workflow
bash build.sh
```

3. Open the generated PDF:

```bash
zathura main.pdf
```
