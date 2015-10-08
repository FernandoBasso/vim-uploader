
if exists('g:loaded_vim_upload')
    finish
endif

let g:loaded_vim_upload = 1
let g:loaded_host_conf = 0


function! VimUploaderLoadConfData()
    "
    " If conf was not loaded yet.
    "
    if g:loaded_host_conf == 0
        "
        " If the user set up a custom file location.
        "
        if exists('g:VimUploaderHostsFile')
            execute 'source' expand(g:VimUploaderHostsFile)
        "
        " Otherwise, just assume the default location.
        "
        else
            source ~/.vim/vupload-remotes.vim
        endif

        "
        " Let's not source the file again.
        "
        g:loaded_host_conf = 1
    end

    "
    " Get only the keys.
    "
    let conf_names = FTPConfs('')
    let i = 1
    let choice_list = []
    for k in conf_names
        call add(choice_list, ' →  ' . i . '. ' . k)
        let i += 1
    endfor

    "
    " Choice is the number, not the string. - 1 because we
    " started with 1, but the list of confs start at 0.
    "
    let choice = inputlist(choice_list) - 1

    let g:VimUploader_conf_data = FTPConfs(conf_names[choice])

endfunction

"
" This function relies on cURL. And it must be on your path.
"
function! VUploadFile()

    let debug_enabled = 1

    if ! exists('g:VimUploader_conf_data')
        redraw | echo ' !!! → NOTE: Run `:call VimUploaderLoadConfData()` first.'
        return
    endif
    "
    " Ask for the conf name only once for this vim session.
    "
    "if !exists('g:VimUploader_conf_data')
    "    call VimUploaderLoadConfData()
    "endif

    let host = g:VimUploader_conf_data['host']
    let user = g:VimUploader_conf_data['user']
    let pass = g:VimUploader_conf_data['pass']

    let credentials = '--user ' . user . ':' . pass

    "
    " And if we are not in the root dir, bail out so that we do not end up
    " uploading files from one project to the ftp of some other project or
    " uploading files to the worong path in the server.
    "
    if g:VimUploader_conf_data['ldir'] != getcwd()
        echomsg 'Go to the root directory of the project first.'
        return
    endif


    "
    " Leave only the 'path' part of the directory where file currently being
    " edited is so that it is uploaded to the right path on the ftp server.
    "
    let dir = substitute( expand('%:p:h'), g:VimUploader_conf_data['ldir'], '', '' )

    "
    " NOTE: dir[1:] removes the leading slash. For example, %:p:h yields
    " '/styles', but we need 'styles' so we can concatenate it with
    " 'public_html/', otherwise we would end up with 'public_html//styles'.
    "
    let path = g:VimUploader_conf_data['rdir'] . dir
    let file = expand('%')

    "
    " Builds the final command.
    "

    let dest = 'ftp://' . host . '/' . path . '/'

    let command = printf('curl -T %s %s %s', file, dest, credentials)

    if debug_enabled
        echom command
    endif

    "
    " Finally run the command. At least we can see when the upload
    " fails or succeeds.
    "
    execute '!' . command

    " Opens and closes cmd.exe automatically.
    "call system(command)

    "
    " Works but needs https://github.com/xolox/vim-shell and I still
    " have to find a way to tell when the command failed, because
    " this simply runs in the background as if nothing happens.
    "
    " :call xolox#misc#os#exec({'command': command, 'async': 1})

endfunction


nnoremap <Leader>up :call VUploadFile()<CR>
nnoremap <F4> :call VUploadFile()<CR><CR>

