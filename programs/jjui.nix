{ colors, ... }:

{
  programs.jjui = {
    enable = true;

    settings = {
      ui.theme = "tokyonight";

      preview.show_at_start = true;

      # jjui 0.10.6 has no built-in way to swap out the diff viewer, so replace
      # the `revisions.diff` action outright. `hunk show` resolves jj revsets
      # natively, and jjui runs actions on the foreground TTY, so hunk's TUI
      # takes over the terminal and hands it back on quit.
      actions = [
        {
          name = "revisions.diff";
          desc = "diff in hunk";
          lua = ''
            local change_id = context.change_id()
            if not change_id or change_id == "" then
              flash({ text = "No revision selected", error = true })
              return
            end

            exec_shell(string.format("hunk show %q", change_id))
          '';
        }
      ];
    };
  };

  # Tokyo Night theme, adapted from https://github.com/vic/tinted-jjui.
  # jjui 0.10.6 only understands the legacy "scope selected role" selector
  # spelling; the ":selected" suffix form in the current docs is not supported.
  home.file.".config/jjui/themes/tokyonight.toml".text = ''
    text     = { fg = "${colors.fg_dark}", bg = "${colors.bg}" }
    dimmed   = { fg = "${colors.comment}" }
    title    = { fg = "${colors.blue1}", bold = true }
    shortcut = { fg = "${colors.magenta}" }
    matched  = { fg = "${colors.orange}" }
    border   = { fg = "${colors.fg_gutter}" }
    selected = { bg = "${colors.bg_dark}", fg = "${colors.fg_dark}", bold = true }

    source_marker = { bg = "${colors.cyan}", fg = "${colors.bg}", bold = true }
    target_marker = { bg = "${colors.green1}", fg = "${colors.bg}", bold = true }

    success = { fg = "${colors.green1}", bold = true }
    error   = { fg = "${colors.red}", bold = true }

    status           = { bg = "${colors.bg_dark}" }
    "status title"    = { fg = "${colors.bg}", bg = "${colors.blue5}", bold = true }
    "status shortcut" = { fg = "${colors.magenta}" }
    "status dimmed"   = { fg = "${colors.comment}" }

    "revset title"                = { fg = "${colors.blue1}", bold = true }
    "revset text"                 = { fg = "${colors.fg_dark}", bold = true }
    "revset completion text"      = { fg = "${colors.fg_dark}" }
    "revset completion matched"   = { fg = "${colors.orange}", bold = true }
    "revset completion dimmed"    = { fg = "${colors.comment}" }
    "revset completion selected"  = { bg = "${colors.bg_visual}", fg = "${colors.fg_dark}" }

    revisions                     = { fg = "${colors.fg_dark}" }
    "revisions selected"          = { bg = "${colors.bg_dark}" }
    "revisions dimmed"            = { fg = "${colors.comment}" }
    "revisions details selected"  = { bg = "${colors.bg_visual}" }
    "oplog selected"              = { bold = true }

    evolog            = { fg = "${colors.fg_dark}" }
    "evolog selected" = { bg = "${colors.bg_visual}", fg = "${colors.fg_dark}", bold = true }

    menu            = { bg = "${colors.bg}" }
    "menu title"    = { fg = "${colors.bg}", bg = "${colors.magenta}", bold = true }
    "menu shortcut" = { fg = "${colors.magenta}" }
    "menu matched"  = { fg = "${colors.orange}", bold = true }
    "menu dimmed"   = { fg = "${colors.comment}" }
    "menu border"   = { fg = "${colors.bg_dark}" }
    "menu selected" = { bg = "${colors.bg_visual}", fg = "${colors.fg_dark}" }

    help          = { bg = "${colors.bg}" }
    "help title"  = { fg = "${colors.green1}", bold = true, underline = true }
    "help border" = { fg = "${colors.bg_dark}" }

    preview          = { fg = "${colors.fg_dark}" }
    "preview border" = { fg = "${colors.bg_dark}" }

    confirmation            = { bg = "${colors.bg}" }
    "confirmation text"     = { fg = "${colors.blue1}", bold = true }
    "confirmation dimmed"   = { fg = "${colors.comment}" }
    "confirmation border"   = { fg = "${colors.red}", bold = true }
    "confirmation selected" = { bg = "${colors.bg_visual}", fg = "${colors.fg_dark}" }

    undo                         = { bg = "${colors.bg}" }
    "undo confirmation dimmed"   = { fg = "${colors.comment}" }
    "undo confirmation selected" = { bg = "${colors.bg_visual}", fg = "${colors.fg_dark}" }

    details            = { fg = "${colors.fg_dark}" }
    "details selected" = { bold = true }
    completion            = { fg = "${colors.fg_dark}" }
    "completion selected" = { bold = true }
    rebase                = { bold = true }
    "revisions rebase source_marker" = { bold = true }
    "revisions rebase target_marker" = { bold = true }

    workspace = { fg = "${colors.blue5}" }
    branch    = { fg = "${colors.cyan}" }
    commit    = { fg = "${colors.green1}" }
    file      = { fg = "${colors.orange}" }
    change    = { fg = "${colors.red}" }
    bookmark  = { fg = "${colors.magenta}" }
  '';
}
