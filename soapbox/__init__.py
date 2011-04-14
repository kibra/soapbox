from pyramid.config import Configurator
from pyramid.authentication import AuthTktAuthenticationPolicy
from pyramid_beaker import session_factory_from_settings
from soapbox.resources import Root

def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    authentication_policy = AuthTktAuthenticationPolicy('seekrit')
    config = Configurator(root_factory=Root, settings=settings, authentication_policy=authentication_policy)
    config.include('pyramid_handlers')
    config.add_handler('box_index', '/box', handler='soapbox.handlers.Box', action='index')
    config.add_handler('box', '/box/{action}', handler='soapbox.handlers.Box')
    config.add_handler('home', '/{action}', handler='soapbox.handlers.Home')
    config.add_handler('home_index', '/', handler='soapbox.handlers.Home', action='index')
    config.add_handler('messages', '/messages/{action}', handler='soapbox.handlers.Messages')
    config.add_handler('auth', '/auth/{action}', handler='soapbox.handlers.Auth')
    config.add_handler('json_message', '/json/message/{pubid}', handler='soapbox.handlers.JSON', action='message')
    config.add_handler('json_pages', '/json/{action}/{page}', handler='soapbox.handlers.JSON')
    config.add_handler('json', '/json/{action}', handler='soapbox.handlers.JSON')
    config.add_handler('jsons', '/json/{action}/', handler='soapbox.handlers.JSON')
    config.add_handler('tests', '/tests/{action}', handler='soapbox.handlers.Tests')
    config.add_static_view('static', 'soapbox:static')
    session_factory = session_factory_from_settings(settings)
    config.begin()
    config.set_session_factory(session_factory)
    config.end()
    return config.make_wsgi_app()		
