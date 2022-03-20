from datetime import timedelta
import logging
import math
import os
from cachelib.redis import RedisCache
from celery.schedules import crontab
from flask_appbuilder.security.manager import AUTH_REMOTE_USER, AUTH_OAUTH
from superset.security import SupersetSecurityManager

logger = logging.getLogger()


def env(key, default=None):
    return os.getenv(key, default)


DATABASE_DIALECT = env("DATABASE_DIALECT")
DATABASE_USER = env("DATABASE_USER")
DATABASE_PASSWORD = env("DATABASE_PASSWORD")
DATABASE_HOST = env("DATABASE_HOST")
DATABASE_PORT = env("DATABASE_PORT")
DATABASE_DB = env("DATABASE_DB")

# The SQLAlchemy connection string.
SQLALCHEMY_DATABASE_URI = "%s://%s:%s@%s:%s/%s" % (
    DATABASE_DIALECT,
    DATABASE_USER,
    DATABASE_PASSWORD,
    DATABASE_HOST,
    DATABASE_PORT,
    DATABASE_DB,
)

REDIS_HOST = env("REDIS_HOST")
REDIS_PORT = env("REDIS_PORT", "6379")
REDIS_CELERY_DB = env("REDIS_CELERY_DB", "0")
REDIS_RESULTS_DB = env("REDIS_RESULTS_DB", "1")
REDIS_CACHE_DB = env("REDIS_CACHE_DB", "2")

FEATURE_FLAGS = {
    "ALERT_REPORTS": True,
    "ENABLE_TEMPLATE_PROCESSING": True,
    "DASHBOARD_CROSS_FILTERS": True,
}
ALERT_REPORTS_NOTIFICATION_DRY_RUN = True
CSRF_ENABLED = True
ENABLE_PROXY_FIX = True
SQLLAB_CTAS_NO_LIMIT = True
WEBDRIVER_BASEURL = "http://superset:8088/"
# The base URL for the email report hyperlinks.
WEBDRIVER_BASEURL_USER_FRIENDLY = WEBDRIVER_BASEURL

SECRET_KEY = env("SECRET_KEY")
MAPBOX_API_KEY = env('MAPBOX_API_KEY', '')

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


#  Celery


class CeleryConfig(object):
    BROKER_URL = f'redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_CELERY_DB}'
    CELERY_IMPORTS = ('superset.sql_lab', "superset.tasks")
    CELERY_RESULT_BACKEND = f'redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_RESULTS_DB}'
    CELERYD_LOG_LEVEL = 'info'
    CELERYD_PREFETCH_MULTIPLIER = 1
    CELERY_ACKS_LATE = False
    CELERYBEAT_SCHEDULE = {
        'reports.scheduler': {
            'task': 'reports.scheduler',
            'schedule': crontab(minute='*', hour='*'),
        },
        'reports.prune_log': {
            'task': 'reports.prune_log',
            'schedule': crontab(minute=10, hour=0),
        },
        'cache-warmup-hourly': {
            'task': 'cache-warmup',
            'schedule': crontab(minute='*/30', hour='*'),
            'kwargs': {
                'strategy_name': 'top_n_dashboards',
                'top_n': 10,
                'since': '7 days ago',
            },
        },
    }


CELERY_CONFIG = CeleryConfig

# SSO

AUTH_USER_REGISTRATION = True
AUTH_USER_REGISTRATION_ROLE = 'Alpha'
PUBLIC_ROLE_LIKE = 'Gamma'

AUTH_TYPE = AUTH_OAUTH
OAUTH_PROVIDERS = [
    {
        'name': 'keycloak',
        'token_key': 'access_token',
        'icon': 'fa-address-card',
        'remote_app': {
            'client_id': 'superset-example',
            'client_secret': '8daf544f-23c3-47d9-aaba-c1fbb4aaf242',
            'client_kwargs': {
                'scope': 'openid email profile'
            },
            'server_metadata_url': 'https://keycloak.rebelsoft.com/auth/realms/rebelsoft/.well-known/openid-configuration',
            'api_base_url': 'https://keycloak.rebelsoft.com/auth/realms/rebelsoft/protocol/openid-connect/',
        }
    }
]


class CustomSsoSecurityManager(SupersetSecurityManager):

    def oauth_user_info(self, provider, response=None):
        logging.info(f'Oauth2 provider: {provider}.')

        if provider == 'keycloak':
            me = self.appbuilder.sm.oauth_remotes[provider].get('userinfo').json()

            logger.info(" user_data: %s", me)
            return {
                'username': me['preferred_username'],
                'name': me['name'],
                'email': me['email'],
                'first_name': me['given_name'],
                'last_name': me['family_name'],
                'roles': me.get('roles', ['Public']),
                'is_active': True,
            }

    def auth_user_oauth(self, userinfo):
        user = super(CustomSsoSecurityManager, self).auth_user_oauth(userinfo)
        roles = [self.find_role(x) for x in userinfo['roles']]
        roles = [x for x in roles if x is not None]
        user.roles = roles
        logger.info(' Update <User: %s> role to %s', user.username, roles)
        self.update_user(user)  # update user roles
        return user


CUSTOM_SECURITY_MANAGER = CustomSsoSecurityManager
