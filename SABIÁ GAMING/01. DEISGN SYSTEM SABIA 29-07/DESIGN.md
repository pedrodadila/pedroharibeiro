---
name: Sabiá Cyber-Performance
colors:
  surface: '#0d1514'
  surface-dim: '#0d1514'
  surface-bright: '#333b39'
  surface-container-lowest: '#08100f'
  surface-container-low: '#151d1c'
  surface-container: '#192120'
  surface-container-high: '#242c2a'
  surface-container-highest: '#2e3635'
  on-surface: '#dce4e2'
  on-surface-variant: '#bacac7'
  inverse-surface: '#dce4e2'
  inverse-on-surface: '#2a3231'
  outline: '#849491'
  outline-variant: '#3b4a47'
  surface-tint: '#00dece'
  primary: '#4afeed'
  on-primary: '#003733'
  primary-container: '#00e1d1'
  on-primary-container: '#005f58'
  inverse-primary: '#006a62'
  secondary: '#b2ccc7'
  on-secondary: '#1e3431'
  secondary-container: '#344b47'
  on-secondary-container: '#a1bab5'
  tertiary: '#e5e5e5'
  on-tertiary: '#2f3131'
  tertiary-container: '#c9c9c9'
  on-tertiary-container: '#535455'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#46fbea'
  primary-fixed-dim: '#00dece'
  on-primary-fixed: '#00201d'
  on-primary-fixed-variant: '#00504a'
  secondary-fixed: '#cee8e3'
  secondary-fixed-dim: '#b2ccc7'
  on-secondary-fixed: '#081f1c'
  on-secondary-fixed-variant: '#344b47'
  tertiary-fixed: '#e2e2e2'
  tertiary-fixed-dim: '#c6c6c7'
  on-tertiary-fixed: '#1a1c1c'
  on-tertiary-fixed-variant: '#454747'
  background: '#0d1514'
  on-background: '#dce4e2'
  surface-variant: '#2e3635'
typography:
  headline-xl:
    fontFamily: Sora
    fontSize: 42px
    fontWeight: '900'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Sora
    fontSize: 32px
    fontWeight: '800'
    lineHeight: '1.2'
  headline-md:
    fontFamily: Sora
    fontSize: 22px
    fontWeight: '800'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Montserrat
    fontSize: 16px
    fontWeight: '500'
    lineHeight: '1.6'
  body-md:
    fontFamily: Montserrat
    fontSize: 14px
    fontWeight: '400'
    lineHeight: '1.5'
  label-lg:
    fontFamily: Sora
    fontSize: 15px
    fontWeight: '700'
    lineHeight: '1.2'
  label-sm:
    fontFamily: Sora
    fontSize: 11px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: 0.05em
  code:
    fontFamily: JetBrains Mono
    fontSize: 13px
    fontWeight: '400'
    lineHeight: '1.4'
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  margin-mobile: 1rem
  margin-desktop: 2rem
  gutter: 1.5rem
  container-max: 1280px
---

## Brand & Style

This design system is engineered for the high-stakes environment of gaming and performance marketing. It embodies a **Technological Minimalism** aesthetic, characterized by a clinical "High-Contrast Dark Theme" that prioritizes data legibility and rapid cognitive processing.

The visual narrative centers on "Precision in the Shadows." By utilizing a deep, atmospheric background contrasted against luminescent cyan and pure white accents, the UI evokes a sense of advanced telemetry and digital mastery. The style is defined by razor-sharp structural lines, subtle translucency for depth, and sophisticated rounded corners that soften the technical edge without sacrificing the professional tone.

**Design Principles:**
- **Surgical Contrast:** Use pure whites and electric cyans sparingly against deep dark emeralds to guide focus.
- **Low Latency Layouts:** Information hierarchy is optimized for immediate action and clear ROI tracking.
- **Cybernetic Elegance:** High-performance visuals that feel premium, avoiding the cluttered tropes of traditional "gamer" aesthetics.

## Colors

The color palette is a "High-Contrast Dark Theme" designed for prolonged focus and visual impact. 

- **Primary (Electric Mint):** Used exclusively for high-priority calls to action, active states, and critical performance indicators.
- **Secondary (Dark Emerald):** The core surface color, providing a sophisticated alternative to pure black that adds depth and brand character.
- **Tertiary (Snow White):** Used for maximum legibility and critical interactive elements, providing a neutral anchor to the cyan/emerald core.
- **Background (Deep Jungle):** The foundation of the UI, creating the "Selva Profunda" atmosphere.

Avoid any warm tones like yellow or gold; the palette must remain strictly in the cold, high-tech spectrum of cyans, emeralds, and whites.

## Typography

The typography system establishes a rigorous Single Source of Truth (SSOT). **Sora** provides a geometric, modern voice for all structural and high-impact elements, while **Montserrat** ensures high-readability for long-form content and data.

- **Headlines:** Use Sora with heavy weights (800-900) to project authority. H1 titles may use the Primary Cyan or Tertiary White for brand emphasis.
- **Body:** Use Montserrat at 14px for standard UI text to maintain clarity in data-dense environments.
- **Labels:** Use Sora in uppercase for category labels and small metadata to maintain the "technical" feel of a dashboard.
- **Performance Metrics:** Use Sora Bold for numbers and growth percentages to emphasize performance results.

## Layout & Spacing

This design system utilizes a **Fixed Grid** model for dashboard environments and a **Fluid Grid** for marketing pages. 

- **Grid:** A 12-column system with 24px gutters. Content should be contained within a 1280px max-width to ensure optimal line lengths and focus.
- **Rhythm:** A 4px/8px baseline grid maintains vertical consistency. 
- **Density:** High density for performance dashboards (minimal padding) vs. Low density for brand landing pages (heavy whitespace to let the logo and typography breathe).
- **Responsiveness:** At the 768px breakpoint (Tablet), margins reduce to 24px. At 480px (Mobile), headlines scale down by 25% and margins become 16px.

## Elevation & Depth

Hierarchy is established through **Tonal Layers** rather than heavy shadows, reflecting a modern, technical aesthetic.

- **Base Layer:** `#0a1c1a` (Deep Jungle) used for the main application background.
- **Surface Layer:** `#102724` (Dark Emerald) for cards, sidebars, and primary containers.
- **Elevated Layer:** `#173632` for modals, tooltips, and popovers that sit above the main UI.
- **Ghost Borders:** Use 1px borders in `#1b423d` or low-opacity `#ffffff` for all containers to create definition without visual noise.
- **Luminescence:** Use a subtle glow effect (box-shadow: 0 0 15px rgba(0, 225, 209, 0.2)) exclusively for active primary buttons or critical performance alerts.

## Shapes

The shape language balances "Surgical Precision" with "Modern Softness." 

- **Standard Radius:** 8px (rounded-md) for small components like buttons, input fields, and tags.
- **Large Radius:** 16px (rounded-lg) for main content cards and section containers.
- **Interactive Elements:** Use 8px for buttons to maintain a professional, sturdy feel.
- **Logo Integration:** When placing the Sabiá Gaming icon, ensure it is never enclosed in a shape smaller than its recommended clear space.

## Components

### Buttons
- **Primary:** Background `#00e1d1`, Text `#102724` (Bold Sora). High contrast for immediate visibility.
- **Secondary:** Background `#102724`, Border 1px `#ffffff` (20% opacity), Text `#ffffff`.
- **Tertiary:** Text `#00e1d1` or `#ffffff`, no background. Used for less critical actions.

### Cards
- Background: `#102724`.
- Border: 1px solid `#1b423d`.
- Radius: 16px (rounded-lg).
- Padding: 24px consistent.

### Inputs & Selection
- **Fields:** Dark background (`#04100e`) with a 1px border. Focus state changes border to `#00e1d1` with a subtle outer glow.
- **Checkboxes/Radios:** Square with 4px radius, using Primary Cyan for the checked state.

### Lists & Tables
- **Rows:** Separated by 1px `#1b423d` or muted white lines. 
- **Headers:** Sora Bold, 11px, Uppercase, color `#8da8a4`.

### Logos
- Use the **Sabiá Gaming Branca** for all dark-themed navigation bars.
- Integrate the **Setor de Performance** logo in a co-branded footer or sidebar, separated by the defined 1px divider.