% FortySecondsCV LaTeX class
% Copyright © 2019-2022 René Wirnata <rene.wirnata@pandascience.net>
% Licensed under the 3-Clause BSD License. See LICENSE file for details.
%
% Please visit https://github.com/PandaScience/FortySecondsCV for the most
% recent version! For bugs or feature requests, please open a new issue on
% github.
%
% Contributors:
% https://github.com/PandaScience/FortySecondsCV/graphs/contributors
%
% Attributions
% ------------
% * fortysecondscv is based on the twentysecondcv class by Carmine Spagnuolo
%   (cspagnuolo@unisa.it), released under the MIT license and available under
%   https://github.com/spagnuolocarmine/TwentySecondsCurriculumVitae-LaTex
% * further attributions are indicated immediately before corresponding code


%-------------------------------------------------------------------------------
%                           CLASS NAME AND VERSION
%-------------------------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fortysecondscv}[2020/10/19 CV class]

%-------------------------------------------------------------------------------
%                            PROCESS CLASS OPTIONS
%-------------------------------------------------------------------------------
%% first load all packages absolutely required to parse class options
% for easy color definitions; provides \definecolor; load before background pkg
\RequirePackage[dvipsnames, svgnames, x11names]{xcolor}
% for positioning text within the side column | use showboxes for visible frame
\RequirePackage[absolute,overlay]{textpos}
% provides key-value class options via \DeclareOptionX
\RequirePackage{xkeyval}
% provides \ifnumgreater{<int expr.>}{<int expr.>}{<true>}{<false>},
% \apptocmd{<command>}{<code>}{<success>}{<failure>} and \newtoggle{<name>}
\RequirePackage{etoolbox}
% provides basic conditional expressions
\RequirePackage{ifthen}
% enable simple math like +/- etc. on lengths
\RequirePackage{calc}
% change page margins
\RequirePackage[
	nohead,
	nofoot,
	nomarginpar,
]{geometry}

%-------------------------------------------------------------------------------
%                            CUSTOMISATION
%-------------------------------------------------------------------------------
% Flexoki color set
\definecolor{bg}{HTML}{FFFCF0}
\definecolor{bg-2}{HTML}{F2F0E5}
\definecolor{re}{HTML}{AF3029}
\definecolor{tex-2}{HTML}{6F6E69}
\definecolor{tex-3}{HTML}{575653}
\definecolor{ui-3}{HTML}{403E3C}

%-------------------------------------------------------------------------------
%                            PROCESS CLASS OPTIONS
%-------------------------------------------------------------------------------
% pre-define some colors the user can choose from
\definecolor{cvblue}{HTML}{0E5484}
\definecolor{cvgreen}{HTML}{007170}
\definecolor{cvred}{HTML}{8B0000}
\definecolor{cvsidecolor}{HTML}{E7E7E7}
\definecolor{cvsectioncolor}{HTML}{0395DE}
\definecolor{cvsubsectioncolor}{HTML}{4D4D4D}
% set default values
\colorlet{maincolor}{cvblue}
\colorlet{sidecolor}{cvsidecolor}
\colorlet{sidetextcolor}{black}
\colorlet{sectioncolor}{cvsectioncolor}
\colorlet{subsectioncolor}{cvsubsectioncolor}
\colorlet{itemtextcolor}{black!90}
% colors for document body (right column)
% let user define main color
\DeclareOptionX{maincolor}{\colorlet{maincolor}{#1}}
\DeclareOptionX{sidecolor}{\colorlet{sidecolor}{#1}}
\DeclareOptionX{sidetextcolor}{\colorlet{sidetextcolor}{#1}}
\DeclareOptionX{sectioncolor}{\colorlet{sectioncolor}{#1}}
\DeclareOptionX{subsectioncolor}{\colorlet{subsectioncolor}{#1}}
\DeclareOptionX{itemtextcolor}{\colorlet{itemtextcolor}{#1}}
% set page margins
\newlength\sidebarwidth%
\newlength\topbottommargin%
\newlength\leftrightmargin%
\newlength\sidebartextwidth
% default values
\setlength{\sidebarwidth}{0.34\paperwidth}
\setlength{\topbottommargin}{0.02\paperheight}
\setlength{\leftrightmargin}{0.02\paperwidth}
% user overwrites
\DeclareOptionX{sidebarwidth}{\setlength{\sidebarwidth}{#1}}
\DeclareOptionX{topbottommargin}{\setlength{\topbottommargin}{#1}}
\DeclareOptionX{leftrightmargin}{\setlength{\leftrightmargin}{#1}}

% profile picture settings
\newlength\profilepicsize%
\setlength{\profilepicsize}{0.7\sidebarwidth}
\DeclareOptionX{profilepicsize}{\setlength{\profilepicsize}{#1}}
\newlength\profilepicborderwidth%
\setlength{\profilepicborderwidth}{3.5pt}
\DeclareOptionX{profilepicborderwidth}{\setlength{\profilepicborderwidth}{#1}}
\newcommand*{\profilepicstyle}{}
\DeclareOptionX{profilepicstyle}{\renewcommand{\profilepicstyle}{#1}}
\newcommand*{\profilepiczoom}{}
\DeclareOptionX{profilepiczoom}{\renewcommand{\profilepiczoom}{#1}}
\newlength\profilepicxshift
\setlength{\profilepicxshift}{0mm}
\DeclareOptionX{profilepicxshift}{\setlength{\profilepicxshift}{#1}}
\newlength\profilepicyshift
\setlength{\profilepicyshift}{0mm}
\DeclareOptionX{profilepicyshift}{\setlength{\profilepicyshift}{#1}}
\newlength\profilepicrounding
\setlength{\profilepicrounding}{0.15\sidebarwidth}
\DeclareOptionX{profilepicrounding}{\setlength{\profilepicrounding}{#1}}

% sidebar settings
\newcommand*{\sidebarplacement}{}
\DeclareOptionX{sidebarplacement}{\renewcommand{\sidebarplacement}{#1}}
\newcommand*{\sidesectionsize}{\huge}
\DeclareOptionX{sidesectionsize}{%
	\expandafter\renewcommand{\sidesectionsize}{\csname #1\endcsname}%
}

% show front sidebar on all pages
\newtoggle{tsamesidebar}
\togglefalse{tsamesidebar}
\DeclareOptionX{frontsidebaronallpages}{
	\toggletrue{tsamesidebar}
	\AddToHook{shipout/before}{\makefrontsidebar}
}

% logo settings
\newlength\logowidth%
\setlength{\logowidth}{\profilepicsize}
\DeclareOptionX{logowidth}{\setlength{\logowidth}{#1}}
\newlength\logospace%
\DeclareOptionX{logospace}{\setlength{\logospace}{#1}}
\newcommand*{\logoposition}{}
\DeclareOptionX{logoposition}{\renewcommand{\logoposition}{#1}}

% show sidebar and page margins
\newtoggle{tshowframes}
\togglefalse{tshowframes}
\DeclareOptionX{showframes}{
	\geometry{showframe}
	\TPoptions{showboxes=true}
	\toggletrue{tshowframes}
	% adding \hline in \newenvironment directly doesn't work, so do it here...
	\AtBeginDocument{\apptocmd{\personaldata}{\hline}{}{}}
}

% name and job position: 'after' (default) picture, 'before', or hidden (any other value)
\newcommand*{\nameandjobposition}{after}
\DeclareOptionX{nameandjobposition}{\renewcommand{\nameandjobposition}{#1}}

% draw vertical guideline
\newcommand{\plotvline}{}
\DeclareOptionX{vline}{%
	% must be defined here as macro, b/c tikz won't expand absolute length in
	% \backgroundsetup -- BUG?
	\renewcommand{\plotvline}{%
		\draw [thick, red, opacity=0.7]
		(\leftrightmargin + #1, 0) -- (\leftrightmargin + #1, -\paperheight);
	}
}

% date column width
\newlength\datecolwidth
\setlength{\datecolwidth}{0.17\textwidth}
\DeclareOptionX{datecolwidth}{\setlength{\datecolwidth}{#1}}

% pass further options to base class and load it
\DeclareOptionX*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptionsX\relax
\LoadClass{article}

% compute "inner" margin of sidebar automatically;
% must come after \sidebarwidth and \leftrightmargin possibly changed by user
\setlength{\sidebartextwidth}{\sidebarwidth - 2\leftrightmargin}

% let geometry package perform the changes;
% must come after loading the base class to prevent overwriting
\ifthenelse{\equal{\sidebarplacement}{right}}{%
	\geometry{
		top=\topbottommargin,
		bottom=\topbottommargin,
		right=\sidebarwidth + \leftrightmargin,
		left=\leftrightmargin,
	}
}{% else
	\geometry{
		top=\topbottommargin,
		bottom=\topbottommargin,
		left=\sidebarwidth + \leftrightmargin,
		right=\leftrightmargin,
	}
}

%-------------------------------------------------------------------------------
%                              REQUIRED PACKAGES
%-------------------------------------------------------------------------------
% use as workaround for spacing problem when TikZ picture is not in paragraph;
% details: https://tex.stackexchange.com/a/435790
\RequirePackage[texcoord]{eso-pic}

% for easy section style definitions
\RequirePackage{titlesec}

% loads graphicx, provides align=c option for vertical alignment w.r.t. text
\RequirePackage{graphbox}

% provides X column type for automatic length calculations
\RequirePackage{tabularx}
\RequirePackage{longtable, tabu}

% take care of compiler-specific packages
\RequirePackage{ifluatex}
\RequirePackage{ifxetex}
\newif\ifxetexorluatex
\ifxetex
	\xetexorluatextrue
\else
	\ifluatex
		\xetexorluatextrue
	\else
		\xetexorluatexfalse
	\fi
\fi

% pictures, icons and drawings
\ifxetexorluatex
	\RequirePackage{academicons}
\fi
\RequirePackage{fontawesome5}
\RequirePackage{tikz}
\usetikzlibrary{arrows, backgrounds}

% provides \xrfill for horizontal rules
\RequirePackage{xhfill}

% enable multiple optional arguments in macros
\RequirePackage{xparse}

% enable links
\RequirePackage[hidelinks]{hyperref}


%-------------------------------------------------------------------------------
%                          DERIVED COLOR DEFINITIONS
%-------------------------------------------------------------------------------
% profile section color (sidebar/left column)
\colorlet{pseccolor}{maincolor!90}
% color used for all icon arguments
\colorlet{iconcolor}{maincolor!90}

% color definitions for TikZ drawings
\colorlet{wheelchartlabelcolor}{black}
\colorlet{wheeltextcolor}{black!80!white}
% color of unfilled skill points / bar / chart label
\colorlet{skillbg}{black!25}


%-------------------------------------------------------------------------------
%                      GLOBAL LAYOUT AND HEADINGS STYLE
%-------------------------------------------------------------------------------
% remove headers and footers
\pagestyle{empty}

% globally disable paragraph indentation
\setlength{\parindent}{0pt}

% set space between paragraphs
% \setlength{\parskip}{1ex}

% creates a rule after some text using remaining line width
% usage: \xrfill[<raise>]{<width>}
\newcommand*{\sectionline}[1]{#1~\xrfill[.5ex]{1pt}[pseccolor]}

% section style for cv table headings in right column
% \titleformat{<command>}[<shape>]{<format>}{<label>}{<sep>}{<before>}[<after>]
\newcommand*{\cvsection}[1]{\section*{#1}}
\titleformat{\section}%
	{\color{sectioncolor}\normalfont\bfseries\LARGE}{}{0pt}{}
\titlespacing*{\section}{0pt}{1.5ex}{1ex}

% grey subsection style for right column
\newcommand*{\cvsubsection}[1]{\subsection*{#1}}
\titleformat{\subsection}%
	{\color{subsectioncolor}\normalfont\large}{}{0pt}{}

% for compatibility with older versions
\newcommand*{\profilesection}[1]{\subsubsection*{#1}}
% abuse subsubsection as sidesection in left column
\newcommand*{\sidesection}[1]{\subsubsection*{#1}}
\titleformat{\subsubsection}%
	{\color{pseccolor}\normalfont\sidesectionsize}{}{0pt}%
	{\color{pseccolor}\sectionline}%
% set spaces before and after sidesections: <left><before><after>
% "starred version kills the indentation of the paragraph following the title"
\titlespacing*{\subsubsection}{0pt}{1ex}{1ex}


%-------------------------------------------------------------------------------
%                              SIDEBAR ELEMENTS
%-------------------------------------------------------------------------------
% text in user-specific color
\newcommand{\sidetext}[1]{\textcolor{sidetextcolor}{#1}}

% style for name
\newcommand*{\cvnameformat}{\Huge\color{maincolor}}

% style for job title
\newcommand*{\cvjobtitleformat}{\Large\color{black!80}}

% mandatory personal information
\newcommand*{\cvname}[1]{\renewcommand{\cvname}{#1}}
\newcommand*{\cvjobtitle}[1]{\renewcommand{\cvjobtitle}{#1}}

% profile picture (optional)
\newcommand{\plotprofilepicture}{}
\newcommand*{\cvprofilepic}[1]{
	\renewcommand{\cvprofilepic}{#1}

	\ifthenelse{\equal{\profilepicstyle}{profilecircle}}{
		\renewcommand{\plotprofilepicture}{\profilecircle}
	}{
		\renewcommand{\plotprofilepicture}{\profileroundedcorners}
	}
}

% additional logo (optional)
\newcommand{\plotlogobefore}{}
\newcommand{\plotlogoafter}{}
\newcommand*{\cvlogopic}[1]{%
	% default = before; if any other (incl. 'after') --> after
	\ifthenelse{\equal{\logoposition}{before}}{%
		\renewcommand{\plotlogobefore}{%
			\begin{figure}\centering%
				\includegraphics[align=c, width=\logowidth]{#1}%
			\end{figure}
			\vspace*{\logospace}%
		}%
	}{%
		\renewcommand{\plotlogoafter}{%
			\vspace*{\logospace}%
			\begin{figure}\centering%
				\includegraphics[align=c, width=\logowidth]{#1}%
			\end{figure}
		}%
	}
}

% social network item; \social{<icon>}{<url>}{<text>}
\newcommand*{\social}[3]{%
	\socialicon{#1} & \href{#2}{\sidetext{#3}}\\%
}

% personal information item; \personal{<icon>}{<text>}
\newcommand*{\personal}[2]{%
	\circleicon{#1} & {\sidetext{#2}}\\%
}

% other personal information as macro that can be used later. Usage:
% \cvcustomdata{<Icon>}{<Text>}
% icon can be taken from FontAwesome or Academicon for example
\newcommand{\personaldata}{}
\newcommand*{\cvcustomdata}[2]{%
	\apptocmd{\personaldata}{\personal{#1}{#2}}{}{}%
}

% useful shortcuts
% NOTE: we use href instead of url so user can decide textformatting since url
% automatically uses \texttt{} as format for the url
\newcommand*{\cvbirthday}[1]{\cvcustomdata{\faUser}{#1}}
\newcommand*{\cvaddress}[1]{\cvcustomdata{\faEnvelope}{#1}}
\newcommand*{\cvphone}[1]{\cvcustomdata{\faPhone}{\href{tel:#1}{#1}}}
\newcommand*{\cvsite}[1]{\cvcustomdata{\faGlobe}{\href{#1}{#1}}}
\newcommand*{\cvmail}[1]{\cvcustomdata{\faAt}{\href{mailto:#1}{#1}}}
\newcommand*{\cvkey}[2]{\cvcustomdata{\faKey}{%
	\href{https://keyserver.ubuntu.com/pks/lookup?search=#2\&op=vindex\&fingerprint=on}{#1}%
}}

% TODO find a cleaner solution for consistent spacing
\newcommand{\nameandjob}{%
	{\cvnameformat\cvname}\par%
	\setlength{\parskip}{2ex}
	{\cvjobtitleformat\cvjobtitle}\par%
	\setlength{\parskip}{1ex}
}

\newcommand{\nameandjobbeforepic}{%
	\ifthenelse{\equal{\nameandjobposition}{before}}{%
		\nameandjob
		\vspace{1ex}
	}{}
}
\newcommand{\nameandjobafterpic}{%
	\ifthenelse{\equal{\nameandjobposition}{after}}{%
		\vspace{1ex}
		\nameandjob
	}{}
}

\newcommand{\profileroundedcorners}{%
	\begin{figure}\centering
		% see TikZ/pgf v3.1.1 manual §2.11 (clipping), §14.5 (rounded corners),
		% §12 (scopes), §13.2 (coordinate systems)
		\begin{tikzpicture}[x=\profilepicsize, y=\profilepicsize]
			\begin{scope}
				\path[clip]
					(0, 0) [sharp corners] --
					(0, 1) [rounded corners=\profilepicrounding] --
					(1, 1) [sharp corners] --
					(1, 0) [rounded corners=\profilepicrounding] -- cycle;
				\node[anchor=center, inner sep=0pt, xshift=\profilepicxshift,
						yshift=\profilepicyshift] (profilepic) at (0.5, 0.5)
					{\includegraphics[width=\profilepiczoom\profilepicsize]
						{\cvprofilepic}};
			\end{scope}
			\ifdim \profilepicborderwidth > 0pt
				\begin{scope}
					\draw[line width=\profilepicborderwidth, color=iconcolor]
					(0, 0) [sharp corners] --
					(0, 1) [rounded corners=\profilepicrounding] --
					(1, 1) [sharp corners] --
					(1, 0) [rounded corners=\profilepicrounding] -- cycle;
				\end{scope}
			\fi
		\end{tikzpicture}
	\end{figure}
}

\newcommand{\profilecircle}{%
	\begin{figure}\centering
		\begin{tikzpicture}[x=\profilepicsize, y=\profilepicsize]
			\begin{scope}
				\clip (0, 0) circle (0.5);
				\node[anchor=center, inner sep=0pt, outer sep=0pt,
						xshift=\profilepicxshift, yshift=\profilepicyshift]
					(profilepic) at (0,0) {
				\includegraphics[width=\profilepiczoom\profilepicsize]
					{\cvprofilepic}};
			\end{scope}
			\ifdim \profilepicborderwidth > 0pt
				\begin{scope}
					\draw[line width=\profilepicborderwidth, color=iconcolor]
						(0, 0) circle (0.5\profilepicsize);
				\end{scope}
			\fi
		\end{tikzpicture}
	\end{figure}
}

% table with 2 columns for icons and text
% \icontable{<width 1st column>}{<space between columns>}{<arraystretch>}
\newenvironment{icontable}[3][1]%
{%
	\renewcommand{\arraystretch}{#1}% increase linespacing in tables; default=1
	\iftoggle{tshowframes}{%
		% https://tex.stackexchange.com/a/42331
		\tabularx{\sidebartextwidth}{|m{#2} | @{\hskip #3} | X|} \hline%
	}{%
		\tabularx{\sidebartextwidth}{m{#2} @{\hskip #3} X}%
	}
}{%
	\endtabularx%
}

% icon style for personal information
\newcommand*\circleicon[1]{%
	\tikz[baseline = (char.base)]{%
		\node[%
			shape=circle,%
			draw,%
			inner sep=1pt,%
			fill=iconcolor,%
			maincolor,%
			text=white,%
			minimum size=\hsize%
		] (char) {#1};%
	}%
}

% icon style for social network
\newcommand*{\socialicon}[1]{%
	\resizebox{\hsize}{!}{\textcolor{iconcolor}{#1}}%
}

% make sure about me text stays in textbox frame
\newcommand{\aboutme}[1]{\parbox[b]{\linewidth}{\sidetext{#1}}}

% uniform icon style for all skill icons, e.g. flags or fontawesome icons
\newcommand{\cvicon}[1]{\makebox[1em]{\color{iconcolor} #1}}
\newcommand{\flag}[1]{\includegraphics[align=c, width=1em]{#1}}

% \pointskill[<indent>]{<icon>}{<description>}{<points>}[<maxpoints>] creates
% | [indent] [icon]  description  \hfill  ● ● ● ○ ○ |
% -- inspired by arravc.cls by LianTze Lim: https://github.com/liantze/AltaCV
\NewDocumentCommand{\pointskill}{ O{0em} m m m O{5} }{%
	\hspace{#1} \cvicon{#2} ~ \sidetext{#3} \hfill%
	\foreach \x in {1,...,#5}{%
		\space%
		{\ifnumgreater{\x}{#4}{\color{skillbg}}{\color{iconcolor}}% from etoolbox
		% don't use totalheight; see https://tex.stackexchange.com/a/41014
		\raisebox{0.5\height-0.4ex}{\scriptsize\faCircle}%
		}
	}\par%
}

\newcommand{\barskill}[4][1ex]{
	% remove 1pt in width to prevent overfull box warnings
	\begin{tikzpicture}[x=\sidebartextwidth-1pt, y=#1]
			\draw[fill, skillbg, rounded corners=0.25em]
				(0, 0) rectangle (1, 1);
			\draw[fill, iconcolor!70, rounded corners=0.25em]
				(0, 0) rectangle (#4/100, 1);
			\node[above right] at (0, 1) {\cvicon{#2} ~ \sidetext{#3}};
	\end{tikzpicture}
	\par
}

% \skill[<indent>]{<icon>}{<description>} creates in sidebar
% | [indent] [icon]  some longer skill description  |
\newcommand{\skill}[3][0em]{
	\hspace{#1} \cvicon{#2} ~ \parbox{\linewidth-#1-2.5em}{\sidetext{#3}}%
	\hfill \par%
}

% label for wheel charts
\newcommand{\chartlabel}[2][skillbg]{%
	\begin{tikzpicture}
	\node[
		fill=#1!25, % interior color
		anchor=base,
		draw=#1, % line color
		rounded corners,
		inner xsep=1ex, % distance from left/right border to text
		inner ysep=0.75ex, % distance top/bottom border to text
		text height=1.5ex, % align text vertically in box (at least as resulting
		text depth=.25ex   % effect)
	]{\sidetext{#2}};%
	\end{tikzpicture}
}


\newenvironment{sidebarminipage}%
	{\begin{minipage}{\sidebartextwidth}}%
	{\end{minipage}}%


\newenvironment{memberships}[1][1em]%
{%
	\iftoggle{tshowframes}{%
		\tabularx{\sidebartextwidth}{|l | @{\hskip #1} | X|} \hline%
	}{%
		\tabularx{\sidebartextwidth}{l @{\hskip #1} X}%
	}
}{%
	\endtabularx%
}%


\newcommand{\membership}[3][4em]{
	\includegraphics[align=c,width=#1]{#2} & \sidetext{#3} \\[3ex]
}

% adapted from https://tex.stackexchange.com/a/82729
\newcommand{\wheelchart}[4][-90]{%
	\def\outerradius{#2}%
	\def\innerradius{#3}%
	% Calculate total
	\pgfmathsetmacro{\totalnum}{0}%
	\foreach\value/\colour/\name in {#4} {%
		\pgfmathparse{\value+\totalnum}%
		\global\let\totalnum=\pgfmathresult%
	}%
	\begin{tikzpicture}

		% Calculate the thickness and the middle line of the wheel
		\pgfmathsetmacro{\wheelwidth}{\outerradius-\innerradius}
		\pgfmathsetmacro{\midradius}{(\outerradius+\innerradius)/2}

		% Rotate so we start from the top
		\begin{scope}[rotate=#1, on background layer]
		% Loop through each value set. \cumnum keeps track of where we are in the
		% wheel
		\pgfmathsetmacro{\cumnum}{0}
		\foreach \value/\width/\colour/\name in {#4} {
			\pgfmathsetmacro{\newcumnum}{\cumnum + \value/\totalnum*360}

			% Calculate the percent value
			\pgfmathsetmacro{\percentage}{\value/\totalnum*100}
			% Calculate the mid angle of the colour segments to place the labels
			\pgfmathsetmacro{\midangle}{-(\cumnum+\newcumnum)/2}

			% This is necessary for the labels to align nicely
			\pgfmathparse{
				(-\midangle>180?"west":"east")
			} \edef\textanchor{\pgfmathresult}
			\pgfmathparse{
				(-\midangle>180?"flush left":"flush right")
			} \edef\textalign{\pgfmathresult}
			\pgfmathsetmacro\labelshiftdir{1-2*(-\midangle<180)}

			% Draw the color segments. Somehow, the \midrow units got lost, so
			% we add 'pt' at the end. Not nice...
			\filldraw[draw=white,fill=\colour]
				(-\cumnum:\outerradius)
				arc (-\cumnum:-(\newcumnum):\outerradius)
				-- (-\newcumnum:\innerradius)
				arc (-\newcumnum:-(\cumnum):\innerradius)
				-- cycle;

			% Draw the data labels
			\draw [*-,thin,wheelchartlabelcolor] node [append after command={
				(\midangle:\midradius pt) --
				(\midangle:\outerradius + 1ex) --
				(\tikzlastnode)}] at (\midangle:\outerradius + 1ex) [
				xshift=\labelshiftdir*0.5cm,inner sep=1ex,
				outer sep=0pt,
				text width=\width,
				anchor=\textanchor,
				align=\textalign,
				font=\small,
				text=wheeltextcolor
			]{\name};
			% Set the old cumulated angle to the new value
			\global\let\cumnum=\newcumnum
		}
		\end{scope}
	\end{tikzpicture}\par
}

\newcommand{\cvsignature}{
	\vfill
	{\large\bfseries\color{maincolor!70}\today \hfill \cvname}
}


%-------------------------------------------------------------------------------
%                               SIDEBAR LAYOUT
%-------------------------------------------------------------------------------
% draw sidebar background on current page
\newcommand{\drawSidebarBG}{%
	\AddToShipoutPictureBG*{%
		\ifthenelse{\equal{\sidebarplacement}{right}}{%
			\begin{tikzpicture}[remember picture, overlay]
				\node at (current page.north east)[
					rectangle,
					fill=sidecolor,
					anchor=north east,
					minimum width=\sidebarwidth,
					minimum height=\paperheight,
				]{};%
				% plot vertical red guideline
				\plotvline%
			\end{tikzpicture}%
		}{% else
			\begin{tikzpicture}[remember picture, overlay]
				\node[
					rectangle,
					fill=sidecolor,
					anchor=north west,
					minimum width=\sidebarwidth,
					minimum height=\paperheight,
				]{};%
				% plot vertical red guideline
				\plotvline%
			\end{tikzpicture}%
		}%
	}%
}%

% use textpos to position textblock within TikZ background; we have to use
% the starred version for absolute values here, b/c we use \pagewidth directly
% instead of \setlength{\TPHorizModule}{<dimen>}, which seems to be "absolute"
% as opposed to "relative" - strange but true.
\newenvironment{sidebar}{%
	\drawSidebarBG%
	\ifthenelse{\equal{\sidebarplacement}{right}}{%
		\begin{textblock*}{\sidebartextwidth}%
			(\paperwidth - \sidebarwidth + \leftrightmargin, \topbottommargin)
	}{% else
		\begin{textblock*}{\sidebartextwidth}(\leftrightmargin, \topbottommargin)
	}%
}{%
	\end{textblock*}%
}

% provide user interface for easily adding new sections in side bars
% default: empty sidebar
\newcommand{\frontsidebar}{}
\newcommand{\backsidebar}{}
\newcommand{\addtofrontsidebar}[1]{\apptocmd{\frontsidebar}{#1}{}{}}
\newcommand{\addtobacksidebar}[1]{\apptocmd{\backsidebar}{#1}{}{}}

\newcommand{\makefrontsidebar}{%
	\begin{sidebar}
		% most sidebar commands end with \par; increase space between them
		\setlength{\parskip}{1ex}

		% name and job - when \nameandjobposition = 'before'
		\nameandjobbeforepic

		% optionally insert logo picture before profile
		\plotlogobefore

		% optionally insert profile picture
		\plotprofilepicture

		% optionally insert logo picture after profile
		\plotlogoafter

		% name and job - when \nameandjobposition = 'after'
		\nameandjobafterpic

		% personal information
		\vspace*{0.5em}
		\begin{icontable}[1.6]{1.7em}{0.4em}
			\personaldata
		\end{icontable}

		% user definitions
		\frontsidebar
	\end{sidebar}
}

\newcommand{\makebacksidebar}{%
	\begin{sidebar}
		% begin with name instead of picture
		\nameandjob

		% make sure there is no space at top, but after cvjob
		\setlength{\parskip}{1ex}

		% user definitions
		\backsidebar
	\end{sidebar}
}


%-------------------------------------------------------------------------------
%                              LIST ENVIRONMENTS
%-------------------------------------------------------------------------------
% reduce space between table columns to minimum
\setlength{\tabcolsep}{0pt}

% cv list environment --> table, left aligned, width=textwidth
% tabular starred version adds space to make table as wide as \textwidth here
\newenvironment{cvtable}[1][1]{%
	\renewcommand{\arraystretch}{#1}%
	% remove additional spacing before and after longtables
	\setlength{\LTpre}{0pt}
	\setlength{\LTpost}{0pt}
	\iftoggle{tshowframes}{%
		\begin{longtabu} to \textwidth {@{\extracolsep{\fill}}|l|l|}%
		\hline%
	}{%
		\begin{longtabu} to \textwidth {@{\extracolsep{\fill}}ll}%
	}
}{%
	\iftoggle{tshowframes}{%
		\hline%
		\end{longtabu}%
	}{%
		\end{longtabu}%
	}
}

% | <keyword>      <one-line description>            |
% use parbox if text needs to use multiple lines
\newcommand{\cvitemshort}[2]{%
	\parbox[t]{\datecolwidth}{\raggedright #1}
	& \parbox[t]{0.98\textwidth-\datecolwidth}{#2} \\}

% | <date>         <bold-title>  \hfill  <location>  |
% |                <longer description>              |
% or, if description is empty:
% | <date>         <title>       \hfill  <location>  |
\newcommand{\cvitem}[4]{%
	\parbox[t]{\datecolwidth}{\raggedright #1} &%
	\parbox[t]{0.98\textwidth-\datecolwidth}{%
		\if\relax\detokenize{#4}\relax%
			\parbox[t]{\linewidth-\widthof{\footnotesize #3}-1em}{\raggedright #2}%
			\hfill {\footnotesize#3}%
		\else%
			\parbox[t]{\linewidth-\widthof{\footnotesize #3}-1em}{\raggedright \textbf{#2}}%
			\hfill {\footnotesize#3} \\%
			\textcolor{itemtextcolor}{#4}%\vspace{\parsep}%
		\fi%
	}\\
}

% | <date>         <bold-title>  \par\hfill  <location>  |
% |                <longer description>              |
% or, if description is empty:
% | <date>         <title>       \par\hfill  <location>  |
\newcommand{\cvitempar}[4]{%
	\parbox[t]{\datecolwidth}{\raggedright #1} &%
	\parbox[t]{0.98\textwidth-\datecolwidth}{%
		\if\relax\detokenize{#4}\relax%
			\parbox[t]{\textwidth}{\raggedright #2}%
			\par\hfill {\footnotesize#3}%
		\else%
			\parbox[t]{\textwidth}{\raggedright \textbf{#2}}%
			\par\hfill {\footnotesize#3} \\%
			\textcolor{itemtextcolor}{#4}%\vspace{\parsep}%
		\fi%
	}\\
}

% publication item
% \cvpubitem{<title>}{<author>}{<journal>}{<year>} will produce
% | <year>         <bold title>                      |
% |                <italic author>                   |
% |                <journal>                         |
\newcommand{\cvpubitem}[4]{%
	\parbox[t]{\datecolwidth}{\raggedright #4} &
	\parbox[t]{0.98\textwidth-\datecolwidth}{%
		\textbf{#1} \par \textit{#2} \par #3 \vspace{\parsep}%
	}\\
}

% EOF - fortysecondscv.cls
