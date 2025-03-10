import logging
from superset.security import SupersetSecurityManager


class KeycloakSecurityManager(SupersetSecurityManager):

    def oauth_user_info(self, provider, response=None):
        logging.info(f'Oauth2 provider: {provider}.')

        if provider == 'keycloak':
            me = self.appbuilder.sm.oauth_remotes[provider].get('userinfo').json()

            logging.info(" user_data: %s", me)
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
        user = super(KeycloakSecurityManager, self).auth_user_oauth(userinfo)
        roles = [self.find_role(x) for x in userinfo['roles']]
        roles = [x for x in roles if x is not None]
        user.roles = roles
        logging.info(' Update <User: %s> role to %s', user.username, roles)
        self.update_user(user)
        return user
