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



" to get the day of week
" @see http://en.wikipedia.org/wiki/Determination_of_the_day_of_the_week
" `Implementation-dependent methods of Sakamoto, Lachman, Keith and Craver`
"
"@param {Integer} day, 1-31
"@param {Integer} month, 1-12
"@param {Integer} full year
"@return {Integer} 0-6
function! s:DayOfWeek(day, month, year)
    let month_map = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
    let y = a:month < 3 ? (a:year - 1) : a:year
    let m = get(month_map, a:month - 1)
    let dayOfWeek =  (y + y/4 - y/100 + y/400 + m + a:day) % 7
    return dayOfWeek
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
"@param {Integer} isDiary
"@return {String}
function! s:GetDayContent(day, month, year, isDiary)
    let weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    let weekIndex = s:DayOfWeek(a:day, a:month, a:year)
    let weekStr = get(weekdays, weekIndex, '')
    let month = s:PaddingTen(a:month)
    let fullDay = s:PaddingTen(a:day)
    let content = '##' . a:year . '-' . month . '-' . fullDay . ' ' . weekStr .';;'

    if a:isDiary
        return content
    endif

    "
    "work
    let content = content . '###Work;'
    let regularTasks = get(s:planWeekWork, weekIndex, '')
    let content = content . regularTasks
    let regularTasks = get(s:planMonthWork, a:day, '')
    let content = content . regularTasks . ';;'

    "personal
    let content = content . '###Personal;'
    let regularTasks = get(s:planWeekPersonal, weekIndex, '')
    let content = content . regularTasks
    let regularTasks = get(s:planMonthPersonal, a:day, '')
    let content = content . regularTasks . ';;'

    return content
endfunction

"when editing plan file, insert all the template of a day
"@param {Integer} day [optional]  default is current day
"@param {Integer} month [optional]  default is current month
"@param {Integer} year [optional] defautl is current year
function! s:PlanInsertDay(...)
    "@see http://www.cplusplus.com/reference/ctime/strftime/
    let day = get(a:000, 0, strftime('%d'))
    let month = get(a:000, 1, strftime('%m'))
    let year = get(a:000, 2, strftime('%Y'))

    let day = str2nr(day, 10)
    let month = str2nr(month, 10)
    let year = str2nr(year, 10)

    let content = s:GetDayContent(day, month, year, 0) . ';'
    let all_content = split(content, ';')
    let failed = append(line('.'), all_content)
endfunction

"when editing plan file, insert all the template of a day
"@param {Integer} day [optional]  default is current day
"@param {Integer} month [optional]  default is current month
"@param {Integer} year [optional] defautl is current year
function! s:DiaryInsertDay(...)
    "@see http://www.cplusplus.com/reference/ctime/strftime/
    let day = get(a:000, 0, strftime('%d'))
    let month = get(a:000, 1, strftime('%m'))
    let year = get(a:000, 2, strftime('%Y'))

    let day = str2nr(day, 10)
    let month = str2nr(month, 10)
    let year = str2nr(year, 10)

    let content = s:GetDayContent(day, month, year, 1) . ';'
    let all_content = split(content, ';')
    let failed = append(line('.'), all_content)
endfunction

"when editing plan file, insert all the template of a month
"@param {Integer} month [optional]  default is current month
"@param {Integer} year [optional] defautl is current year
function! s:PlanInsertMonth(...)
    let month = get(a:000, 0, strftime('%m'))
    let year = get(a:000, 1, strftime('%Y'))

    let month = str2nr(month, 10)
    let year = str2nr(year, 10)

    let head = '#Plan of ' . year . '-' . s:PaddingTen(month) .';;'
    let head = head . ';##Work Targets;1.;'
    let head = head . ';##Personal Targets;1.;;'
    let head = head . ';##X Lab;1.;;'

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
        let content = content . s:GetDayContent(counter, month, year, 0) . ';'
        let counter += 1
    endwhile

    let content = head . content
    let all_content = split(content, ';')
    let failed = append(line('.'), all_content)
    if failed
        echo 'Insert plan failed!'
    endif

endfunction

"when editing plan file, insert all the template of a month
"@param {Integer} month [optional]  default is current month
"@param {Integer} year [optional] defautl is current year
function! s:DiaryInsertMonth(...)
    let month = get(a:000, 0, strftime('%m'))
    let year = get(a:000, 1, strftime('%Y'))

    let month = str2nr(month, 10)
    let year = str2nr(year, 10)

    let head = '#Diary of ' . year . '-' . s:PaddingTen(month) .';;'

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
        let content = content . s:GetDayContent(counter, month, year, 1) . ';'
        let counter += 1
    endwhile

    let content = head . content
    let all_content = split(content, ';')
    let failed = append(line('.'), all_content)
    if failed
        echo 'Insert diary failed!'
    endif

endfunction

function! s:GotoToday()
    let str = '##' . strftime('%Y') . '-' . strftime('%m') . '-' .strftime('%d')
    execute '/'. str
endfunction


command! -nargs=0 EditPlan call s:EditPlan()
command! -nargs=0 EditPlanDir call s:EditPlanDir()
command! -nargs=* PlanMonth call s:PlanInsertMonth(<f-args>)
command! -nargs=* PlanDay call s:PlanInsertDay(<f-args>)
command! -nargs=* DiaryMonth call s:DiaryInsertMonth(<f-args>)
command! -nargs=* DiaryDay call s:DiaryInsertDay(<f-args>)
command! -nargs=0 GotoToday call s:GotoToday()

if !exists('g:plan_custom_keymap')
    nnoremap <leader>ep :EditPlan<CR>
    nnoremap <leader>ed :EditPlanDir<CR>
    nnoremap <leader>gt :GotoToday<CR>
endif


let &cpo = s:save_cpo

