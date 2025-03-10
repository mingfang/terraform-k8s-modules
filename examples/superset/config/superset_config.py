# https://github.com/apache/superset/blob/master/docker/pythonpath_dev/superset_config.py

import logging
import os
from datetime import timedelta
from typing import Optional
import math

from cachelib.redis import RedisCache
from celery.schedules import crontab
from flask_appbuilder.security.manager import AUTH_REMOTE_USER, AUTH_OAUTH

logger = logging.getLogger()


def get_env_variable(var_name: str, default: Optional[str] = None) -> str:
    """Get the environment variable or raise exception."""
    try:
        return os.environ[var_name]
    except KeyError:
        if default is not None:
            return default
        else:
            error_msg = "The environment variable {} was missing, abort...".format(
                var_name
            )
            raise EnvironmentError(error_msg)


DATABASE_DIALECT = get_env_variable("DATABASE_DIALECT")
DATABASE_USER = get_env_variable("DATABASE_USER")
DATABASE_PASSWORD = get_env_variable("DATABASE_PASSWORD")
DATABASE_HOST = get_env_variable("DATABASE_HOST")
DATABASE_PORT = get_env_variable("DATABASE_PORT")
DATABASE_DB = get_env_variable("DATABASE_DB")

# The SQLAlchemy connection string.
SQLALCHEMY_DATABASE_URI = "%s://%s:%s@%s:%s/%s" % (
    DATABASE_DIALECT,
    DATABASE_USER,
    DATABASE_PASSWORD,
    DATABASE_HOST,
    DATABASE_PORT,
    DATABASE_DB,
)

REDIS_HOST = get_env_variable("REDIS_HOST")
REDIS_PORT = get_env_variable("REDIS_PORT")
REDIS_CELERY_DB = get_env_variable("REDIS_CELERY_DB", "0")
REDIS_RESULTS_DB = get_env_variable("REDIS_RESULTS_DB", "1")
REDIS_CACHE_DB = get_env_variable("REDIS_CACHE_DB", "2")

CACHE_CONFIG = {
    "CACHE_TYPE": "redis",
    "CACHE_DEFAULT_TIMEOUT": 300,
    "CACHE_KEY_PREFIX": "superset_",
    "CACHE_REDIS_HOST": REDIS_HOST,
    "CACHE_REDIS_PORT": REDIS_PORT,
    "CACHE_REDIS_DB": REDIS_RESULTS_DB,
}
DATA_CACHE_CONFIG = CACHE_CONFIG


class CeleryConfig(object):
    broker_url = f"redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_CELERY_DB}"
    imports = ("superset.sql_lab",)
    result_backend = f"redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_RESULTS_DB}"
    worker_prefetch_multiplier = 1
    task_acks_late = False
    beat_schedule = {
        "reports.scheduler": {
            "task": "reports.scheduler",
            "schedule": crontab(minute="*", hour="*"),
        },
        "reports.prune_log": {
            "task": "reports.prune_log",
            "schedule": crontab(minute=10, hour=0),
        },
    }


CELERY_CONFIG = CeleryConfig

# https://github.com/apache/superset/blob/master/RESOURCES/FEATURE_FLAGS.md

FEATURE_FLAGS = {
    "ALERT_REPORTS": True,
    "ENABLE_TEMPLATE_PROCESSING": True,
    # "DASHBOARD_CROSS_FILTERS": True,
    "EMBEDDED_SUPERSET": True,
    "ENABLE_JAVASCRIPT_CONTROLS": True,
    "TAGGING_SYSTEM": True,
    "OMNIBAR": True,
    "DASHBOARD_NATIVE_FILTERS": False,
}

ALERT_REPORTS_NOTIFICATION_DRY_RUN = True
WEBDRIVER_BASEURL = "http://superset:8088/"
# The base URL for the email report hyperlinks.
WEBDRIVER_BASEURL_USER_FRIENDLY = WEBDRIVER_BASEURL

SQLLAB_CTAS_NO_LIMIT = True
CSRF_ENABLED = True
ENABLE_PROXY_FIX = True

SECRET_KEY = get_env_variable("SECRET_KEY")

# Caches

CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_DEFAULT_TIMEOUT": int(timedelta(minutes=1).total_seconds()),
    "CACHE_KEY_PREFIX": "superset_cache",
    "CACHE_REDIS_URL": f"redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_CACHE_DB}",
}
DATA_CACHE_CONFIG = {
    **CACHE_CONFIG,
    "CACHE_DEFAULT_TIMEOUT": int(timedelta(seconds=30).total_seconds()),
    "CACHE_KEY_PREFIX": "superset_data_cache",
}
FILTER_STATE_CACHE_CONFIG = {
    "CACHE_THRESHOLD": math.inf,
    "CACHE_DEFAULT_TIMEOUT": int(timedelta(minutes=10).total_seconds()),
}
EXPLORE_FORM_DATA_CACHE_CONFIG = {
    "CACHE_THRESHOLD": math.inf,
    "CACHE_DEFAULT_TIMEOUT": int(timedelta(minutes=10).total_seconds()),
}
RESULTS_BACKEND = RedisCache(host=REDIS_HOST, port=REDIS_PORT, key_prefix='superset_results')



# auto user registration

AUTH_USER_REGISTRATION = True
AUTH_USER_REGISTRATION_ROLE = 'Alpha'
# PUBLIC_ROLE_LIKE = 'Gamma'

# Custom remote user auth

AUTH_TYPE = AUTH_REMOTE_USER
from CustomSecurityManager import CustomSecurityManager

CUSTOM_SECURITY_MANAGER = CustomSecurityManager

# Keycloak SSO
#
# AUTH_TYPE = AUTH_OAUTH
# OAUTH_PROVIDERS = [
#     {
#         'name': 'keycloak',
#         'token_key': 'access_token',
#         'icon': 'fa-address-card',
#         'remote_app': {
#             'client_id': 'superset-example',
#             'client_secret': '8daf544f-23c3-47d9-aaba-c1fbb4aaf242',
#             'client_kwargs': {
#                 'scope': 'openid email profile'
#             },
#             'server_metadata_url': 'https://keycloak.rebelsoft.com/auth/realms/rebelsoft/.well-known/openid-configuration',
#             'api_base_url': 'https://keycloak.rebelsoft.com/auth/realms/rebelsoft/protocol/openid-connect/',
#         }
#     }
# ]
#
#
# from KeycloakSecurityManager import KeycloakSecurityManager
# CUSTOM_SECURITY_MANAGER = KeycloakSecurityManager

#APP_NAME = "MyApp"
#APP_ICON = "https://justcreative.com/wp-content/uploads/2019/07/black-white-logos.jpg"

# from flask import Blueprint
# simple_page = Blueprint('simple_page', __name__,
#                         template_folder='templates')
# @simple_page.route('/', defaults={'page': 'index'})
# @simple_page.route('/<page>')
# def show(page):
#     return "Ok"
#
# BLUEPRINTS = [simple_page]

#update 3/23

#
# Optionally import superset_config_docker.py (which will have been included on
# the PYTHONPATH) in order to allow for local settings to be overridden
#
try:
    import superset_config_docker
    from superset_config_docker import *  # noqa

    logger.info(
        f"Loaded your Docker configuration at " f"[{superset_config_docker.__file__}]"
    )
except ImportError:
    logger.info("Using default Docker config...")