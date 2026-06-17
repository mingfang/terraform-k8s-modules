from celery.schedules import crontab
from tasks import hello, app


@app.on_after_configure.connect
def setup_periodic_tasks(sender, **kwargs):
    sender.add_periodic_task(10.0, hello.s(), name='add every 10')
