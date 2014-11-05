$latex = 'platex -src-specials -file-line-error -interaction=nonstopmode -synctex=1';
$latex_silent = 'platex -interaction=batchmode';
$bibtex = 'pbibtex';
$dvipdf = "dvipdfmx %O -o %D %S";
$dvips  = 'dvips';
$dvi_previewer = 'xdvi -watchfile 1 -geo +0+0 -s 6';
$pdf_previewer = 'evince';
