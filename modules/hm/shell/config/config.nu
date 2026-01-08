# Nushell Config File
# The default config record. This is where much of your global configuration is setup.

$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup

    rm: {
        always_trash: false # always act as if -t was given. Can be overridden with -p
    }

    history: {
        max_size: 100_000 # Session has to be reloaded for this to take effect
        sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
        file_format: "sqlite" # "sqlite" or "plaintext"
        isolation: true # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
    }

    float_precision: 2 # the precision for displaying floats in tables
    edit_mode: emacs # emacs, vi

    menus: [
        {
          name: abbr_menu
          only_buffer_difference: false
          marker: "👀 "
          type: {
            layout: columnar
            columns: 1
            col_width: 20
            col_padding: 2
          }
          style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
          }
          source: { |buffer, position|
            scope aliases
            | where name == $buffer
            | each { |elt| {value: $elt.expansion }}
          }
        }
    ]

    keybindings: [
        {
            name: abbr
            modifier: control
            keycode: char_t
            mode: [emacs vi_normal vi_insert]
            event: [
                { send: menu name: abbr_menu }
                #{ edit: insertchar, value: ' '}
            ]
        }
    ]
}

if ($env.TMUX?|is-empty)  {
let sess = (run-external tmux list-sessions) |  lines | where { |it| $it =~ '^[0-9]+'} | where { |it| $it =~ '^((?!attached).)*$'} | split row ':'|if ($in |is-empty) {""} else {$in|first}
  if not ($sess |is-empty) {
    run-external tmux attach-session "-t" $sess
    #exit
  } else {
    run-external tmux new-session
    #exit
  }
}
