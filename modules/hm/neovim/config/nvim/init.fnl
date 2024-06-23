(require :settings)
(require :pre)
(require :mappings)
(local lazy_config (require :lazy_config))

; -- bootstrap lazy and all plugins
(local lazypath (.. (vim.fn.stdpath :data) :/lazy/lazy.nvim))
;
(if (not (vim.loop.fs_stat lazypath))
    (let [repo "https://github.com/folke/lazy.nvim.git"]
      (vim.fn.system [:git
                      :clone
                      "--filter=blob:none"
                      repo
                      :--branch=stable
                      lazypath])))

;
(vim.opt.rtp:prepend lazypath)

;; validate that lazy is available
(if (not (pcall require :lazy))
    (do
      ; stylua: ignore
      (vim.api.nvim_echo [{(string.format "Unable to load lazy from: %s\n"
                                           lazypath) :ErrorMsg}
                          {"Press any key to exit..." :MoreMsg}]
                         true {})
      (vim.fn.getchar)
      (vim.cmd.quit)))

;; load plugins
(local lazy (require :lazy))
(lazy.setup [:udayvir-singh/tangerine.nvim
             {:import :plugins/base}
             {:import :plugins/ft}
             {:import :plugins/editor}] lazy_config)

(local ft_path (.. (vim.fn.stdpath :config) :/lua/ft))
(if (vim.loop.fs_stat ft_path)
    (each [file (vim.fs.dir ft_path)]
      (let [file (file:match "^(.*)%.lua$")]
        (if file
            (require (.. :ft. file))))))

(require :post)
