set number

set clipboard=unnamedplus
let g:clipboard = {
	\ 'name': 'wl-clipboard',
	\ 'copy': {
	\	'+': 'wl-copy',
	\	'*': 'wl-copy',
	\	},
	\ 'paste': {
	\	'+': 'wl-paste --no-newline',
	\	'*': 'wl-paste --no-newline',
	\	},
	\ 'cache_enabled': 0,
\}

