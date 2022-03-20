import logging
from flask import redirect, request
from flask_login import login_user
from flask_appbuilder import expose
from flask_appbuilder.security.manager import AuthRemoteUserView
from superset.security import SupersetSecurityManager


class CustomAuthRemoteUserView(AuthRemoteUserView):

    @expose("/login/")
    def login(self):
        # get user from headers
        email = request.headers.get('X-Auth-Request-Email')
        role = request.headers.get('X-Auth-Role', 'Admin')
        username = email.split('@')[0]
        logging.info(f'username: {username}, email: {email}, role: {role}')

        # auto register user
        sm = self.appbuilder.sm
        session = sm.get_session
        user = session.query(sm.user_model).filter_by(username=username).first()
        if user is None and username:
            sm.add_user(
                username=username,
                first_name=username,
                last_name='',
                email=email,
                role=role,
                is_active=True,
            )
            user = sm.auth_user_remote_user(username)

        # login user
        login_user(user)
        return redirect('/')


class CustomSecurityManager(SupersetSecurityManager):
    authremoteuserview = CustomAuthRemoteUserView
