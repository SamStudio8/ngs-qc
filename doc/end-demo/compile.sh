#!/bin/sh
# A script to compile the PhD Thesis - Krishna Kumar 
#
# Modified February 2014 - Sam Nicholls
#     Added commands to spell check and word count following compilation
#     Requires hunspell and texcount.pl
      texcount="/usr/local/bin/texcount.pl"
#
# Distributed under GPLv2.0 License

compile="compile";
clean="clean";

if test -z "$2"
then
if [ $1 = $clean ]; then
	echo "Cleaning please wait ..."
	rm -f *~
	rm -rf *.aux
	rm -rf *.bbl
	rm -rf *.blg
	rm -rf *.d
	rm -rf *.fls
	rm -rf *.ilg
	rm -rf *.ind
	rm -rf *.toc*
	rm -rf *.lot*
	rm -rf *.lof*
	rm -rf *.log
	rm -rf *.idx
	rm -rf *.out*
	rm -rf *.nlo
	rm -rf *.nls
	rm -rf *.pyg
	rm -rf $filename.pdf
	rm -rf $filename.ps
	rm -rf $filename.dvi
	rm -rf *#* 
	echo "Cleaning complete!"
	exit
else
	echo "Shell scrip for compiling your thesis"
	echo "Usage: sh ./compile-thesis.sh [OPTIONS] [filename]"
	echo "[option]  compile: Compiles your thesis"
	echo "[option]  clean: removes temporary files no filename required"
	exit
fi
fi

filename=$2;

if [ $1 = $clean ]; then
	echo "Cleaning please wait ..."
	rm -f *~
	rm -rf *.aux
	rm -rf *.bbl
	rm -rf *.blg
	rm -rf *.d
	rm -rf *.fls
	rm -rf *.ilg
	rm -rf *.ind
	rm -rf *.toc*
	rm -rf *.lot*
	rm -rf *.lof*
	rm -rf *.log
	rm -rf *.idx
	rm -rf *.out*
	rm -rf *.nlo
	rm -rf *.nls
	rm -rf *.pyg
	rm -rf $filename.pdf
	rm -rf $filename.ps
	rm -rf $filename.dvi
	rm -rf *#* 
	echo "Cleaning complete!"
	exit
elif [ $1 = $compile ]; then
	echo "Compiling your thesis...please wait...!"
	pdflatex -shell-escape $filename.tex
	bibtex $filename.aux
	makeindex $filename.aux
	makeindex $filename.idx
	makeindex $filename.nlo -s nomencl.ist -o $filename.nls
	pdflatex -shell-escape -interaction=nonstopmode $filename.tex
	makeindex $filename.nlo -s nomencl.ist -o $filename.nls
	pdflatex -shell-escape -interaction=nonstopmode $filename.tex
	rm -rf *.pyg
	echo "Success!"
    pdftotext $filename.pdf

    echo ""
    echo "TODO:"
    grep -rniI "TODO" .

    echo
    echo "Spell Check:"

    for file in $(find -name "*.tex" -not -path "./Classes/*" -not -path "./Preamble/*"); do
        echo ""
        echo "$file"
        hunspell -p thesis.dict -l -t -i utf-8 "$file" | sort -u
    done
fi


if test -z "$3"
then
	exit
fi
