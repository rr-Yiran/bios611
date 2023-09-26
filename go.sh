#! /bin/bash

docker build . -t 611
docker run --rm -v $(pwd):/home/rstudio/work -p 8787:8787 -e PASSWORD=yourpassword -it 611