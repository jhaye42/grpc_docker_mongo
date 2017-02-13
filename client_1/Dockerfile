FROM 679668366598.dkr.ecr.eu-west-1.amazonaws.com/nbp/ruby
MAINTAINER jhaye.perso@gmail.com

RUN gem install grpc

COPY . $WORKING_DIR/

CMD ruby app/transaction_interface.rb