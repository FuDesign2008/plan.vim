"mplan.vim
"Author: FuDesign2008@163.com
"Version: 1.0.0
"The plugin is a utility for making monthly plan in markdown.
"



if &cp || exists('g:mplan_loaded')
    finish
endif

let g:mplan_loaded = 1
let s:save_cpo = &cpo
set cpo&vim

let s:mplan_file = ''

if exists('g:mplan_file')
     let s:mplan_file = g:mplan_file
endif

" util
" get the directory of the file
" @param {String} file
" @return {String}
function! s:GetDirectoryByFile (file)
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
if filereadable(s:mplan_file)
    let s:mplan_dir = s:GetDirectoryByFile(s:mplan_file)
    if !isdirectory(s:mplan_dir)
        let s:mplan_file = ''
        let s:mplan_dir = ''
    endif
else
    let s:mplan_file = ''
    let s:mplan_dir = ''
endif

" open mplan file to  edit
function! s:MPlan()
    if s:mplan_file != ''
        vsplit s:mplan_file
    endif
endfunction

"open mplan file's directory to edit
function! s:MPlanDir()
    if s:mplan_dir != ''
        vsplit s:mplan_dir
    endif
endfunction

"@param {String} full day, 01-31
"@param {String} full month, 01-12
"@param {String} full year
"@return {Integer} 0-6
function! s:GetWeekdayByNodeJs(day, month, year)
    return 0
endfunction


"@param {Integer} day, 1-31
"@param {Integer} month, 1-12
"@param {Integer} year
"@return {String}
function! s:GetDayContent(day, month, year)
 let weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
 let weekday = s:GetWeekdayByNodeJs(a:day, a:month, a:year)
 let content = '##' . a:year . '-' . a:month . '-' . a:day . ' ' . weekdays[weekday] .';'
 let content = content .  '###Work;1. ;###Personal;1. ;'
 return content
endfunction

"when editing mplan file, insert all the template of a day
"@param {Integer} day [optional]  default is current day
"@param {Integer} month [optional]  default is current month
"@param {Integer} year [optional] defautl is current year
function! s:MPlanInsertDay(day, month, year)


endfunction




"when editing mplan file, insert all the template of a month
"@param {Integer} month [optional]  default is current month
"@param {Integer} year [optional] defautl is current year
function! s:MPlanInsertMonth(month, year)
    "full year, 2013
    if !exists(a:year)
        let y = strftime('%Y')
    endif
    "full month, 04
    if !exists(a:month)
        let m = strftime('%m')
    endif
    let head = '#Plan of ' . y . '-' . m .';;'
    let head = head + '##Work Targets;1. ;;'
    let head = head + '##Personal Targets;1. ;;;'
    " convert to integer
    let y = y + 0
    let m = m + 0

    let day31 = [1,3,5,7,8,10,12]
    let day30 = [4,6,9,11]

    let days = 28
    if index(day31, m) > -1
        let days = 31
    elseif index(day30, m) > -1
        let days = 30
    endif

    let counter = 1
    let content = ''
    while counter <= days
        let content = content . s:GetDayContent(counter, month, year) . ';'
        let counter += 1
    endwhile

    let content = head . content
    let content = split(content, ';')
    append(line('.'), content)
endfunction


command! -nargs=0 MPlan call s:MPlan()
command! -nargs=0 MPlanDir call s:MPlanDir()
command! -nargs=* MPlanMonth call s:MPlanInsertMonth()
command! -nargs=* MPlanDay call s:MPlanInsertDay()


let &cpo = s:save_cpo

