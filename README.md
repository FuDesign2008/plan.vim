# plan.vim

A vim utility for making monthly plan, todo and so on in markdown.

## Install

1. Copy the `plugin` folder to `~/.vim`.
1. Configure regular-task options in `.vimrc`.
1. Use `:PlanMonth`/`:DiaryMonth` command to generate plan/diary template for a month.

Tips: If you want to preview markdown file, you can install
[MarkdownViewer.vim](https://github.com/FuDesign2008/MarkdownViewer.vim).

## Usage

### Create Plan/Diary Template

1. `:PlanMonth [month] [year]` insert the template of plan for a month.
    - If there is no arguments, the command will insert the template for
      current month.
    - If there is only `month` argument, the command will insert template for
      the month in current year.
    - If there are both `month` and `year` arguments, the command will insert
      template for the month in the year.
1. `:PlanDay [day] [month] [year]` insert the template of plan for a day.
    - If there is no arguments, the command will insert the template for today.
    - If there is only `day` argument, the command will insert template for the
      day in current month and current year.
    - If there are both `day` and `month` arguments, the command will insert
      template for the day in the month and current year.
    - If there are `day`, `month`, `year` arguments, the command will insert
      template for the day in the month and the year.
1. `:DiaryMonth [month] [year]` insert the template of diary for a month.
    - See `:PlanMonth`
1. `:DiaryDay [day] [month] [year]` insert the template of diary for a day.
    - See `:PlanDay`
1. `:GotoToday` goto the line of today in plan/diary file, the default map
   key is `<leader>gt`.

### Open Plan/Diary File

1. `:EditPlan` open and edit plan file.
1. `:EditDiary` open and edit diary file.

## Options

1. `g:plan_custom_keymap` custom to make key mapping or not, default value is `0`.
1. `g:p_edit_files` the files that can be edit.

```

let g:p_edit_files = {
    \ 'plan': 'the/path/to/plan/file/or/directory',
    \ 'diary': 'the/path/to/diary/file/or/directory'
    \}

```

### Regular Plan Task

1. `g:plan_month_work` regular work-task for every month.
1. `g:plan_month_personal` regular personal-task for every month.
1. `g:plan_month_review` regular review items for every month.
1. `g:plan_week_work` regular work-task for every week.
1. `g:plan_week_personal` regular personal-task for every week.
1. `g:plan_week_review` regular review items for every week.
1. `g:plan_year_work` regular work-task for every year.
1. `g:plan_year_personal` regular personal-task for every year.

Take my regular tasks configuration for example:

```vim
"
" NOTE: add `;` to the end of each task to as a line break
"
let g:plan_week_work = {
    \ 1 : '1. 10:00 - 11:00 @2层灵芝 YNote Editor Weekly meeting;',
    \ 2 : '1. 16:00 - 16:30 weekly report;',
    \ 5 : '1. 14:00 - 16:00 @二层甘草 webfront weekly meeting;'
    \}

let g:plan_week_personal = {
    \}

let g:plan_week_review = [
    \ '1. Invest & Finance;',
    \ '1. Tech & Managment;',
    \ '1. Enjoy Life;'
    \]

let g:plan_month_work = {
    \ 18: '1. Sprint 总结, 会议;'
    \}

let g:plan_month_personal = {
    \ 3 : '1. 18:00 ~ @ buy <<Programmer>> magazine;',
    \ 8 : '1. 还房贷;',
    \ 28 : '1. 月度总结;1. 下月计划;'
    \}

let g:plan_month_review = g:plan_week_review

let g:plan_year_personal = {
    \'01-18': '1. 收房租;',
    \'04-18': '1. 收房租;'
    \}

```

## Open Other File/Directory

1. `:PEdit <type>` open and edit `g:p_edit_files[<type>]` file or directory
    - The `:EditPlan` command is equal `:PEdit plan`.

You can set `g:p_edit_files` in `.vimrc`.

## Screenshot

![plan-vim.png](plan-vim.png)

## Change Log

-   2019-11-28
    -   REMOVE remove commands
        -   `:PEditCwd`
        -   `:EditPlanCwd`
        -   `:EditDiaryCwd`
-   2019-11-25
    -   ADD completer for `:PEdit` and `:PEditCwd` commands
-   2017-01-03
    -   ADD `g:plan_week_keypoint`, `g:plan_month_keypoint`
-   2016-11-18
    -   ADD `g:plan_week_review` and `g:plan_month_review`
-   2016-04-05
    -   ADD key point of day
-   2015-12-28
    -   ADD `:PEdit`, `:PEditCwd`, `g:p_edit_files`
    -   REMOVE `g:p_plan_file`, `g:p_diary_file`
-   2015-05-31
    -   Leap year support
-   2015-01-31
    -   ADD `:EditPlanCwd` and `:EditDiaryCwd` command
    -   REMOVE `g:p_change_dir`
-   2015-01-27
    -   ADD `g:plan_year_work` and `g:plan_year_personal`
-   2015-01-20
    -   REMOVE `:EditPlanDir` command
    -   REMOVE default mapping keys for `:EditPlanDir` and `:EditPlan` commands
    -   ADD `:EditDiary` command, `g:p_diary_file`, `g:p_change_dir`
    -   RENAME `g:plan_file` rename to `g:p_plan_file`
-   2015-01-05
    -   REMOVE the modules that depend on `node.js`
-   2014-12-03
    -   ADD `:DiaryMonth`, `:DiaryDay` commands
