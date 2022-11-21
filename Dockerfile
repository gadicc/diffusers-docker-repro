FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-devel

RUN mkdir /var/app
WORKDIR /var/app

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC
RUN apt-get update
RUN apt-get install -yq git

RUN pip install huggingface_hub
ARG HF_AUTH_TOKEN=""
ENV HF_AUTH_TOKEN=${HF_AUTH_TOKEN}
RUN echo "$HF_AUTH_TOKEN\ny" | huggingface-cli login 

RUN git clone https://github.com/huggingface/diffusers.git
WORKDIR /var/app/diffusers/src

RUN git checkout v0.6.0
RUN pip install transformers

ADD download.py .
RUN python download.py

RUN pip install accelerate
RUN pip install bitsandbytes
# 0=this machine, 0=no distributed training, NO=not cpu only, NO=no deepspeed, all, fp16
RUN echo "0\n0\nNO\nNO\nall\nfp16\n" | accelerate config

# RUN pip install pip install git+https://github.com/huggingface/diffusers@42bb459457d77d6185f74cbc32f2a08b08876af5

COPY instance_images instance_images
ADD train_dreambooth.py .
ADD train.sh .
RUN chmod a+x train.sh

# Since max_train_steps=1, let's run this to download necessary models too.
# RUN ./train.sh

ENTRYPOINT [ "/bin/bash" ]
