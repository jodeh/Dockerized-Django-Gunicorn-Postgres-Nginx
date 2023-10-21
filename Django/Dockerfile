FROM python:3

RUN pip install --upgrade pip

ENV PYTHONUNBUFFERED=1
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY . /code/
COPY ./entrypoint.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]

