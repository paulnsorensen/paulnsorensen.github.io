# AGENTS.md

This repository is the static homepage for cheeselord.dev. It has no build step.

## Layout of the repository

- `index.html` is the only page.
- `styles/vendor/` holds `@cheeselord/design`. `scripts/sync-design.sh` vendors it at a pinned version. Do not edit files in `styles/vendor/`.
- `styles/site.css` holds only the styles that are unique to this page.
- `assets/shots/<name>.png` holds the project tile images.

## Checks

- Run `bash scripts/sync-design.sh`, then `git status --short`. The status must show no change. CI (`design-sync.yml`) runs the same drift check.
- Preview: `python3 -m http.server 8421 --bind 127.0.0.1`, then open `http://127.0.0.1:8421/`.
- Check the page at 1440, 1024, 768, and 390 px wide. The page must not scroll sideways at any width.

## Page layout rules

- Wide (over 56rem): the altar (headline and burning cheese) is on the left. The shelf (project tiles) is on the right.
- The burning cheese is centered under the headline. The `<br>` in the `h1` sets the headline width.
- The altar and the shelf are centered vertically between the header and the footer.
- Narrow (56rem or less): one column. The altar is above the shelf.

## Project tile images

The page crops each image to a 4:3 slot with `object-fit: cover`. A 1 px border sits on the slot edge. If an image is missing, the slot shows a dotted placeholder.

### Sizes

| Tile | Projects | Slot on screen (CSS px) | Image to make |
|---|---|---|---|
| Large | easy-cheese, hallouminate, milknado | 168x126 at 480px wide and more; up to 432x324 on phones | 1440x1080 PNG |
| Small | skillz-that-grillz, dotfiles | 80x60 at all widths | 320x240 PNG |

- Keep the important content in the center 90% of the image.
- For a placeholder image, use a flat `#131612` fill at the same size.
- Name each file `assets/shots/<project>.png`. The project name is the tile's `.name` text.

### Text in the image

The smallest slot sets the limits. Text must be 11 CSS px tall or more at that size.

| Tile | Characters per line | Lines | Minimum text height |
|---|---|---|---|
| Large | 18 or fewer | 2 or fewer | 9% of the image height (98 px in 1080) |
| Small | 6 or fewer; use none if possible | 1 | 18% of the image height (44 px in 240) |

### Text on the tile

| Text | Limit |
|---|---|
| Large tile headline (`h2`) | 42 characters |
| Small tile line (`.line`) | 44 characters |

### Colors

| Token | Hex | Use in images |
|---|---|---|
| `--cellar` | `#0d100e` | Deepest shadows only |
| `--panel` | `#131612` | Image background |
| `--bone` | `#d7e6db` | Brightest value. Do not use pure white |
| `--dim` | `#7a877e` | Secondary lines and interface chrome |
| `--gold` | `#f1c035` | The only accent. Use it on one focal element per image |
| `--flame` | `#db7300` | Glow and warmth only. Do not use it as a flat fill |

- Use no hue other than gold and flame. All neutrals use the green-grey of bone, dim, and panel.
- Keep the average lightness under about 30%. The images must not compete with the burning cheese.
- Keep gold away from the image edge. The slot border becomes gold on hover.
- Use flat terminal or interface crops. Do not use photos or busy gradients, because they become noise at 80x60.
- The hex values come from the rendered oklch tokens. If `styles/site.css` or the vendored flavor changes a token, measure it again.
