plan.vim
=========

A vim utility for making monthly plan, todo and so on in markdown.


##Usage

* `:Plan` open and edit planning file.

* `:PlanDir` open and edit planning file directory

* `:PlanMonth [month]  [year]` insert the template for a month

* `:PlanDay [day] [month] [year]` insert the template for a day.

* `:PlanGo` goto the  line of today in planning file.

##Shortcuts

* `<leader>pl` open and edit planning file.

* `<leader>pd` open and edit planning file directory.

* `<leader>pm` insert the template for current month.

* `<leader>py` insert the template for today.

* `<leader>pg` goto the line of today in planning file.

##Options

* `g:plan_file` the path of planning file, you can config this option in
`.vimrc`.

* `g:plan_custom_keymap` custom to make key mapping or not, default value is
`0`.

