from celery import group
from celery.schedules import crontab
from tasks import hello, app

print(hello.delay().get(timeout=10))
# group(hello.s() for i in range(100000))().get()
