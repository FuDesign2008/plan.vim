"plan.vim
"Author: FuDesign2008@163.com
"Version: 1.0.0
"The plugin is a utility for making monthly plan in markdown.
"



if &cp || exists('g:plan_loaded')
    finish
endif

let g:plan_loaded = 1
let s:save_cpo = &cpo
set cpo&vim

let s:root_path = expand('<sfile>:p:h')
let s:node_js_cmd = 'null'

let s:plan_file = ''
if exists('g:plan_file')
    let s:plan_file = g:plan_file
endif

let s:planWeekWork = {}
if exists('g:plan_week_work')
    let s:planWeekWork = g:plan_week_work
endif

let s:planWeekPersonal = {}
if exists('g:plan_week_personal')
    let s:planWeekPersonal = g:plan_week_personal
endif

let s:planMonthWork = {}
if exists('g:plan_month_work')
    let s:planMonthWork = g:plan_month_work
endif

let s:planMonthPersonal = {}
if exists('g:plan_month_personal')
    let s:planMonthPersonal = g:plan_month_personal
endif

" util
" get the directory of the file
" @param {String} file
" @return {String}
function! s:GetDirectoryByFile(file)
    let slash_index = strridx(a:file, '/')

    " try find `\` for windows
    if slash_index == -1
        let slash_index = strridx(a:file, '\')
    endif

    if slash_index == -1
        return ''
    endif

    return strpart(a:file, 0, slash_index)
endfunction


" to check the variable about file
if filereadable(s:plan_file)
    let s:plan_dir = s:GetDirectoryByFile(s:plan_file)
    if !isdirectory(s:plan_dir)
        let s:plan_file = ''
        let s:plan_dir = ''
    endif
else
    let s:plan_file = ''
    let s:plan_dir = ''
endif

" open plan file to  edit
function! s:EditPlan()
    if s:plan_file != ''
        execute 'edit '. s:plan_file
    endif
endfunction

"open plan file's directory to edit
function! s:EditPlanDir()
    if s:plan_dir != ''
        execute 'edit' . s:plan_dir
    endif
endfunction


"
function! s:joinPath(...)
  let paths = join(a:000,'/')
  let root = s:root_path
  return root.'/'.paths
endfunction

"@param {String} full day, 01-31
"@param {String} full month, 01-12
"@param {String} full year
"@return {Integer} 0-6
function! s:GetWeekdayByNodeJs(day, month, year)
    if s:node_js_cmd == 'null'
        let filePath = s:joinPath('js', 'get_weekday.js')
        if !filereadable(filePath)
            return -1
        endif
        let s:node_js_cmd = 'node "'. filePath . '" "<DATE>"'
    endif

    let date = a:year . '-' . a:month . '-' . a:day
    let cmd = substitute(s:node_js_cmd, '<DATE>', date, '')
    let weekday_index = system(cmd)
    if weekday_index == 'ERROR'
        let weekday_index = -1
    else
        let weekday_index = weekday_index + 0
    endif
    return weekday_index
endfunction

" padding integer with zero if the integer is less than 10
" @return {String}
function! s:PaddingTen(int)
    let num = a:int + 0
    if num < 10
        return '0' . num
    endif
    return num
endfunction

"@param {Integer} day, 1-31
"@param {Integer} month, 1-12
"@param {Integer} year
"@return {String}
function! s:GetDayContent(day, month, year)
    let weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    let weekIndex = s:GetWeekdayByNodeJs(a:day, a:month, a:year)
    let weekStr = get(weekdays, weekIndex, '')
    let month = s:PaddingTen(a:month)
    let fullDay = s:PaddingTen(a:day)
    let content = '##' . a:year . '-' . month . '-' . fullDay . ' ' . weekStr .';;'
    "
    "work
    let content = content . '###Work;'
    let regularTasks = get(s:planWeekWork, weekIndex, '')
    let content = content . regularTasks
    let regularTasks = get(s:planMonthWork, a:day, '')
    let content = content . regularTasks . ';'

    "personal
    let content = content . '###Personal;'
    let regularTasks = get(s:planWeekPersonal, weekIndex, '')
    let content = content . regularTasks
    let regularTasks = get(s:planMonthPersonal, a:day, '')
    let content = content . regularTasks . ';'

    return content
endfunction

"when editing plan file, insert all the template of a day
"@param {Integer} day [optional]  default is current day
"@param {Integer} month [optional]  default is current month
"@param {Integer} year [optional] defautl is current year
function! s:PlanInsertDay(...)
    "@see http://www.cplusplus.com/reference/ctime/strftime/
    "for strftime()
    "
    "day of month, 1-31, or 01-31
    let day = get(a:000, 0)
    let day = str2nr(day, 10)
    if day == 0
        let day = strftime('%d')
    endif
    "full month, 1-12 or 01-12
    let month = get(a:000, 1)
    let month = str2nr(month, 10)
    if month == 0
        let month = strftime('%m')
    endif
    "full year, 2013
    let year = get(a:000, 2)
    let year = str2nr(year, 10)
    if year == 0
        let year = strftime('%Y')
    endif

    let content = s:GetDayContent(day, month, year) . ';'
    let all_content = split(content, ';')
    let failed = append(line('.'), all_content)
endfunction


"when editing plan file, insert all the template of a month
"@param {Integer} month [optional]  default is current month
"@param {Integer} year [optional] defautl is current year
function! s:PlanInsertMonth(...)
    "full month, 04
    let month = get(a:000, 0)
    if month == 0
        let month = strftime('%m')
    endif
    "full year, 2013
    let year = get(a:000, 1)
    if year == 0
        let year = strftime('%Y')
    endif

    let head = '#Plan of ' . year . '-' . month .';;'
    let head = head . ';##Work Targets;1.;'
    let head = head . ';##Personal Targets;1.;;'
    " convert to integer
    let year = year + 0
    let month = month + 0

    let day31 = [1,3,5,7,8,10,12]
    let day30 = [4,6,9,11]

    let days = 28
    if index(day31, month) > -1
        let days = 31
    elseif index(day30, month) > -1
        let days = 30
    endif

    let counter = 1
    let content = ''
    while counter <= days
        let content = content . s:GetDayContent(counter, month, year) . ';'
        let counter += 1
    endwhile

    let content = head . content
    let all_content = split(content, ';')
    let failed = append(line('.'), all_content)
    if failed
        echo 'Insert plan failed!'
    endif

endfunction

function! s:PlanGotoToday()
    let str = '##' . strftime('%Y') . '-' . strftime('%m') . '-' .strftime('%d')
    execute '/'. str
endfunction


command! -nargs=0 EditPlan call s:EditPlan()
command! -nargs=0 EditPlanDir call s:EditPlanDir()
command! -nargs=* PlanMonth call s:PlanInsertMonth('<args>')
command! -nargs=* PlanDay call s:PlanInsertDay('<args>')
command! -nargs=0 GotoToday call s:PlanGotoToday()

if !exists('g:plan_custom_keymap')
    nnoremap <leader>ep :EditPlan<CR>
    nnoremap <leader>ed :EditPlanDir<CR>
    nnoremap <leader>gt :GotoToday<CR>
endif


let &cpo = s:save_cpo

