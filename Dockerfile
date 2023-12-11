FROM amoselb/rstudio-m1

# Update and install dependencies including Pandoc
RUN apt update && \
    apt install -y man-db pandoc && \
    rm -rf /var/lib/apt/lists/*

RUN yes|unminimize

# Install LaTeX (TeX Live), lmodern package, and xcolor package
RUN apt-get update && apt-get install -y texlive-latex-base texlive-fonts-recommended texlive-fonts-extra \
    && apt-get install -y lmodern texlive-xetex

RUN R -e "install.packages('BiocManager')"
RUN R -e "install.packages('caret')"
RUN R -e "BiocManager::install('ggplot2')"
RUN R -e "BiocManager::install('ggpubr')"
RUN R -e "install.packages('GGally')"
RUN R -e "install.packages('pROC')"

RUN Rscript --no-restore --no-save -e "tinytex::tlmgr_install(c('wrapfig','ec','ulem','amsmath','capt-of'))"
RUN Rscript --no-restore --no-save -e "tinytex::tlmgr_install(c('hyperref','iftex','pdftexcmds','infwarerr'))"
RUN Rscript --no-restore --no-save -e "tinytex::tlmgr_install(c('kvoptions','epstopdf','epstopdf-pkg'))"
RUN Rscript --no-restore --no-save -e "tinytex::tlmgr_install(c('hanging','grfext'))"
RUN Rscript --no-restore --no-save -e "tinytex::tlmgr_install(c('etoolbox','xcolor','geometry'))"
