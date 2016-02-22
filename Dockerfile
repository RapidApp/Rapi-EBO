FROM rapi/psgi:1.1005
MAINTAINER Henry Van Styn <vanstyn@cpan.org>

RUN cpanm \
 DateTime::Format::Flexible \
 && rm -rf .cpanm/

# docker build -t rapi-ebo .
# docker create --name ebo -tip 5009:5000 -v `pwd`:/opt/app rapi-ebo
# docker start ebo
