
FROM quay.io/codait/max-base:v1.4.0

ARG model_bucket=https://max-cdn.cdn.appdomain.cloud/max-image-caption-generator/1.0.0
ARG model_file=assets.tar.gz

RUN wget -nv --show-progress --progress=bar:force:noscroll ${model_bucket}/${model_file} --output-document=assets/${model_file} && \
  tar -x -C assets/ -f assets/${model_file} -v && rm assets/${model_file}

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

RUN sha512sum -c sha512sums.txt

EXPOSE 5000

CMD python app.py
