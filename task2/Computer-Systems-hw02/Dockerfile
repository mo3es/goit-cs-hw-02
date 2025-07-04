FROM python:3.10

ENV MAIN_HOME /main

WORKDIR $MAIN_HOME

COPY . .

RUN pip install -r requirements.txt

EXPOSE 5000

ENTRYPOINT ["python", "main.py"]