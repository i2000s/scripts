#!Bash
# This makefile is for compiling LaTeX into pdf with bib libraries.
# On Windows, it requires Make tool and you may be able to add this tool by adding the MinGW to path:
#  PATH=$PATH:/MINGW/msys/1.0/bin
# where /MINGW is where MinGW is installed. The line ending should be LF.
PROJECT=FaradayProtocol
LATEXFLAGS?=-interaction=nonstopmode -file-line-error

#pdf: ps
#	ps2pdf ${PROJECT}.ps

#pdf-print: ps
#	ps2pdf -dColorConversionStrategy=/LeaveColorUnchanged -dPDFSETTINGS=/printer ${PROJECT}.ps

#text: html
#	html2text -width 100 -style pretty ${PROJECT}/${PROJECT}.html | sed -n '/./,$$p' | head -n-2 >${PROJECT}.txt

#html:
#	@#latex2html -split +0 -info "" -no_navigation ${PROJECT}
#	htlatex ${PROJECT}

#ps:	dvi
#	dvips -t letter ${PROJECT}.dvi

#dvi:
#	latex ${PROJECT}
#	bibtex ${PROJECT}||true
#	latex ${PROJECT}
#	latex ${PROJECT}

.DEFAULT: all
.PHONY: all clean

all:
	pdflatex $(LATEXFLAGS) $(PROJECT)
	bibtex $(PROJECT)||true
	pdflatex $(LATEXFLAGS) $(PROJECT)
	pdflatex $(LATEXFLAGS) $(PROJECT)

read:
	evince ${PROJECT}.pdf &

aread:
	acroread ${PROJECT}.pdf

clean:
	rm -f ${PROJECT}.{ps,log,aux,out,dvi,bbl,blg}
