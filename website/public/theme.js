/*
 * The site's theme: the one picked with the button in the header, or the
 * system's. Loaded in the head, so pages paint in it from the start. A pick
 * that matches the system is forgotten, so the site follows the system again.
 */
(() => {
  "use strict";

  const root = document.documentElement;
  const system = window.matchMedia("(prefers-color-scheme: dark)");
  const KEY = "theme";
  const BACKGROUND = { light: "#ffffff", dark: "#0a0a0a" };

  const systemTheme = () => (system.matches ? "dark" : "light");

  function picked() {
    try {
      const theme = localStorage.getItem(KEY);
      return theme === "light" || theme === "dark" ? theme : null;
    } catch {
      return null;
    }
  }

  function remember(theme) {
    try {
      if (theme === systemTheme()) localStorage.removeItem(KEY);
      else localStorage.setItem(KEY, theme);
    } catch {}
  }

  function apply(theme) {
    root.dataset.theme = theme;
    for (const meta of document.querySelectorAll('meta[name="theme-color"]')) meta.content = BACKGROUND[theme];
    const button = document.querySelector(".theme-button");
    if (button) button.setAttribute("aria-label", `Switch to ${theme === "dark" ? "light" : "dark"} theme`);
  }

  apply(picked() || systemTheme());
  system.addEventListener("change", () => {
    if (!picked()) apply(systemTheme());
  });

  document.addEventListener("DOMContentLoaded", () => {
    const button = document.querySelector(".theme-button");
    if (!button) return;
    apply(root.dataset.theme);
    button.addEventListener("click", () => {
      const theme = root.dataset.theme === "dark" ? "light" : "dark";
      remember(theme);
      apply(theme);
    });
  });
})();
