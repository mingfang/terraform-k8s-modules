import random
from director import task


@task(name="RANDOM")
def generate_random(*args, **kwargs):
    payload = kwargs["payload"]
    return random.randint(payload.get("start", 0), payload.get("end", 10))


@task(name="ADD")
def add_randoms(*args, **kwargs):
    return sum(args[0])
