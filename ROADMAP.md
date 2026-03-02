# ROADMAP

Strategic development plan for maintaining and evolving this dotfiles collection.

## Quick wins (0-2 weeks)

- [ ] Add CI workflow for shell script linting (shellcheck) and config validation.
- [ ] Add `.env.example` for any environment-specific variables referenced in configs.
- [ ] Create `docs/CUSTOMIZATION.md` with guidance for adapting configs to different systems.
- [ ] Add pre-commit hooks for shellcheck and config format validation.
- [ ] Document Hyprland keybindings in a dedicated quick-reference file.

## Medium bets (2-6 weeks)

- [ ] Add modular installation options (install only specific packages via flags).
- [ ] Create automated backup script for existing configs before stow deployment.
- [ ] Add health check script to validate symlinks and detect broken references.
- [ ] Introduce theme variants (light/dark) with easy switching mechanism.
- [ ] Add eww widget documentation with screenshots and customization examples.

## Big bets (1-2 months)

- [ ] Build config migration tooling for cross-system portability.
- [ ] Add automated screenshot generation for README visual documentation.
- [ ] Create interactive setup wizard for first-time users.
- [ ] Implement config templating system for machine-specific overrides.
- [ ] Add NixOS/Home Manager alternative for reproducible deployments.

## Strategic rewrites (as needed)

- [ ] Refactor install.sh into modular functions with proper error handling.
- [ ] Migrate from manual stow commands to a unified dotfiles manager (chezmoi, yadm).
- [ ] Introduce structured config validation schemas where applicable.
- [ ] Build automated testing for install scripts on fresh Arch VM.

---

## Validation checklist per milestone

- [ ] All shell scripts pass shellcheck.
- [ ] README updated with any new features/requirements.
- [ ] Install script tested on clean system.
- [ ] No hardcoded paths or machine-specific values.

---

*Last updated: March 2026*
