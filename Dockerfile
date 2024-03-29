ARG PYTHON_VERSION=3.10-slim-buster

FROM python:${PYTHON_VERSION}

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN mkdir -p /code

WORKDIR /code

COPY requirements.txt /tmp/requirements.txt
COPY secrets.json /MercadoControl_backend/secrets.json


RUN set -ex && \
    apt-get update && \
    apt-get -y install libpq-dev gcc && \
    pip install psycopg2 && \
    pip install --upgrade pip && \
    pip install gunicorn \
    pip install -r /tmp/requirements.txt && \
    rm -rf /root/.cache/

COPY . /code/

RUN #python manage.py collectstatic --noinput
RUN #python manage.py migrate

EXPOSE 8000

# replace demo.wsgi with <project_name>.wsgi
CMD ["gunicorn", "--bind", ":8000", "--workers", "2", "parchateApp.wsgi:application"]
