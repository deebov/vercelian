/*
 * Vercelian's popover, rebuilt for the web so visitors can try the app.
 * It runs on sample data and never talks to Vercel. Sizes, colors, and
 * timings are the app's own. SF Symbols may only be used in apps on Apple
 * platforms, so the icons here, the menu bar's included, are drawn for this
 * page at the sizes of the symbols the app and macOS show; the wordmark and
 * branch icon are the app's own.
 */
(() => {
  "use strict";

  const demo = document.getElementById("demo");
  if (!demo) return;

  // MARK: - Icons

  const WORDMARK = `<svg viewBox="0 0 347 51" fill="currentColor" aria-hidden="true"><path d="M58.65 51L29.325 0L0 51H58.65ZM88.2274 48.6783L112.735 2.3182H102.134L85.2287 35.9865L68.3231 2.3182H57.7227L82.2299 48.6783H88.2274ZM255.243 2.3182V48.6784H246.467V2.3182H255.243ZM206.393 31.3748C206.393 27.7618 207.147 24.5841 208.656 21.8416C210.164 19.0992 212.267 16.9879 214.964 15.5079C217.66 14.0278 220.814 13.2879 224.426 13.2879C227.625 13.2879 230.504 13.9843 233.064 15.3773C235.623 16.7703 237.657 18.838 239.166 21.5805C240.674 24.3229 241.451 27.6748 241.497 31.6361V33.6602H215.65C215.832 36.5333 216.678 38.7969 218.186 40.451C219.74 42.0617 221.82 42.867 224.426 42.867C226.07 42.867 227.579 42.4317 228.95 41.5611C230.321 40.6904 231.35 39.5151 232.035 38.035L241.017 38.688C239.92 41.9528 237.863 44.5647 234.846 46.5236C231.829 48.4825 228.356 49.4619 224.426 49.4619C220.814 49.4619 217.66 48.7219 214.964 47.2418C212.267 45.7618 210.164 43.6505 208.656 40.9081C207.147 38.1657 206.393 34.9879 206.393 31.3748ZM232.446 28.11C232.127 25.2805 231.235 23.2128 229.773 21.907C228.31 20.5575 226.527 19.8827 224.426 19.8827C222.003 19.8827 220.038 20.601 218.529 22.0375C217.021 23.474 216.083 25.4982 215.718 28.11H232.446ZM191.588 21.907C193.051 23.0822 193.965 24.7147 194.331 26.8041L203.381 26.3471C203.061 23.6917 202.124 21.3846 200.57 19.4257C199.016 17.4668 197.004 15.965 194.537 14.9202C192.114 13.832 189.441 13.2879 186.515 13.2879C182.904 13.2879 179.751 14.0278 177.053 15.5079C174.356 16.9879 172.255 19.0992 170.746 21.8416C169.238 24.5841 168.483 27.7618 168.483 31.3748C168.483 34.9879 169.238 38.1657 170.746 40.9081C172.255 43.6505 174.356 45.7618 177.053 47.2418C179.751 48.7219 182.904 49.4619 186.515 49.4619C189.532 49.4619 192.274 48.9177 194.743 47.8295C197.21 46.6977 199.222 45.1088 200.775 43.0628C202.33 41.0169 203.266 38.6227 203.586 35.8803L194.468 35.4885C194.148 37.7956 193.257 39.5804 191.794 40.8428C190.331 42.0617 188.572 42.6711 186.515 42.6711C183.681 42.6711 181.488 41.6916 179.933 39.7327C178.379 37.7738 177.602 34.9879 177.602 31.3748C177.602 27.7618 178.379 24.9759 179.933 23.017C181.488 21.0581 183.681 20.0786 186.515 20.0786C188.48 20.0786 190.171 20.6881 191.588 21.907ZM147.069 14.0698H155.235L155.472 20.7304C156.051 18.8451 156.857 17.381 157.89 16.3381C159.387 14.8259 161.474 14.0698 164.15 14.0698H167.485V21.1989H164.083C162.177 21.1989 160.612 21.4582 159.387 21.9766C158.207 22.4951 157.3 23.316 156.665 24.4394C156.075 25.5628 155.781 26.9886 155.781 28.7168V48.6783H147.069V14.0698ZM109.401 21.8416C107.893 24.5841 107.138 27.7618 107.138 31.3748C107.138 34.9879 107.893 38.1657 109.401 40.9081C110.909 43.6505 113.011 45.7618 115.708 47.2418C118.405 48.7219 121.559 49.4619 125.17 49.4619C129.101 49.4619 132.575 48.4825 135.591 46.5236C138.607 44.5647 140.665 41.9528 141.761 38.688L132.78 38.035C132.094 39.5151 131.066 40.6904 129.695 41.5611C128.324 42.4317 126.816 42.867 125.17 42.867C122.565 42.867 120.485 42.0617 118.931 40.451C117.423 38.7969 116.577 36.5333 116.394 33.6602H142.241V31.6361C142.196 27.6748 141.419 24.3229 139.911 21.5805C138.402 18.838 136.368 16.7703 133.808 15.3773C131.249 13.9843 128.369 13.2879 125.17 13.2879C121.559 13.2879 118.405 14.0278 115.708 15.5079C113.011 16.9879 110.909 19.0992 109.401 21.8416ZM130.518 21.907C131.98 23.2128 132.872 25.2805 133.191 28.11H116.463C116.828 25.4982 117.765 23.474 119.273 22.0375C120.782 20.601 122.747 19.8827 125.17 19.8827C127.273 19.8827 129.055 20.5575 130.518 21.907Z"/><path d="M316.106 49.0014V13.6346H323.788L323.987 19.6615C325.908 14.8267 329.882 12.8398 334.584 12.8398C342.399 12.8398 346.638 18.3369 346.638 26.2845V49.0014H338.16V28.9999C338.16 23.0392 336.571 19.7278 332.001 19.7278C327.431 19.7278 324.583 23.0392 324.583 28.9999V49.0014H316.106Z"/><path d="M288.081 49.7961C280.663 49.7961 275.762 46.2859 275.762 40.1266C275.762 34.0334 279.537 30.7881 287.286 29.2649L299.009 26.9468C299.009 21.9796 296.691 19.3966 292.187 19.3966C288.081 19.3966 285.763 21.3173 284.968 24.8937L276.358 24.4963C277.749 17.0786 283.445 12.8398 292.187 12.8398C302.254 12.8398 307.486 18.1382 307.486 27.5429V40.3915C307.486 42.3121 308.148 42.842 309.473 42.842H310.599V49.0014C310.003 49.1338 308.678 49.2663 307.486 49.2663C303.645 49.2663 300.797 47.8755 300.135 43.5705C298.346 47.3456 293.843 49.7961 288.081 49.7961ZM289.803 43.6367C295.432 43.6367 299.009 40.0603 299.009 34.6957V32.7088L289.869 34.5632C286.094 35.2918 284.571 36.8813 284.571 39.3318C284.571 42.1135 286.425 43.6367 289.803 43.6367Z"/><path d="M261.544 8.92911V1.37891H270.352V8.92911H261.544ZM261.676 48.9982V13.6314H270.153V48.9982H261.676Z"/></svg>`;
  const BRANCH = `<svg viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M4.75 1.75V1H3.25V1.75V9.09451C1.95608 9.42754 1 10.6021 1 12C1 13.6569 2.34315 15 4 15C5.42051 15 6.61042 14.0127 6.921 12.6869C8.37102 12.4872 9.7262 11.8197 10.773 10.773C11.8197 9.7262 12.4872 8.37102 12.6869 6.921C14.0127 6.61042 15 5.42051 15 4C15 2.34315 13.6569 1 12 1C10.3431 1 9 2.34315 9 4C9 5.37069 9.91924 6.52667 11.1749 6.8851C10.9929 7.94904 10.4857 8.9389 9.71231 9.71231C8.9389 10.4857 7.94904 10.9929 6.8851 11.1749C6.59439 10.1565 5.77903 9.35937 4.75 9.09451V1.75ZM13.5 4C13.5 4.82843 12.8284 5.5 12 5.5C11.1716 5.5 10.5 4.82843 10.5 4C10.5 3.17157 11.1716 2.5 12 2.5C12.8284 2.5 13.5 3.17157 13.5 4ZM4 13.5C4.82843 13.5 5.5 12.8284 5.5 12C5.5 11.1716 4.82843 10.5 4 10.5C3.17157 10.5 2.5 11.1716 2.5 12C2.5 12.8284 3.17157 13.5 4 13.5Z"/></svg>`;

  // Each at the size of the SF Symbol shown in that spot, so the layout
  // matches point for point.
  const ICON = {
    refresh: `<svg viewBox="0 0 15 17" width="15" height="17" fill="none" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12.75 9.7 A5.43 5.08 0 1 1 7.34 4.97 L10 5.12 M7.1 2.42 L10 5.12 L7.05 7.92"/></svg>`,
    refreshSmall: `<svg viewBox="0 0 14 16" width="14" height="16" fill="none" stroke="currentColor" stroke-width="1.06" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M11.95 8.95 A5.22 5.2 0 1 1 6.73 4.06 L9.22 4.28 M6.5 1.56 L9.22 4.28 L6.55 6.95"/></svg>`,
    gear: `<svg viewBox="0 0 17 17" width="17" height="17" fill="none" stroke="currentColor" stroke-width="1.15" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M8.17 2.54 L8.48 2.55 L8.78 2.61 L9.06 2.81 L9.25 3.42 L9.37 4.03 L9.56 4.26 L9.77 4.36 L9.99 4.45 L10.2 4.54 L10.43 4.62 L10.72 4.59 L11.24 4.25 L11.8 3.94 L12.14 4 L12.4 4.18 L12.62 4.39 L12.83 4.61 L13.01 4.87 L13.07 5.21 L12.76 5.77 L12.42 6.29 L12.39 6.58 L12.47 6.81 L12.56 7.02 L12.65 7.24 L12.75 7.45 L12.98 7.64 L13.59 7.76 L14.2 7.95 L14.4 8.23 L14.46 8.53 L14.47 8.84 L14.46 9.15 L14.4 9.45 L14.2 9.73 L13.59 9.92 L12.98 10.04 L12.75 10.23 L12.65 10.44 L12.56 10.66 L12.47 10.87 L12.39 11.1 L12.42 11.39 L12.76 11.91 L13.07 12.47 L13.01 12.81 L12.83 13.07 L12.62 13.29 L12.4 13.5 L12.14 13.68 L11.8 13.74 L11.24 13.43 L10.72 13.09 L10.43 13.06 L10.2 13.14 L9.99 13.23 L9.77 13.32 L9.56 13.42 L9.37 13.65 L9.25 14.26 L9.06 14.87 L8.78 15.07 L8.48 15.13 L8.17 15.14 L7.86 15.13 L7.56 15.07 L7.28 14.87 L7.09 14.26 L6.97 13.65 L6.78 13.42 L6.57 13.32 L6.35 13.23 L6.14 13.14 L5.91 13.06 L5.62 13.09 L5.1 13.43 L4.54 13.74 L4.2 13.68 L3.94 13.5 L3.72 13.29 L3.51 13.07 L3.33 12.81 L3.27 12.47 L3.58 11.91 L3.92 11.39 L3.95 11.1 L3.87 10.87 L3.78 10.66 L3.69 10.44 L3.59 10.23 L3.36 10.04 L2.75 9.92 L2.14 9.73 L1.94 9.45 L1.88 9.15 L1.87 8.84 L1.88 8.53 L1.94 8.23 L2.14 7.95 L2.75 7.76 L3.36 7.64 L3.59 7.45 L3.69 7.24 L3.78 7.02 L3.87 6.81 L3.95 6.58 L3.92 6.29 L3.58 5.77 L3.27 5.21 L3.33 4.87 L3.51 4.61 L3.72 4.39 L3.94 4.18 L4.2 4 L4.54 3.94 L5.1 4.25 L5.62 4.59 L5.91 4.62 L6.14 4.54 L6.35 4.45 L6.57 4.36 L6.78 4.26 L6.97 4.03 L7.09 3.42 L7.28 2.81 L7.56 2.61 L7.86 2.55 Z"/><circle cx="8.17" cy="8.84" r="1.87"/></svg>`,
    close: `<svg viewBox="0 0 15 14" width="15" height="14" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2.68 2.49 L11.98 11.79 M11.98 2.49 L2.68 11.79"/></svg>`,
    people: `<svg viewBox="0 0 18 13" width="18" height="13" fill="currentColor" aria-hidden="true"><ellipse cx="5.4" cy="4.38" rx="1.85" ry="2.07"/><path d="M1.5 10.5 A4.42 3.25 0 0 1 7.95 7.61 A5.28 4 0 0 0 6.32 10.5 V11.25 H2.15 Q1.5 11.25 1.5 10.6 Z"/><ellipse cx="11.63" cy="3.94" rx="2.13" ry="2.32"/><path d="M7.07 10.5 A4.53 3.25 0 0 1 16.13 10.5 V10.6 Q16.13 11.25 15.48 11.25 H7.72 Q7.07 11.25 7.07 10.6 Z"/></svg>`,
    folder: `<svg viewBox="0 0 16 12" width="16" height="12" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M1.5 2.4 Q1.5 1.19 2.7 1.19 H4.75 Q5.05 1.19 5.3 1.42 L6.05 2 Q6.3 2.19 6.6 2.19 H12.8 Q13.94 2.19 13.94 3.35 V9.85 Q13.94 11 12.8 11 H2.65 Q1.5 11 1.5 9.85 Z M2.5 4.12 V3.7 Q2.5 3.25 2.95 3.25 H12.49 Q12.94 3.25 12.94 3.7 V4.12 Z"/></svg>`,
    chevronDown: `<svg viewBox="0 0 10 6" width="10" height="6" fill="none" stroke="currentColor" stroke-width="1.05" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M1.55 1.77 L4.49 4.7 L7.42 1.77"/></svg>`,
    chevronRight: `<svg viewBox="0 0 8 11" width="8" height="11" fill="none" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2.6 2.1 L6.35 5.85 L2.6 9.6"/></svg>`,
    chevronLeft: `<svg viewBox="0 0 10 13" width="10" height="13" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M6.1 2.37 L1.55 6.75 L6.1 11.13"/></svg>`,
    clock: `<svg viewBox="0 0 12 12" width="12" height="12" fill="none" stroke="currentColor" stroke-width="0.82" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="5.72" cy="6.28" r="4.56"/><path d="M5.69 3.29 V6.45 H3.35" stroke-width="0.7"/></svg>`,
    compass: `<svg viewBox="0 0 15 15" width="15" height="15" fill="none" stroke="currentColor" stroke-width="1.06" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="7.5" cy="7.5" r="5.92" fill="none"/><path fill="currentColor" fill-rule="evenodd" stroke-width="0.5" d="M10.54 4.46 L8.62 8.62 L4.46 10.54 L6.38 6.38 Z M6.5 7.5 a1 1 0 1 0 2 0 a1 1 0 1 0 -2 0 Z"/></svg>`,
    compassLarge: `<svg viewBox="0 0 17 17" width="17" height="17" fill="none" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="8.32" cy="8.71" r="6.35" fill="none"/><path fill="currentColor" fill-rule="evenodd" stroke-width="0.5" d="M11.5 5.53 L9.63 10.02 L5.14 11.89 L7.01 7.4 Z M7.25 8.71 a1.07 1.07 0 1 0 2.14 0 a1.07 1.07 0 1 0 -2.14 0 Z"/></svg>`,
    eye: `<svg viewBox="0 0 21 13" width="21" height="13" fill="none" stroke="currentColor" stroke-width="1.06" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2.05 6.56 C2.25 5.06 5.9 1.62 10.15 1.62 C14.4 1.62 18.06 5.06 18.26 6.56 C18.06 8.06 14.4 11.5 10.15 11.5 C5.9 11.5 2.25 8.06 2.05 6.56 Z"/><path fill="currentColor" stroke="none" fill-rule="evenodd" d="M6.62 6.53 a3.55 3.55 0 1 0 7.1 0 a3.55 3.55 0 1 0 -7.1 0 Z M8.98 6.53 a1.19 1.19 0 1 0 2.38 0 a1.19 1.19 0 1 0 -2.38 0 Z"/></svg>`,
    xCircle: `<svg viewBox="0 0 15 15" width="15" height="15" fill="none" stroke="currentColor" stroke-width="1.15" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="7.5" cy="7.5" r="5.925"/><path d="M5.45 5.45 L9.55 9.55 M9.55 5.45 L5.45 9.55"/></svg>`,
    copy: `<svg viewBox="0 0 15 17" width="15" height="17" fill="none" stroke="currentColor" stroke-width="1.0" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4.85 4.75 V3.35 A1.6 1.6 0 0 1 6.45 1.75 H8.85 L13.1 6 V10.9 A1.6 1.6 0 0 1 11.5 12.5 H10.25"/><path d="M8.85 1.75 V5.3 Q8.85 6 9.55 6 H13.1"/><path d="M3.6 4.75 H6 L10.25 9 V13.9 A1.6 1.6 0 0 1 8.65 15.5 H3.6 A1.6 1.6 0 0 1 2 13.9 V6.35 A1.6 1.6 0 0 1 3.6 4.75 Z"/><path d="M6 4.75 V8.3 Q6 9 6.7 9 H10.25"/></svg>`,
    check: `<svg viewBox="0 0 14 13" width="14" height="13" fill="none" stroke="currentColor" stroke-width="1.1" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2.15 7.7 L5.46 11.42 L11.03 2.5"/></svg>`,
    link: `<svg viewBox="0 0 15 15" width="15" height="15" fill="none" stroke="currentColor" stroke-width="0.94" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><g transform="rotate(-45 7.5 7.5) translate(7.5 7.5)"><path d="M1.66 2.75 H3.15 A2.75 2.75 0 0 0 3.15 -2.75 H0.49 A2.75 2.75 0 0 0 -2.01 1.15"/><path d="M-2.63 -2.75 H-4.12 A2.75 2.75 0 0 0 -4.12 2.75 H-1.46 A2.75 2.75 0 0 0 1.04 -1.15"/></g></svg>`,
    external: `<svg viewBox="0 0 16 15" width="16" height="15" fill="none" stroke="currentColor" stroke-width="1.25" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="2.38" y="2.63" width="10.75" height="10.5" rx="1.5"/><path d="M6.9 5.88 H9.78 V8.8 M9.78 5.88 L5.75 9.9" stroke-width="1.05"/></svg>`,
    lines: `<svg viewBox="0 0 18 15" width="18" height="15" fill="none" stroke="currentColor" stroke-width="1.25" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2.38 2.38 H15.19 M2.38 5.94 H10.13 M2.38 9.53 H15.19 M2.38 13.13 H10.13"/></svg>`,
    bell: `<svg viewBox="0 0 14 15" width="14" height="15" fill="currentColor" aria-hidden="true"><circle cx="6.78" cy="2.7" r="1.15"/><path d="M6.78 3.2 C4.6 3.2 2.85 4.6 2.85 7.2 V8.6 C2.85 9.6 2 10.2 1.4 10.7 C1.05 11 1.2 11.75 1.75 11.75 H11.8 C12.35 11.75 12.5 11 12.15 10.7 C11.55 10.2 10.7 9.6 10.7 8.6 V7.2 C10.7 4.6 8.95 3.2 6.78 3.2 Z"/><path d="M5.03 12.2 H8.53 A1.75 1.75 0 0 1 5.03 12.2 Z"/></svg>`,
    menubar: `<svg viewBox="0 0 17 13" width="17" height="13" fill="none" stroke="currentColor" stroke-width="1.0" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="2" y="1.72" width="12.8" height="9.81" rx="2.3"/><path d="M2.1 3.6 H14.7" stroke-width="0.85"/></svg>`,
    star: `<svg viewBox="0 0 16 15" width="16" height="15" fill="none" stroke="currentColor" stroke-width="1.0" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M7.5 1.9 L9.13 5.96 L13.49 6.25 L10.13 9.06 L11.2 13.3 L7.5 10.97 L3.8 13.3 L4.87 9.06 L1.51 6.25 L5.87 5.96 Z"/></svg>`,
    bubble: `<svg viewBox="0 0 16 15" width="16" height="15" fill="none" stroke="currentColor" stroke-width="0.94" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4.9 11.25 H3.97 A2 2 0 0 1 1.97 9.25 V4.35 A2 2 0 0 1 3.97 2.35 H11.97 A2 2 0 0 1 13.97 4.35 V9.25 A2 2 0 0 1 11.97 11.25 H7.25 L4.9 13.6 Z"/><path d="M7.97 4.28 V7.34" stroke-width="1.06"/><circle cx="7.94" cy="9.16" r="0.62" fill="currentColor" stroke="none"/></svg>`,
    arrowUpRight: `<svg viewBox="0 0 10 10" width="10" height="10" fill="none" stroke="currentColor" stroke-width="1.0" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3.19 1.5 H8.06 V7.13 M1.96 8.5 L8.06 1.45"/></svg>`,
    logOut: `<svg viewBox="0 0 18 16" width="18" height="16" fill="none" stroke="currentColor" stroke-width="1.0" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M11.85 5.81 V3.29 A1.6 1.6 0 0 0 10.25 1.69 H3.6 A1.6 1.6 0 0 0 2 3.29 V12.9 A1.6 1.6 0 0 0 3.6 14.5 H10.25 A1.6 1.6 0 0 0 11.85 12.9 V10.38"/><path d="M7.56 8.06 H15.94 M13.6 5.72 L15.94 8.06 L13.6 10.4"/></svg>`,
    power: `<svg viewBox="0 0 15 15" width="15" height="15" fill="none" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M10.88 4.15 A5.42 5.42 0 1 1 3.22 4.15"/><path d="M7.1 2.16 V7.34"/></svg>`,
    lock: `<svg viewBox="0 0 10 12" width="10" height="12" fill="currentColor" aria-hidden="true"><path d="M2.5 5.8 V4.14 A2.08 2.08 0 0 1 6.66 4.14 V5.8" fill="none" stroke="currentColor" stroke-width="0.8"/><rect x="1.25" y="5.55" width="6.69" height="5.7" rx="0.85"/></svg>`,
    key: `<svg viewBox="0 0 18 28" width="18" height="28" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M6.5 14.18 A6.25 6.25 0 1 1 10.44 14.37 V14.54 L12.98 17.08 Q13.23 17.33 12.98 17.58 L10.44 20.12 V20.47 L12.27 22.3 Q12.52 22.55 12.27 22.8 L8.75 26.31 L6.5 24.06 Z M7.1 6.25 a1.65 1.65 0 1 0 3.3 0 a1.65 1.65 0 1 0 -3.3 0 Z"/></svg>`,
    box: `<svg viewBox="0 0 30 30" width="30" height="30" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M13.56 3.67 Q14.88 2.95 16.19 3.67 L24.56 8.28 Q25.88 9 25.88 10.5 L25.88 19.4 Q25.88 20.9 24.58 21.65 L16.17 26.5 Q14.88 27.25 13.58 26.5 L5.17 21.65 Q3.88 20.9 3.88 19.4 L3.88 10.5 Q3.88 9 5.19 8.28 Z"/><path d="M3.875 9 L14.875 15.05 L25.875 9 M14.875 15.05 V26.9 M9.375 5.975 L20.375 12.025"/></svg>`,
    triangle: `<svg viewBox="0 0 16 14" width="16" height="14" fill="currentColor" aria-hidden="true"><path d="M8 0 L16 14 H0 Z"/></svg>`,
    upDown: `<svg viewBox="0 0 9 11" width="9" height="11" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M1.25 3.9 L4.5 1 L7.75 3.9 M1.25 7.1 L4.5 10 L7.75 7.1"/></svg>`,
    battery: `<svg viewBox="0 0 26 13" width="26" height="13" fill="currentColor" aria-hidden="true"><rect x="2.37" y="2.38" width="18.13" height="8.75" rx="2.48" fill="none" stroke="currentColor" stroke-width="1.2"/><rect x="3.78" y="3.85" width="15.25" height="5.87" rx="0.96"/><path d="M22.03 4.97 H22.2 A1.2 1.81 0 0 1 22.2 8.6 H22.03 Z"/></svg>`,
    wifi: `<svg viewBox="0 0 20 16" width="20" height="16" fill="currentColor" aria-hidden="true"><path d="M2.75 5.74 A10.56 11.46 0 0 1 16.81 5.74" fill="none" stroke="currentColor" stroke-width="2.34" stroke-linecap="round"/><path d="M5.77 8.99 A6.4 6.81 0 0 1 13.79 8.99" fill="none" stroke="currentColor" stroke-width="2.43" stroke-linecap="round"/><path d="M9.78 14.34 L7.81 12.19 A2.91 2.91 0 0 1 11.75 12.19 Z" stroke="currentColor" stroke-width="0.91" stroke-linejoin="round"/></svg>`,
    search: `<svg viewBox="0 0 18 18" width="18" height="18" fill="none" stroke="currentColor" aria-hidden="true"><ellipse cx="7.6" cy="7.55" rx="5.22" ry="5.59" stroke-width="1.3"/><path d="M11.48 11.83 L15.19 15.84" stroke-width="1.8" stroke-linecap="round"/></svg>`,
    controls: `<svg viewBox="0 0 18 17" width="18" height="17" fill="currentColor" aria-hidden="true"><rect x="2.29" y="2.51" width="12.87" height="5.51" rx="2.76" fill="none" stroke="currentColor" stroke-width="1.13"/><rect x="3.4" y="3.53" width="5.71" height="3.49" rx="1.75"/><path fill-rule="evenodd" d="M4.76 9.72 H12.7 A3.03 3.03 0 0 1 12.7 15.77 H4.76 A3.03 3.03 0 0 1 4.76 9.72 Z M10.38 10.85 H12.8 A1.88 1.88 0 0 1 12.8 14.6 H10.38 A1.88 1.88 0 0 1 10.38 10.85 Z"/></svg>`,
  };

  // The macOS spinner: eight spokes, darkest at the front. demo.css turns it
  // one spoke every 0.1 s.
  const SPINNER = (() => {
    const fades = [1, 0.15, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875];
    const spokes = fades.map((opacity, i) => {
      const angle = (i * Math.PI) / 4;
      const at = (r) => `${(8 + Math.sin(angle) * r).toFixed(2)} ${(8 - Math.cos(angle) * r).toFixed(2)}`;
      return `<path d="M${at(3.63)} L${at(7.25)}" stroke-opacity="${opacity}"/>`;
    });
    return `<svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" aria-hidden="true">${spokes.join("")}</svg>`;
  })();

  // MARK: - Motion: the app's SwiftUI curves

  const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");

  // SwiftUI's spring(response:dampingFraction:) from rest, by time in seconds.
  function springAt(response, damping) {
    const w0 = (2 * Math.PI) / response;
    if (damping >= 1) return (t) => 1 - (1 + w0 * t) * Math.exp(-w0 * t);
    const wd = w0 * Math.sqrt(1 - damping * damping);
    return (t) => 1 - Math.exp(-damping * w0 * t) * (Math.cos(wd * t) + ((damping * w0) / wd) * Math.sin(wd * t));
  }

  // cubic-bezier() by progress, for motion driven from script.
  function bezier(x1, y1, x2, y2) {
    const along = (a, b, t) => 3 * a * (1 - t) * (1 - t) * t + 3 * b * (1 - t) * t * t + t * t * t;
    const slope = (a, b, t) => 3 * a * (1 - t) * (1 - t) + 6 * (b - a) * (1 - t) * t + 3 * (1 - b) * t * t;
    return (x) => {
      if (x <= 0) return 0;
      if (x >= 1) return 1;
      let t = x;
      for (let i = 0; i < 8; i++) {
        const miss = along(x1, x2, t) - x;
        const d = slope(x1, x2, t);
        if (Math.abs(miss) < 1e-5 || Math.abs(d) < 1e-6) break;
        t = Math.min(1, Math.max(0, t - miss / d));
      }
      return along(y1, y2, t);
    };
  }

  // Curves for script-driven motion: how long, and how far along at a time.
  const easeOutCurve = bezier(0, 0, 0.58, 1);
  const easeOut = (seconds) => ({ seconds, at: (t) => easeOutCurve(t / seconds) });
  const SPRING = { seconds: 0.5, at: springAt(0.3, 0.85) };

  // A spring for CSS and the Web Animations API: sampled every 10 ms until it
  // settles, or `fallback` in browsers without linear().
  function springEasing(response, damping, fallback) {
    const at = springAt(response, damping);
    let steps = 300;
    while (steps > 1 && Math.abs(1 - at((steps - 1) / 100)) < 0.002) steps--;
    const samples = [];
    for (let i = 0; i < steps; i++) samples.push(+at(i / 100).toFixed(4));
    const easing = `linear(${samples.join(", ")}, 1)`;
    return window.CSS && CSS.supports("transition-timing-function", easing) ? { duration: steps * 10, easing } : fallback;
  }

  // SwiftUI's default animation, a gentle spring.
  const smooth = springEasing(0.55, 1, { duration: 400, easing: "cubic-bezier(0.25, 0.1, 0.25, 1)" });
  demo.style.setProperty("--d-smooth", `${smooth.duration}ms ${smooth.easing}`);

  // The popover springs out of its arrow with a little bounce, and back in
  // without one.
  const POP_OPEN = springEasing(0.32, 0.72, { duration: 350, easing: "cubic-bezier(0.34, 1.3, 0.64, 1)" });
  const POP_CLOSE = springEasing(0.26, 1, { duration: 250, easing: "cubic-bezier(0.25, 0.1, 0.25, 1)" });

  // MARK: - Sample data (the app's DemoData, plus two more accounts)

  const SECOND = 1000;
  const MINUTE = 60 * SECOND;
  const HOUR = 60 * MINUTE;
  const DAY = 24 * HOUR;
  const loadedAt = Date.now();

  const TEAMS = [
    { id: "acme", name: "Acme" },
    { id: "acme-labs", name: "Acme Labs" },
  ];
  const ORG = { acme: "acme", "acme-labs": "acme-labs", personal: "alexrivera" };

  const deployments = [];
  const add = (team, project, state, production, branch, message, hash, ago) =>
    deployments.push({ id: hash, hash, team, project, state, production, branch, message, created: loadedAt - ago });

  add("acme", "marketing-site", "queued", false, "copy/pricing-page", "Tighten the pricing page copy", "b81e4d2c9", 40 * SECOND);
  add("acme", "storefront", "building", true, "main", "Add express checkout for returning customers", "4f9c2ab17", 83 * SECOND);
  add("acme", "docs", "ready", true, "main", "Document the new webhooks API", "e3a07f5d1", 6 * MINUTE);
  add("acme", "storefront", "ready", false, "feat/gift-cards", "Show gift card balance on the account page", "9d2b6c0e4", 18 * MINUTE);
  add("acme", "dashboard", "error", false, "fix/chart-tooltips", "Fix tooltip overflow on small charts", "17c5e9a3f", 34 * MINUTE);
  add("acme", "api", "ready", true, "main", "Rate limit the search endpoint", "c64f1b8a0", 72 * MINUTE);
  add("acme", "storefront", "ready", true, "main", "Cache product images at the edge", "a5d83e7b2", 2 * HOUR);
  add("acme", "dashboard", "canceled", false, "feat/onboarding", "WIP: new onboarding checklist", "6e0a4c9d5", 3 * HOUR);
  add("acme", "docs", "ready", true, "main", "Fix broken links in the CLI guide", "f2b97d1c6", 5 * HOUR);
  add("acme", "marketing-site", "ready", true, "main", "Launch the customer stories page", "3c8e5a2f7", 26 * HOUR);
  add("acme-labs", "design-system", "ready", true, "main", "Add the new color tokens", "5a1c9e3d7", 12 * MINUTE);
  add("acme-labs", "playground", "ready", false, "feat/streaming", "Stream responses as they arrive", "0e7b4f2a6", 47 * MINUTE);
  add("acme-labs", "design-system", "error", false, "fix/focus-rings", "Restore visible focus rings", "d93f6a1b8", 3 * HOUR);
  add("personal", "blog", "ready", true, "main", "Write up the move to edge functions", "7c2d8e4f1", 25 * MINUTE);
  add("personal", "portfolio", "ready", true, "main", "Update the projects page", "2b6f9a0c3", 2 * DAY);

  const STATES = {
    queued: { label: "Queued", color: "var(--d-queued)", inProgress: true },
    building: { label: "Building", color: "var(--d-warning)", inProgress: true },
    ready: { label: "Ready", color: "var(--d-success)" },
    error: { label: "Error", color: "var(--d-error)" },
    canceled: { label: "Canceled", color: "var(--d-queued)" },
  };

  const state = {
    open: true,
    signedIn: true,
    loginStep: "start",
    view: "list",
    detailId: null,
    team: "acme",
    project: null,
    busy: false,
    settings: { notifications: true, failure: true, success: false, dynamicIcon: true },
  };

  // MARK: - Helpers

  const esc = (text) =>
    String(text).replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c]);
  const byId = (id) => deployments.find((d) => d.id === id);
  const teamName = () => (TEAMS.find((t) => t.id === state.team) || { name: "Personal" }).name;
  const ofTeam = () => deployments.filter((d) => d.team === state.team).sort((a, b) => b.created - a.created);
  const visible = () => ofTeam().filter((d) => !state.project || d.project === state.project);
  const projects = () => [...new Set(ofTeam().map((d) => d.project))].sort();
  const domain = (d) => `${d.project}-${d.hash}-${ORG[d.team]}.vercel.app`;
  const inspector = (d) => `vercel.com/${ORG[d.team]}/${d.project}/${d.hash}`;
  const after = (ms, fn) => setTimeout(fn, ms);

  // The newest ready production deployment of each project is the live one.
  function currentIds() {
    const seen = new Set();
    const ids = new Set();
    for (const d of visible()) {
      if (d.production && d.state === "ready" && !seen.has(d.project)) {
        seen.add(d.project);
        ids.add(d.id);
      }
    }
    return ids;
  }

  function ago(time) {
    const s = Math.max(1, Math.round((Date.now() - time) / SECOND));
    if (s < 60) return `${s}s ago`;
    const m = Math.floor(s / 60);
    if (m < 60) return `${m}m ago`;
    const h = Math.floor(m / 60);
    if (h < 24) return `${h}h ago`;
    return `${Math.floor(h / 24)}d ago`;
  }

  function elapsed(time) {
    const s = Math.max(0, Math.floor((Date.now() - time) / SECOND));
    return `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;
  }

  // As the app's DateFormatter writes it: "Oct 28, 2026 at 11:22 AM".
  const dateFormat = new Intl.DateTimeFormat(undefined, { dateStyle: "medium" });
  const timeFormat = new Intl.DateTimeFormat(undefined, { timeStyle: "short" });
  const createdText = (time) => `${dateFormat.format(time)} at ${timeFormat.format(time)}`;
  const clockFormat = new Intl.DateTimeFormat(undefined, { weekday: "short", hour: "numeric", minute: "2-digit" });

  // MARK: - Frame

  demo.innerHTML = `
    <div class="d-menubar">
      <button class="d-mb-item d-mb-app is-open" data-action="toggle" aria-label="Vercelian" aria-expanded="true">${ICON.triangle}</button>
      <span class="d-mb-item d-mb-optional">${ICON.battery}</span>
      <span class="d-mb-item">${ICON.wifi}</span>
      <span class="d-mb-item d-mb-optional">${ICON.search}</span>
      <span class="d-mb-item d-mb-optional">${ICON.controls}</span>
      <span class="d-mb-clock"></span>
    </div>
    <div class="d-hint" hidden>Vercelian lives in your menu bar. Click the triangle to open it.</div>
    <div class="d-popover" role="dialog" aria-label="Vercelian">
      <svg class="d-frame" aria-hidden="true"><path/></svg>
      <div class="d-body"><div class="d-app"></div></div>
      <svg class="d-frame-edge" aria-hidden="true"><clipPath id="d-frame-clip"><path/></clipPath><path clip-path="url(#d-frame-clip)"/></svg>
    </div>
    <div class="d-toast is-hidden" role="status" aria-live="polite"></div>`;

  const appButton = demo.querySelector(".d-mb-app");
  const clock = demo.querySelector(".d-mb-clock");
  const hint = demo.querySelector(".d-hint");
  const popover = demo.querySelector(".d-popover");
  const body = demo.querySelector(".d-body");
  const app = demo.querySelector(".d-app");
  const toastEl = demo.querySelector(".d-toast");
  let list;
  let stage;
  let pager;
  let detail;
  let badge;
  let settingsPane;
  let settingsButton;
  let teamLabel;
  let projectLabel;
  let spinner;

  // The popover's outline, its arrow included, so the edge and the shadow run
  // round the arrow as they do in macOS: 20 pt corners, and an arrow with 45°
  // sides, a rounded tip, and soft shoulders.
  const ARROW = 12; // room above the body for the arrow
  function framePath(w, h, ax) {
    const R = 20;
    const t = ARROW;
    const n = (v) => Math.round(v * 100) / 100;
    return [
      `M${R} ${t}`,
      `H${n(ax - 14.24)}`,
      `A3 3 0 0 0 ${n(ax - 12.12)} ${n(t - 0.88)}`,
      `L${n(ax - 3.75)} ${n(t - 9.25)}`,
      `A5.3 5.3 0 0 1 ${n(ax + 3.75)} ${n(t - 9.25)}`,
      `L${n(ax + 12.12)} ${n(t - 0.88)}`,
      `A3 3 0 0 0 ${n(ax + 14.24)} ${t}`,
      `H${w - R}`,
      `A${R} ${R} 0 0 1 ${w} ${t + R}`,
      `V${t + h - R}`,
      `A${R} ${R} 0 0 1 ${w - R} ${t + h}`,
      `H${R}`,
      `A${R} ${R} 0 0 1 0 ${t + h - R}`,
      `V${t + R}`,
      `A${R} ${R} 0 0 1 ${R} ${t}`,
      "Z",
    ].join(" ");
  }

  // Keeps the popover under its menu bar item, inside the frame, on whole
  // pixels so its text stays sharp.
  function position() {
    const frame = demo.getBoundingClientRect();
    const item = appButton.getBoundingClientRect();
    const width = Math.min(380, demo.clientWidth - 16);
    const height = popover.offsetHeight;
    const center = Math.round(item.left - frame.left - demo.clientLeft + item.width / 2);
    const left = Math.max(8, Math.min(demo.clientWidth - width - 8, center - Math.round(width / 2)));
    const arrow = Math.max(36, Math.min(width - 36, center - left));
    popover.style.width = `${width}px`;
    popover.style.left = `${left}px`;
    popover.style.transformOrigin = `${arrow}px ${1.2 - ARROW}px`;
    const path = framePath(width, height, arrow);
    for (const svg of popover.querySelectorAll("svg.d-frame, svg.d-frame-edge")) {
      svg.setAttribute("viewBox", `0 0 ${width} ${height + ARROW}`);
      for (const p of svg.querySelectorAll("path")) p.setAttribute("d", path);
    }
  }

  // The popover grows out of its arrow, and shrinks back into it. Turned
  // round on its way, it carries on from where it is.
  function setOpen(open) {
    if (state.open === open) return;
    state.open = open;
    appButton.classList.toggle("is-open", open);
    appButton.setAttribute("aria-expanded", String(open));
    hint.hidden = open;
    if (!open) {
      closeMenu(true);
      closeSwipe();
    }
    const moving = popover.getAnimations().length > 0;
    const look = getComputedStyle(popover);
    const scale = moving ? new DOMMatrixReadOnly(look.transform).a : open ? 0.2 : 1;
    const opacity = moving ? Number(look.opacity) : open ? 0 : 1;
    for (const animation of popover.getAnimations()) animation.cancel();
    popover.classList.remove("is-closed");
    if (reducedMotion.matches) {
      popover.classList.toggle("is-closed", !open);
      return;
    }
    const grow = popover.animate([{ transform: `scale(${scale})` }, { transform: `scale(${open ? 1 : 0.05})` }], {
      ...(open ? POP_OPEN : POP_CLOSE),
      fill: "forwards",
    });
    popover.animate([{ opacity }, { opacity: open ? 1 : 0 }], { duration: open ? 90 : 150, fill: "forwards" });
    grow.finished
      .then(() => {
        if (!open) popover.classList.add("is-closed");
        for (const animation of popover.getAnimations()) animation.cancel();
      })
      .catch(() => {});
  }

  function updateMenuBarIcon() {
    const top = state.signedIn ? visible()[0] : null;
    let look = "normal";
    if (state.settings.dynamicIcon && top) {
      if (STATES[top.state].inProgress) look = "building";
      else if (top.state === "error") look = "error";
    }
    appButton.dataset.state = look;
  }

  // MARK: - Signed in

  function renderApp() {
    if (!state.signedIn) return renderLogin();
    app.className = "d-app";
    app.removeAttribute("style");
    app.dataset.page = "";
    app.innerHTML = `
      <div class="d-header">
        <span class="d-brand">
          <span class="d-wordmark" role="img" aria-label="Vercelian">${WORDMARK}</span>
          <span class="d-spinner" hidden>${SPINNER}</span>
        </span>
        <span class="d-spacer"></span>
        <button class="d-icon-btn" data-action="refresh" aria-label="Refresh">${ICON.refresh}</button>
        <button class="d-icon-btn" data-action="settings" aria-label="Settings">${ICON.gear}</button>
      </div>
      <div class="d-divider"></div>
      <div class="d-stage">
        <div class="d-stage-track">
          <div class="d-main">
            <div class="d-sub">
              <div class="d-sub-list">
                <button class="d-picker" data-action="team-menu" aria-haspopup="menu">${ICON.people}<span data-team></span>${ICON.chevronDown}</button>
                <button class="d-picker" data-action="project-menu" aria-haspopup="menu">${ICON.folder}<span data-project></span>${ICON.chevronDown}</button>
              </div>
              <div class="d-sub-detail">
                <button class="d-back" data-action="back">${ICON.chevronLeft}<span>Back</span></button>
                <span class="d-badge-status"></span>
              </div>
            </div>
            <div class="d-divider"></div>
            <div class="d-content">
              <div class="d-list-layer"><div class="d-list" role="list" aria-label="Deployments"></div></div>
              <div class="d-detail-layer">
                <div class="d-pager"><div class="d-pager-gap"></div><div class="d-pager-page"><div class="d-scroll"></div></div></div>
              </div>
            </div>
          </div>
          <div class="d-settings"><div class="d-scroll d-settings-scroll"></div></div>
        </div>
      </div>`;
    list = app.querySelector(".d-list");
    stage = app.querySelector(".d-stage");
    pager = app.querySelector(".d-detail-layer");
    detail = pager.querySelector(".d-scroll");
    badge = app.querySelector(".d-badge-status");
    settingsPane = app.querySelector(".d-settings .d-scroll");
    settingsButton = app.querySelector('[data-action="settings"]');
    teamLabel = app.querySelector("[data-team]");
    projectLabel = app.querySelector("[data-project]");
    spinner = app.querySelector(".d-spinner");
    swipe.wrap = null;
    bindList();
    bindPages();
    renderList();
    updateMenuBarIcon();
  }

  function renderPickers() {
    if (!list) return;
    teamLabel.textContent = teamName();
    projectLabel.textContent = state.project || "All Projects";
  }

  // Rows are updated in place, so one that is open, or being swiped, stays
  // where it is while the list changes around it.
  function renderList() {
    if (!list) return;
    renderPickers();
    const items = visible();
    if (!items.length) {
      swipe.wrap = null;
      list.innerHTML = `
        <div class="d-empty">
          <span class="d-empty-icon">${ICON.box}</span>
          <strong>No deployments</strong>
          ${state.project ? "<span>for this project</span>" : ""}
        </div>`;
      return;
    }
    list.querySelector(".d-empty")?.remove();
    const current = currentIds();
    const existing = new Map([...list.querySelectorAll(".d-row-wrap")].map((wrap) => [wrap.dataset.id, wrap]));
    let cursor = list.firstElementChild;
    for (const d of items) {
      const wrap = existing.get(d.id) || createRow(d.id);
      existing.delete(d.id);
      fillRow(wrap, d, current.has(d.id));
      if (wrap === cursor) cursor = cursor.nextElementSibling;
      else {
        // Moving a row resets its scroller without a scroll event, so draw
        // and settle it here, as for a new one.
        list.insertBefore(wrap, cursor);
        drawRow(wrap);
        settleRow(wrap);
      }
    }
    for (const stale of existing.values()) stale.remove();
    if (swipe.wrap && !swipe.wrap.isConnected) swipe.wrap = null;
  }

  // A row is a sideways scroller: the browser tracks the swipe, and the row
  // and its actions are drawn from how far it has scrolled (see drawRow).
  function createRow(id) {
    const wrap = document.createElement("div");
    wrap.className = "d-row-wrap";
    wrap.dataset.id = id;
    wrap.setAttribute("role", "listitem");
    wrap.innerHTML = `
      <div class="d-row-track">
        <div class="d-row-stage">
          <button class="d-swipe-btn" data-action="visit" tabindex="-1">${ICON.compassLarge}<span>Visit</span></button>
          <button class="d-swipe-btn" data-action="inspect" tabindex="-1">${ICON.external}<span>Deployment</span></button>
          <button class="d-swipe-btn" data-action="logs" tabindex="-1">${ICON.lines}<span>Logs</span></button>
          <div class="d-row" tabindex="0" role="button"></div>
        </div>
        <i class="d-row-snap"></i><i class="d-row-snap"></i><i class="d-row-snap"></i>
      </div>`;
    wrap.row = wrap.querySelector(".d-row");
    wrap.cards = [...wrap.querySelectorAll(".d-swipe-btn")];
    return wrap;
  }

  function fillRow(wrap, d, isCurrent) {
    const s = STATES[d.state];
    const timing =
      d.state === "building"
        ? `<span class="d-elapsed">${ICON.clock}<span data-elapsed="${d.created}">${elapsed(d.created)}</span></span>`
        : `<span class="d-ago" data-ago="${d.created}">${ago(d.created)}</span>`;
    const tag = isCurrent
      ? '<span class="d-tag" style="--c: var(--d-success)"><i></i>Current</span>'
      : d.production
        ? '<span class="d-tag" style="--c: var(--d-blue)">Production</span>'
        : "";
    const key = `${d.state}|${isCurrent}|${d.created}`;
    if (wrap.key === key) return;
    wrap.key = key;
    // No aria-label: the row's text names it, so the name always matches
    // what's on screen, including the time as it ticks.
    wrap.row.innerHTML = `
      <span class="d-status" style="--c: ${s.color}">${s.inProgress ? "<i></i>" : ""}<i></i></span>
      <span class="d-info">
        <span class="d-line"><span class="d-name">${esc(d.project)}</span><span class="d-branch">${BRANCH}<span>${esc(d.branch)}</span></span></span>
        <span class="d-msg">${esc(d.message)}</span>
        <span class="d-line d-meta">${timing}<span class="d-dot">•</span><span class="d-state" style="--c: ${s.color}">${s.label}</span></span>
      </span>
      ${tag}
      <span class="d-chevron">${ICON.chevronRight}</span>`;
  }

  function renderDetail() {
    const d = byId(state.detailId);
    if (!d || !detail) return;
    const s = STATES[d.state];
    const current = currentIds().has(d.id);
    const env = current ? "var(--d-success)" : d.production ? "var(--d-blue)" : "var(--d-fg-3)";
    const busy = state.busy ? `<span class="d-btn-spinner">${SPINNER}</span>` : "";
    badge.style.setProperty("--c", s.color);
    badge.classList.toggle("is-live", Boolean(s.inProgress));
    badge.innerHTML = `<i></i>${s.label}`;
    detail.innerHTML = `
      <div class="d-section"><div class="d-label">Project</div><div class="d-value d-value-lg">${esc(d.project)}</div></div>
      <div class="d-section">
        <div class="d-label">URL</div>
        <div class="d-value d-url">
          <button class="d-link" data-action="visit"><span>${esc(domain(d))}</span></button>
          <button class="d-copy" data-action="copy" aria-label="Copy URL"><span class="d-copy-idle">${ICON.copy}</span><span class="d-copy-done">${ICON.check}</span></button>
        </div>
      </div>
      <div class="d-section"><div class="d-label">Branch</div><div class="d-value"><span class="d-branch-icon">${BRANCH}</span>${esc(d.branch)}</div></div>
      <div class="d-section"><div class="d-label">Commit</div><div class="d-commit">${esc(d.message)}</div><span class="d-sha">${d.hash.slice(0, 7)}</span></div>
      <div class="d-section"><div class="d-label">Repository</div><div class="d-value"><button class="d-link" data-action="repo">${ICON.link}<span>${ORG[d.team]}/${esc(d.project)}</span></button></div></div>
      <div class="d-section"><div class="d-label">Environment</div><div class="d-value d-env"><i class="d-env-dot" style="--c: ${env}"></i>${d.production ? "Production" : "Preview"}${current ? '<span class="d-live">Live</span>' : ""}</div></div>
      <div class="d-section"><div class="d-label">Created</div><div class="d-value">${esc(createdText(d.created))}</div></div>
      <div class="d-actions-block">
        <button class="d-btn d-btn-secondary" data-action="visit">${ICON.compass}<span>Open in Browser</span></button>
        <button class="d-btn d-btn-secondary" data-action="inspect">${ICON.eye}<span>View on Vercel</span></button>
        <div class="d-btn-row">
          ${s.inProgress ? `<button class="d-btn d-btn-danger" data-action="cancel"${state.busy ? " disabled" : ""}>${busy || ICON.xCircle}<span>Cancel</span></button>` : ""}
          <button class="d-btn d-btn-primary" data-action="redeploy"${state.busy ? " disabled" : ""}>${busy || ICON.refreshSmall}<span>Redeploy</span></button>
        </div>
      </div>`;
  }

  function renderSettings() {
    const st = state.settings;
    const toggle = (key, label) =>
      `<button class="d-switch" role="switch" aria-checked="${st[key]}" aria-label="${label}" data-action="setting" data-key="${key}"></button>`;
    const row = (key, lead, title) => `<div class="d-card-row">${lead}<span class="d-grow">${title}</span>${toggle(key, title)}</div>`;
    const dot = (color) => `<i class="d-dot-8" style="--c: ${color}"></i>`;
    settingsPane.innerHTML = `
      <section class="d-set">
        <div class="d-label">Account</div>
        <div class="d-card">
          <div class="d-card-row d-account">
            <span class="d-avatar">A</span>
            <span class="d-grow"><span class="d-account-name">Alex Rivera</span><span class="d-account-email">alex@example.com</span></span>
          </div>
        </div>
      </section>
      <section class="d-set">
        <div class="d-label">Team</div>
        <div class="d-card d-card-pad">
          <p class="d-note">Select the team to monitor deployments from:</p>
          <div class="d-team-row">
            <span>Team</span>
            <button class="d-popup" data-action="settings-team-menu" aria-haspopup="menu"><span>${state.team === "personal" ? "Personal account" : teamName()}</span>${ICON.upDown}</button>
          </div>
        </div>
      </section>
      <section class="d-set">
        <div class="d-label">Notifications</div>
        <div class="d-card">
          ${row("notifications", ICON.bell, "Enable notifications")}
          <div class="d-collapse${st.notifications ? " is-open" : ""}"${st.notifications ? "" : " inert"}>
            <div>
              <hr>${row("failure", dot("var(--d-error)"), "Notify on failed deployments")}
              <hr>${row("success", dot("var(--d-success)"), "Notify on successful deployments")}
            </div>
          </div>
        </div>
      </section>
      <section class="d-set">
        <div class="d-label">Appearance</div>
        <div class="d-card">
          <div class="d-card-row">${ICON.menubar}<span class="d-grow"><span class="d-row-title">Dynamic menu bar icon</span><span class="d-card-sub">Icon changes color when building or on error</span></span>${toggle("dynamicIcon", "Dynamic menu bar icon")}</div>
        </div>
      </section>
      <section class="d-set">
        <div class="d-label">About</div>
        <div class="d-card">
          <div class="d-card-row"><span class="d-about-name">Vercelian</span><span class="d-version">v1.1.0</span></div>
          <hr>
          <button class="d-card-row" data-action="github">${ICON.star}<span class="d-grow">Star on GitHub</span><span class="d-ext">${ICON.arrowUpRight}</span></button>
          <hr>
          <button class="d-card-row" data-action="issues">${ICON.bubble}<span class="d-grow">Report an issue</span><span class="d-ext">${ICON.arrowUpRight}</span></button>
        </div>
      </section>
      <section class="d-set">
        <button class="d-btn d-btn-danger" data-action="sign-out">${ICON.logOut}<span>Sign out</span></button>
        <button class="d-btn d-btn-quiet" data-action="quit">${ICON.power}<span>Quit Vercelian</span></button>
        <p class="d-fine">Your access token is stored securely in macOS Keychain and will be removed when you sign out.</p>
      </section>`;
  }

  // MARK: - Sign in

  function renderLogin() {
    list = detail = null;
    app.className = "d-app";
    app.dataset.page = "";
    const start = state.loginStep === "start";
    app.innerHTML = `
      <div class="d-login">
        <span class="d-fill"></span>
        <div class="d-login-top">
          <span class="d-login-logo">${ICON.triangle}</span>
          <div class="d-login-title">Vercelian</div>
          <div class="d-login-sub">Monitor your Vercel deployments<br>from the menu bar</div>
        </div>
        <div class="d-login-body ${start ? "d-login-start" : "d-login-token"}">
          ${
            start
              ? `<button class="d-btn d-continue" data-action="continue">${ICON.triangle}<span>Continue with Vercel</span></button>
                 <div class="d-caption">Opens Vercel to create an access token</div>`
              : `<div class="d-token-head">
                   <span class="d-key">${ICON.key}</span>
                   <div class="d-token-title">Paste your access token</div>
                   <div class="d-caption">Create a token in the browser, then paste it here</div>
                 </div>
                 <input class="d-token" type="password" placeholder="Paste token here" autocomplete="off" spellcheck="false" aria-label="Access token">
                 <div class="d-btn-row"><button class="d-btn d-btn-secondary" data-action="login-cancel">Cancel</button><button class="d-btn d-btn-primary" data-action="connect" disabled><span>Connect</span></button></div>
                 <button class="d-text-link" data-action="token-page">Open Vercel token page</button>`
          }
        </div>
        <span class="d-fill"></span>
        <div class="d-login-foot">${ICON.lock}<span>Stored securely in macOS Keychain</span></div>
      </div>`;
    updateMenuBarIcon();
    const input = app.querySelector(".d-token");
    if (input) {
      const connect = app.querySelector('[data-action="connect"]');
      input.addEventListener("input", () => (connect.disabled = !input.value.trim()));
      input.addEventListener("keydown", (e) => {
        if (e.key === "Enter" && input.value.trim()) connectAccount(connect);
      });
      input.focus({ preventScroll: true });
    }
  }

  // The two sign-in steps swap with the app's easeInOut(0.2): the new step
  // fades in while the logo above it glides to its new place.
  function switchLoginStep(step) {
    const top = app.querySelector(".d-login-top");
    const before = top ? top.getBoundingClientRect().top : 0;
    state.loginStep = step;
    renderLogin();
    if (reducedMotion.matches) return;
    const timing = { duration: 200, easing: "cubic-bezier(0.42, 0, 0.58, 1)" };
    const moved = app.querySelector(".d-login-top");
    const shift = before - moved.getBoundingClientRect().top;
    if (shift) moved.animate([{ transform: `translateY(${shift}px)` }, { transform: "none" }], timing);
    app.querySelector(".d-login-body").animate([{ opacity: 0 }, { opacity: 1 }], timing);
  }

  function connectAccount(button) {
    button.disabled = true;
    button.classList.add("is-busy");
    button.innerHTML = `<span class="d-btn-spinner">${SPINNER}</span><span>Connecting...</span>`;
    after(900, () => {
      state.signedIn = true;
      state.loginStep = "start";
      state.view = "list";
      renderApp();
    });
  }

  // MARK: - Scrollers
  //
  // Swiping a row, or swiping back from a deployment or settings, is real
  // sideways scrolling, so the browser follows the fingers. Once a scroller
  // comes to rest, it settles by the app's rule for that gesture. Taps and
  // buttons move the same scrollers along the app's curves.

  const glides = new Map();

  // Moves `scroller` to `left` along `curve`. Any snapping waits until it's
  // done, or the browser would snap at every step.
  function glide(scroller, left, curve, done) {
    stopGlide(scroller);
    const from = scroller.scrollLeft;
    scroller.glideTo = left;
    scroller.style.scrollSnapType = "none";
    const finish = () => {
      scroller.scrollLeft = left;
      glides.delete(scroller);
      scroller.style.scrollSnapType = "";
      scroller.style.overflowX = "";
      if (done) done();
    };
    if (reducedMotion.matches || Math.abs(left - from) < 0.5) return finish();
    const start = performance.now();
    const step = (now) => {
      const t = (now - start) / 1000;
      if (t >= curve.seconds) return finish();
      scroller.scrollLeft = from + (left - from) * curve.at(t);
      glides.set(scroller, requestAnimationFrame(step));
    };
    glides.set(scroller, requestAnimationFrame(step));
  }

  function stopGlide(scroller) {
    if (!glides.has(scroller)) return;
    cancelAnimationFrame(glides.get(scroller));
    glides.delete(scroller);
    scroller.style.scrollSnapType = "";
    scroller.style.overflowX = "";
  }

  // When fingers last moved a scroller: a swipe, a touch, or a drag.
  function noteFingers(scroller) {
    scroller.fingersAt = performance.now();
  }

  // A touch going down or lifting. Once it lifts, whatever moves the
  // scroller next is momentum.
  function noteTouch(scroller, down) {
    scroller.touching = down;
    scroller.fingersAt = down ? performance.now() : 0;
  }

  // The app ignores a swipe's momentum and settles from wherever the fingers
  // lifted. Browsers carry on scrolling, so a scroller that moves after a
  // touch lifts, or after a pause in a swipe's events, has been let go: stop
  // it where it is and settle it. (Trackpads keep reporting momentum as if
  // fingers were on them; snapping and the rubber band's limit keep that in
  // check.)
  function letGo(scroller, settle) {
    if (glides.has(scroller) || scroller.touching || performance.now() - (scroller.fingersAt || 0) < 100) return;
    scroller.style.overflowX = "hidden";
    settle(scroller);
    if (!glides.has(scroller)) scroller.style.overflowX = "";
  }

  // Calls `settled(scroller)` once a scroller comes to rest: the fingers have
  // lifted and any momentum has run out. Fingers holding still mid-swipe
  // don't count, so only browsers without `scrollend` fall back on a pause.
  function whenSettled(target, settled, capture = false) {
    if ("onscrollend" in window) {
      target.addEventListener("scrollend", (e) => settled(e.target), { capture });
      return;
    }
    target.addEventListener(
      "scroll",
      (e) => {
        const scroller = e.target;
        clearTimeout(scroller.settleTimer);
        scroller.settleTimer = setTimeout(() => settled(scroller), 250);
      },
      { capture, passive: true },
    );
  }

  // A sideways swipe takes a scroller over from any glide it's in. The
  // swipe's own scrollend then settles it, but a swipe that doesn't move it
  // has none, so it settles anyway if it hasn't moved in half a second.
  function takeOver(scroller, settle) {
    if (!glides.has(scroller)) return;
    stopGlide(scroller);
    const left = scroller.scrollLeft;
    setTimeout(() => {
      if (!glides.has(scroller) && scroller.scrollLeft === left) settle(scroller);
    }, 500);
  }

  // Swipes and touches on a page's scroller: they take it over from a glide,
  // and once they stop moving it, it settles.
  function bindSwipes(scroller, settle) {
    scroller.addEventListener(
      "wheel",
      (e) => {
        noteFingers(scroller);
        if (Math.abs(e.deltaX) > Math.abs(e.deltaY)) takeOver(scroller, settle);
      },
      { passive: true },
    );
    scroller.addEventListener("touchstart", () => noteTouch(scroller, true), { passive: true });
    scroller.addEventListener("touchmove", () => noteFingers(scroller), { passive: true });
    scroller.addEventListener("touchend", () => noteTouch(scroller, false), { passive: true });
    scroller.addEventListener("touchcancel", () => noteTouch(scroller, false), { passive: true });
    scroller.addEventListener("scroll", () => letGo(scroller, settle), { passive: true });
  }

  // MARK: - Navigation
  //
  // A deployment's page slides in over the list with the app's easeOut(0.25),
  // pushing the list a third of the way along; settings push it all the way.
  // A two-finger swipe to the right drags either back, as on a trackpad in
  // the app, and letting go settles it by the app's rule: past 35% of the
  // way, back to the list; otherwise the page slides back in. Both take the
  // app's easeOut(0.2). The rule goes by where the page is, not where it was
  // headed, so a swipe that interrupts a slide still settles. --page tells
  // the list and the header how far in a deployment's page is.

  // Whether a page is on screen: shown, being swiped, or sliding in or out.
  const detailShown = () => app.dataset.page === "detail";
  const settingsShown = () => app.classList.contains("is-settings");

  function settlePager() {
    if (glides.has(pager) || !detailShown()) return;
    if (1 - pager.scrollLeft / (pager.clientWidth || 1) > 0.35) return back(easeOut(0.2));
    state.view = "detail";
    app.classList.add("is-detail");
    glide(pager, pager.clientWidth, easeOut(0.2));
  }

  function settleStage() {
    if (glides.has(stage) || !settingsShown()) return;
    if (1 - stage.scrollLeft / (stage.clientWidth || 1) > 0.35) return leaveSettings(easeOut(0.2));
    state.view = "settings";
    glide(stage, stage.clientWidth, easeOut(0.2));
  }

  function bindPages() {
    pager.addEventListener(
      "scroll",
      () => app.style.setProperty("--page", String(pager.scrollLeft / (pager.clientWidth || 1))),
      { passive: true },
    );
    whenSettled(pager, settlePager);
    whenSettled(stage, settleStage);
    bindSwipes(pager, settlePager);
    bindSwipes(stage, settleStage);
  }

  function showDetail(id) {
    closeSwipe();
    closeMenu(true);
    state.detailId = id;
    state.view = "detail";
    renderDetail();
    detail.scrollTop = 0;
    app.classList.add("is-detail");
    app.dataset.page = "detail";
    app.style.setProperty("--page", "0");
    stopGlide(pager);
    pager.scrollLeft = 0;
    glide(pager, pager.clientWidth, easeOut(0.25));
  }

  // The page stays drawn while it slides out, then the list takes over.
  function back(curve = easeOut(0.25)) {
    if (!detailShown()) return;
    state.view = "list";
    app.classList.remove("is-detail");
    glide(pager, 0, curve, () => {
      if (state.view !== "detail") app.dataset.page = "";
    });
  }

  function closeDetail() {
    state.view = "list";
    app.classList.remove("is-detail");
    app.dataset.page = "";
  }

  function setSettingsIcon(open) {
    settingsButton.innerHTML = open ? ICON.close : ICON.gear;
    settingsButton.setAttribute("aria-label", open ? "Close settings" : "Settings");
  }

  function toggleSettings() {
    closeMenu(true);
    closeSwipe();
    if (settingsShown()) return leaveSettings(easeOut(0.25));
    if (detailShown()) {
      // A deployment's page gives way at once, as in the app.
      stopGlide(pager);
      pager.scrollLeft = 0;
      app.style.setProperty("--page", "0");
      closeDetail();
    }
    state.view = "settings";
    renderSettings();
    settingsPane.scrollTop = 0;
    app.classList.add("is-settings");
    setSettingsIcon(true);
    glide(stage, stage.clientWidth, easeOut(0.25));
  }

  // Settings slide away, then the list takes over.
  function leaveSettings(curve) {
    state.view = "list";
    glide(stage, 0, curve, () => {
      if (state.view === "list") closeSettings();
    });
  }

  function closeSettings() {
    state.view = "list";
    app.classList.remove("is-settings");
    setSettingsIcon(false);
  }

  // MARK: - Swiping a row open
  //
  // One row at a time, as in the app: swiping a row shuts any other, and a
  // row opens only while it's the one being swiped.

  const ACTION_WIDTH = 72;
  const ACTION_COUNT = 3;
  const MAX_REVEAL = ACTION_WIDTH * ACTION_COUNT;
  // The row swiped last, the only one that may be open.
  const swipe = { wrap: null };
  // The row that last got a swipe, a drag, or a touch, and when.
  const input = { wrap: null, at: 0 };
  // A mouse dragging a row (see bindList).
  let drag = null;

  // Past the actions, the row resists like the app's rubber band: 10 pt of
  // pull moves it 3 pt at first, then less and less, but it never stops.
  function rubberBand(raw) {
    const offset = Math.min(0, raw);
    if (offset >= -MAX_REVEAL) return offset;
    const over = -offset - MAX_REVEAL;
    return -(MAX_REVEAL + (over * 0.3) / (1 + (over * 0.3) / MAX_REVEAL));
  }

  // The row slides as far as its scroller has scrolled, rubber band included,
  // and the actions fan out from under it like a deck of cards. Each card
  // tucks 1 pt under the row or the card before it, so no seam shows.
  function drawRow(wrap) {
    const revealed = -rubberBand(-wrap.scrollLeft);
    const width = Math.max(ACTION_WIDTH, revealed / ACTION_COUNT);
    wrap.row.style.transform = revealed ? `translateX(${-revealed}px)` : "";
    wrap.cards.forEach((card, i) => {
      card.style.width = `${width + 2}px`;
      card.style.transform = `translateX(${revealed * (i / ACTION_COUNT) - revealed - 1}px)`;
    });
  }

  // Once a row comes to rest, it settles shut or open. A swipe has already
  // snapped to one, by where and how fast the fingers lifted; anywhere else,
  // the app's rule decides: past 35% of the way it springs open, otherwise
  // it eases shut. Open, its actions can be reached by keyboard.
  function settleRow(wrap) {
    if (glides.has(wrap) || !wrap.isConnected || (drag && drag.active && drag.wrap === wrap)) return;
    const open = wrap === swipe.wrap && wrap.scrollLeft > MAX_REVEAL * 0.35;
    const left = open ? MAX_REVEAL : 0;
    if (Math.abs(wrap.scrollLeft - left) >= 1) return slideRow(wrap, left, open ? SPRING : easeOut(0.2));
    for (const card of wrap.cards) card.tabIndex = open ? 0 : -1;
    if (!open && swipe.wrap === wrap) swipe.wrap = null;
  }

  function slideRow(wrap, left, curve) {
    glide(wrap, left, curve, () => {
      drawRow(wrap);
      settleRow(wrap);
    });
  }

  // Shuts every row but `keep`, leaving alone any already on its way shut.
  function closeRows(keep, curve) {
    for (const wrap of list.querySelectorAll(".d-row-wrap")) {
      if (wrap !== keep && (glides.has(wrap) ? wrap.glideTo !== 0 : wrap.scrollLeft > 0)) slideRow(wrap, 0, curve);
    }
  }

  function closeSwipe() {
    swipe.wrap = null;
    if (list) closeRows(null, easeOut(0.2));
  }

  function noteInput(e) {
    const wrap = e.target.closest(".d-row-wrap");
    if (wrap) {
      input.wrap = wrap;
      input.at = performance.now();
      noteFingers(wrap);
    }
    return wrap;
  }

  function bindList() {
    list.addEventListener(
      "scroll",
      (e) => {
        const wrap = e.target;
        if (!wrap.classList || !wrap.classList.contains("d-row-wrap")) return;
        drawRow(wrap);
        if (wrap === swipe.wrap) return letGo(wrap, settleRow);
        if (glides.has(wrap) || wrap.scrollLeft <= 0) return;
        if (wrap === input.wrap && performance.now() - input.at < 1000) {
          // Swiping a row shuts the others, quickly, as in the app.
          swipe.wrap = wrap;
          closeRows(wrap, easeOut(0.15));
        } else {
          // Only a swipe opens a row, so whatever else moved this one, such
          // as the browser restoring where it was, is undone.
          slideRow(wrap, 0, easeOut(0.15));
        }
      },
      { capture: true, passive: true },
    );
    whenSettled(
      list,
      (wrap) => {
        if (wrap.classList && wrap.classList.contains("d-row-wrap")) settleRow(wrap);
      },
      true,
    );
    // A sideways swipe takes a row over from any glide it's in.
    list.addEventListener(
      "wheel",
      (e) => {
        const wrap = noteInput(e);
        if (wrap && Math.abs(e.deltaX) > Math.abs(e.deltaY)) takeOver(wrap, settleRow);
      },
      { passive: true },
    );
    list.addEventListener(
      "touchstart",
      (e) => {
        const wrap = noteInput(e);
        if (wrap) noteTouch(wrap, true);
      },
      { passive: true },
    );
    list.addEventListener("touchmove", noteInput, { passive: true });
    for (const type of ["touchend", "touchcancel"]) {
      list.addEventListener(
        type,
        (e) => {
          const wrap = e.target.closest(".d-row-wrap");
          if (wrap) noteTouch(wrap, false);
        },
        { passive: true },
      );
    }

    // A mouse can't scroll sideways, so dragging a row with one moves its
    // scroller directly, without snapping, and letting go settles it by the
    // app's rule.
    let dragged = false;
    list.addEventListener("pointerdown", (e) => {
      const wrap = e.target.closest(".d-row-wrap");
      if (e.pointerType !== "mouse" || e.button !== 0 || !wrap || e.target.closest(".d-swipe-btn")) return;
      drag = { wrap, x: e.clientX, y: e.clientY, from: wrap.scrollLeft, pointer: e.pointerId, active: false };
    });
    list.addEventListener("pointermove", (e) => {
      if (!drag || e.pointerId !== drag.pointer) return;
      const dx = e.clientX - drag.x;
      const dy = e.clientY - drag.y;
      if (!drag.active) {
        if (Math.abs(dx) > 6 && Math.abs(dx) > Math.abs(dy)) {
          drag.active = true;
          stopGlide(drag.wrap);
          drag.wrap.style.scrollSnapType = "none";
          drag.wrap.setPointerCapture(e.pointerId);
        } else {
          if (Math.abs(dy) > 6) drag = null;
          return;
        }
      }
      input.wrap = drag.wrap;
      input.at = performance.now();
      noteFingers(drag.wrap);
      drag.wrap.scrollLeft = drag.from - dx;
    });
    const endDrag = (e) => {
      if (!drag || e.pointerId !== drag.pointer) return;
      const { wrap, active } = drag;
      drag = null;
      if (!active) return;
      dragged = true;
      setTimeout(() => (dragged = false), 0);
      // The app's rule; sliding there also turns snapping back on.
      const open = wrap === swipe.wrap && wrap.scrollLeft > MAX_REVEAL * 0.35;
      slideRow(wrap, open ? MAX_REVEAL : 0, open ? SPRING : easeOut(0.2));
    };
    list.addEventListener("pointerup", endDrag);
    list.addEventListener("pointercancel", endDrag);

    // A tap opens the deployment, closing any open row, as in the app.
    list.addEventListener("click", (e) => {
      if (dragged || e.target.closest("[data-action]")) return;
      const wrap = e.target.closest(".d-row-wrap");
      if (wrap) showDetail(wrap.dataset.id);
    });

    list.addEventListener("keydown", (e) => {
      const row = e.target.closest(".d-row");
      if (row && (e.key === "Enter" || e.key === " ")) {
        e.preventDefault();
        showDetail(row.closest(".d-row-wrap").dataset.id);
      }
    });
  }

  // MARK: - Menus
  //
  // Like macOS menus: the pickers' menus drop down below them, and the pop-up
  // button in settings opens its menu over itself with the chosen item where
  // the button's title was. Choosing an item makes it blink before the menu
  // fades away.

  let menu = null;

  function openMenu(anchor, items, onSelect, { popUp = false } = {}) {
    closeMenu(true);
    const el = document.createElement("div");
    el.className = "d-menu";
    el.setAttribute("role", "menu");
    el.innerHTML = items
      .map((item) =>
        item === "-"
          ? '<div class="d-menu-sep" role="separator"></div>'
          : `<button role="menuitem" tabindex="-1" data-value="${esc(item.value)}">${item.checked ? `<span class="d-menu-check">${ICON.check}</span>` : ""}<span>${esc(item.label)}</span></button>`,
      )
      .join("");
    demo.appendChild(el);
    menu = { el, onSelect, anchor };
    anchor.classList.add("is-pressed");

    const frame = demo.getBoundingClientRect();
    const a = anchor.getBoundingClientRect();
    const originX = frame.left + demo.clientLeft;
    const originY = frame.top + demo.clientTop;
    let left = a.left - originX;
    let top = a.bottom - originY + 4;
    if (popUp) {
      // The chosen item's title lands on the button's title.
      const chosen = el.querySelector(`[data-value="${CSS.escape(String(items.find((i) => i.checked)?.value ?? ""))}"]`);
      left = a.left - originX - 5;
      el.style.minWidth = `${Math.round(a.width + 10)}px`;
      if (chosen) top = a.top - originY + a.height / 2 - (chosen.offsetTop + chosen.offsetHeight / 2);
    }
    left = Math.max(6, Math.min(demo.clientWidth - el.offsetWidth - 6, left));
    top = Math.max(34, Math.min(demo.clientHeight - el.offsetHeight - 6, top));
    el.style.left = `${Math.round(left)}px`;
    el.style.top = `${Math.round(top)}px`;

    el.addEventListener("pointermove", (e) => {
      const item = e.target.closest("button[role=menuitem]");
      if (item) highlight(item);
    });
    el.addEventListener("pointerleave", () => highlight(null));
    el.addEventListener("click", (e) => {
      const item = e.target.closest("button[role=menuitem]");
      if (!item) return;
      e.stopPropagation();
      choose(item);
    });
  }

  function highlight(item) {
    if (!menu) return;
    for (const b of menu.el.querySelectorAll(".is-hl")) b.classList.remove("is-hl");
    if (item) item.classList.add("is-hl");
  }

  function moveHighlight(step) {
    if (!menu) return;
    const items = [...menu.el.querySelectorAll("button[role=menuitem]")];
    const at = items.findIndex((b) => b.classList.contains("is-hl"));
    const next = at < 0 ? (step > 0 ? 0 : items.length - 1) : Math.max(0, Math.min(items.length - 1, at + step));
    highlight(items[next]);
  }

  function choose(item) {
    if (!menu || menu.choosing) return;
    menu.choosing = true;
    const { el, onSelect } = menu;
    highlight(item);
    after(70, () => item.classList.remove("is-hl"));
    after(140, () => item.classList.add("is-hl"));
    after(210, () => {
      closeMenu();
      onSelect(item.dataset.value);
    });
    el.style.pointerEvents = "none";
  }

  function closeMenu(instant = false) {
    if (!menu) return;
    const { el, anchor } = menu;
    menu = null;
    anchor.classList.remove("is-pressed");
    if (instant || reducedMotion.matches) return el.remove();
    el.style.pointerEvents = "none";
    el.animate([{ opacity: 1 }, { opacity: 0 }], { duration: 150, easing: "ease-out" }).finished.then(
      () => el.remove(),
      () => el.remove(),
    );
  }

  function teamItems(checks) {
    const checked = (id) => checks && state.team === id;
    return [
      { label: checks ? "Personal account" : "Personal Account", value: "personal", checked: checked("personal") },
      "-",
      ...TEAMS.map((t) => ({ label: t.name, value: t.id, checked: checked(t.id) })),
    ];
  }

  // As in the app, the picker changes at once, and the list once Vercel
  // answers.
  function selectTeam(id) {
    if (id === state.team) return;
    state.team = id;
    state.project = null;
    closeSwipe();
    renderPickers();
    if (state.view === "settings") renderSettings();
    after(350, () => {
      renderList();
      updateMenuBarIcon();
    });
  }

  function confirmSignOut() {
    const backdrop = document.createElement("div");
    backdrop.className = "d-alert-backdrop";
    backdrop.innerHTML = `
      <div class="d-alert" role="alertdialog" aria-label="Sign out">
        <img src="assets/icon.png" alt="">
        <h3>Sign out</h3>
        <p>Are you sure you want to sign out? Your access token will be removed from Keychain.</p>
        <button class="d-alert-btn d-alert-destructive" data-alert="confirm">Sign out</button>
        <button class="d-alert-btn" data-alert="cancel">Cancel</button>
      </div>`;
    body.appendChild(backdrop);
    backdrop.addEventListener("click", (e) => {
      const choice = e.target.closest("[data-alert]");
      if (!choice) return;
      e.stopPropagation();
      backdrop.remove();
      if (choice.dataset.alert === "confirm") {
        state.signedIn = false;
        state.view = "list";
        renderLogin();
      }
    });
  }

  // MARK: - Toasts

  let toastTimer = 0;

  function toast(text) {
    toastEl.textContent = text;
    toastEl.classList.remove("is-hidden");
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => toastEl.classList.add("is-hidden"), 2800);
  }

  // MARK: - Deployments changing state

  function transition(id, next, from) {
    const d = byId(id);
    if (!d || (from && !from.includes(d.state))) return;
    d.state = next;
    if (!state.signedIn) return;
    renderList();
    if (state.detailId === id && detailShown()) renderDetail();
    updateMenuBarIcon();
  }

  // Cancel and Redeploy wait for Vercel with spinners in both buttons, then
  // head back to the list, which picks up the change.
  function perform(action) {
    if (state.busy) return;
    const d = byId(state.detailId);
    state.busy = true;
    renderDetail();
    after(800, () => {
      state.busy = false;
      renderDetail();
      back();
      if (action === "cancel") return transition(d.id, "canceled", ["queued", "building"]);
      const hash = Math.random().toString(16).slice(2, 11).padEnd(9, "0");
      deployments.push({ ...d, id: hash, hash, state: "queued", created: Date.now() });
      renderList();
      updateMenuBarIcon();
      after(3000, () => transition(hash, "building", ["queued"]));
      after(17000, () => transition(hash, "ready", ["building"]));
    });
  }

  // Plays once the demo is on screen: one build finishes, another fails.
  let started = false;
  function startStory() {
    if (started) return;
    started = true;
    const shift = Date.now() - loadedAt;
    for (const d of deployments) d.created += shift;
    renderList();
    if (detailShown()) renderDetail();
    after(4500, () => transition("b81e4d2c9", "building", ["queued"]));
    after(14000, () => transition("4f9c2ab17", "ready", ["building"]));
    after(26000, () => transition("b81e4d2c9", "error", ["building"]));
  }

  // The header's spinner shows while a refresh is out.
  let refreshing = false;
  function refresh(button) {
    if (refreshing) return;
    refreshing = true;
    spinner.hidden = false;
    after(800, () => {
      refreshing = false;
      if (spinner) spinner.hidden = true;
      button.blur();
      renderList();
    });
  }

  // MARK: - Actions

  const swipeTarget = (el) => {
    const wrap = el.closest(".d-row-wrap");
    return wrap ? byId(wrap.dataset.id) : byId(state.detailId);
  };

  const actions = {
    toggle: () => setOpen(!state.open),
    refresh,
    settings: toggleSettings,
    back: () => back(),
    "team-menu": (el) => openMenu(el, teamItems(false), selectTeam),
    "settings-team-menu": (el) => openMenu(el, teamItems(true), selectTeam, { popUp: true }),
    "project-menu": (el) =>
      openMenu(el, [{ label: "All Projects", value: "" }, "-", ...projects().map((p) => ({ label: p, value: p }))], (value) => {
        state.project = value || null;
        closeSwipe();
        renderPickers();
        after(300, () => {
          renderList();
          updateMenuBarIcon();
        });
      }),
    visit: (el) => {
      closeSwipe();
      toast(`Opens ${domain(swipeTarget(el))} in your browser`);
    },
    inspect: (el) => {
      closeSwipe();
      toast(`Opens ${inspector(swipeTarget(el))}`);
    },
    logs: (el) => {
      closeSwipe();
      toast(`Opens the build logs on ${inspector(swipeTarget(el))}`);
    },
    repo: () => {
      const d = byId(state.detailId);
      toast(`Opens github.com/${ORG[d.team]}/${d.project}`);
    },
    copy: (el) => {
      const d = byId(state.detailId);
      const done = () => {
        el.classList.add("is-copied");
        clearTimeout(el.copyTimer);
        el.copyTimer = after(2000, () => el.classList.remove("is-copied"));
      };
      if (navigator.clipboard) navigator.clipboard.writeText(`https://${domain(d)}`).then(done, () => toast("Your browser didn't allow copying"));
      else toast("Your browser didn't allow copying");
    },
    cancel: () => perform("cancel"),
    redeploy: () => perform("redeploy"),
    setting: (el) => {
      const key = el.dataset.key;
      state.settings[key] = !state.settings[key];
      el.setAttribute("aria-checked", String(state.settings[key]));
      // Turning notifications off folds their two options away.
      if (key === "notifications") {
        const options = settingsPane.querySelector(".d-collapse");
        options.classList.toggle("is-open", state.settings.notifications);
        options.inert = !state.settings.notifications;
      }
      updateMenuBarIcon();
    },
    github: () => window.open("https://github.com/deebov/vercelian", "_blank", "noopener"),
    issues: () => window.open("https://github.com/deebov/vercelian/issues", "_blank", "noopener"),
    "sign-out": confirmSignOut,
    quit: () => {
      setOpen(false);
      toast("In the app, this quits Vercelian");
    },
    continue: () => {
      switchLoginStep("token");
      toast("This is a demo, so any token works");
    },
    "login-cancel": () => switchLoginStep("start"),
    connect: (el) => connectAccount(el),
    "token-page": () => toast("Opens vercel.com/account/tokens"),
  };

  demo.addEventListener("click", (e) => {
    if (e.target.closest(".d-menu")) return;
    const el = e.target.closest("[data-action]");
    // A click outside an open menu only closes it, as on a Mac.
    if (menu) {
      closeMenu();
      return;
    }
    if (el && actions[el.dataset.action]) {
      if (el.disabled) return;
      actions[el.dataset.action](el);
      return;
    }
    // Clicking the desktop closes the popover, as a transient popover does.
    if (state.open && !e.target.closest(".d-popover, .d-menubar")) setOpen(false);
  });

  demo.addEventListener("keydown", (e) => {
    if (menu) {
      if (e.key === "ArrowDown" || e.key === "ArrowUp") {
        e.preventDefault();
        moveHighlight(e.key === "ArrowDown" ? 1 : -1);
      } else if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        const item = menu.el.querySelector(".is-hl");
        if (item) choose(item);
      } else if (e.key === "Escape") {
        closeMenu(true);
      }
      return;
    }
    if (e.key !== "Escape") return;
    if (body.querySelector(".d-alert-backdrop")) body.querySelector(".d-alert-backdrop").remove();
    else if (detailShown()) back();
    else if (settingsShown()) leaveSettings(easeOut(0.25));
    else setOpen(false);
  });

  // Swiping sideways anywhere else in the demo shouldn't navigate the
  // browser.
  demo.addEventListener(
    "wheel",
    (e) => {
      if (Math.abs(e.deltaX) <= Math.abs(e.deltaY)) return;
      if (!detailShown() && !settingsShown() && e.target.closest(".d-row-wrap")) return;
      if (detailShown() && e.target.closest(".d-detail-layer")) return;
      if (settingsShown() && e.target.closest(".d-stage")) return;
      e.preventDefault();
    },
    { passive: false },
  );

  // MARK: - Appearance, clock, and timers

  const media = window.matchMedia("(prefers-color-scheme: dark)");
  const darkToggle = document.getElementById("demo-dark");
  const setTheme = (dark) => {
    demo.dataset.theme = dark ? "dark" : "light";
    if (darkToggle) darkToggle.checked = dark;
  };
  setTheme(media.matches);
  media.addEventListener("change", (e) => setTheme(e.matches));
  if (darkToggle) darkToggle.addEventListener("change", () => setTheme(darkToggle.checked));

  const tickClock = () => (clock.textContent = clockFormat.format(Date.now()));
  tickClock();
  setInterval(() => {
    tickClock();
    for (const el of demo.querySelectorAll("[data-elapsed]")) el.textContent = elapsed(Number(el.dataset.elapsed));
  }, SECOND);
  setInterval(() => {
    for (const el of demo.querySelectorAll("[data-ago]")) el.textContent = ago(Number(el.dataset.ago));
  }, 10 * SECOND);

  renderApp();
  position();
  new ResizeObserver(position).observe(demo);

  if ("IntersectionObserver" in window) {
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries.some((entry) => entry.isIntersecting)) {
          observer.disconnect();
          startStory();
        }
      },
      { threshold: 0.5 },
    );
    observer.observe(demo);
  } else {
    startStory();
  }
})();
