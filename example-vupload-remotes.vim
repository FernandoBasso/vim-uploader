function! FTPConfs(name)

    "
    " ldir → local project directory.
    " rdir → remote project directory.
    "

    "
    " NOTE: No trailing slash after the project directory.
    "

    let conf = {
                \ 'proj1': {
                    \ 'host': 'ftp.proj1.net',
                    \ 'user': 'proj1',
                    \ 'pass': '1234',
                    \ 'ldir': $HOME . '/develop/proj1',
                    \ 'rdir': 'public_html'
                \ },
                \ 'proj2-blog' : {
                    \ 'host': 'ftp.proj2.com',
                    \ 'user': 'proj2',
                    \ 'pass': 'asdf',
                    \ 'ldir': $HOME . '/develop/proj2-blog',
                    \ 'rdir': 'public_html/blog/'
                \ },
                \ 'fooproj-admin-area' : {
                    \ 'host': 'ftp.fooproj.ws',
                    \ 'user': 'fooprojuser',
                    \ 'pass': '0123',
                    \ 'ldir': $HOME . '/develop/fooproj/admin/'
                    \ 'rdir': 'www-files'
                \ }
             \ }


    "
    " TODO: Move this logic to another place so that this file only
    " knows about the remotes and nothing else.
    "

    "
    " If name is an empty string, we don't want to retrieve a single
    " host config, but all the config names instead, so that the user
    " can be prompted with a list and select one.
    "
    if a:name == ''
        return keys(conf)
    endif


    "
    " If name is found in the conf dictionary, return the
    " whole sub dict.
    "
    if has_key(conf, a:name)
        return conf[a:name]
    endif

    return 0

endfunction
----
