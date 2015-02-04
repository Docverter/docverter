# --------------------------------------------------------------------------
# This is a Dockerfile to build a Docverter Docker image
#
# Build a Docker image with a command like:
#
#     docker build -t docverter .
#
# And then run a container from that image with a command like:
#
#     docker run -it -p 5000:5000 docverter
# --------------------------------------------------------------------------

FROM jruby:1.7-onbuild
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C

RUN apt-get update && apt-get install -y \
    pandoc \
    pandoc-citeproc \
    pandoc-data \
    calibre \
    calibre-bin
EXPOSE 5000
CMD ["foreman", "start"]
